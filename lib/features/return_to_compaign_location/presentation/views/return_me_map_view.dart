import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../widgets/map_ui_components_widget.dart';
import '../widgets/route_map_widget.dart';
import '../../providers/camp_location_provider.dart';

class ReturnMeMapView extends ConsumerStatefulWidget {
  const ReturnMeMapView({super.key});

  @override
  ConsumerState<ReturnMeMapView> createState() => _ReturnMeMapViewState();
}

class _ReturnMeMapViewState extends ConsumerState<ReturnMeMapView> {
  final String orsApiKey = 'eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6ImExNzU1NTJjOTM5ZDQwMzliNDg4MTAyMWMwNjljYjJmIiwiaCI6Im11cm11cjY0In0=';
  final MapController _mapController = MapController();
  StreamSubscription<Position>? _positionSubscription;

  LatLng currentUserLocation = const LatLng(21.4180, 39.8570);
  List<LatLng> routePoints = [];
  String distanceText = "جاري الحساب..";
  LatLng? _lastTargetLocation;
  
  // 1. متغير التحكم في الدوران والتتبع
  bool isTrackingEnabled = true;
  // 2. متغير لتخزين زاوية الاتجاه الحالية للسهم
  double userHeading = 0.0;

  @override
  void initState() {
    super.initState();
    _startLocationTracking();
  }

  void _startLocationTracking() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 2,
      ),
    ).listen((Position position) {
      final newLocation = LatLng(position.latitude, position.longitude);

      if (mounted) {
        setState(() {
          currentUserLocation = newLocation;
          userHeading = position.heading; // تحديث اتجاه السهم 
        });

        // تنفيذ الدوران فقط إذا كان الزر مفعلاً
        if (isTrackingEnabled) {
          _mapController.moveAndRotate(newLocation, 17.0, position.heading);
        }

        if (_lastTargetLocation != null) {
          fetchRoute(newLocation, _lastTargetLocation!);
        }
      }
    });
  }

  Future<void> fetchRoute(LatLng start, LatLng target) async {
    final url = Uri.parse(
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$orsApiKey&start=${start.longitude},${start.latitude}&end=${target.longitude},${target.latitude}');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List coords = data['features'][0]['geometry']['coordinates'];

        if (mounted) {
          setState(() {
            routePoints = [start];
            routePoints.addAll(coords.map((c) => LatLng(c[1].toDouble(), c[0].toDouble())).toList());
            routePoints.add(target);
            distanceText = "${(data['features'][0]['properties']['segments'][0]['distance'] / 1000).toStringAsFixed(1)} كم";
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching route: $e");
    }
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final campLocationAsync = ref.watch(fetchCampLocationProvider);

    return Scaffold(
      body: campLocationAsync.when(
        data: (campData) {
          final LatLng targetLocation = campData != null
              ? LatLng(campData.latitude, campData.longitude)
              : const LatLng(21.4225, 39.8262);

          _lastTargetLocation = targetLocation;

          if (routePoints.isEmpty) {
            fetchRoute(currentUserLocation, targetLocation);
          }

          return Stack(
            children: [
              RouteMapWidget(
                campaignLocation: targetLocation,
                userLocation: currentUserLocation,
                routePoints: routePoints,
                mapController: _mapController,
              ),

              // زر إيقاف الدوران (Floating Action Button)
              Positioned(
                bottom: 110.h,
                right: 20.w,
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      isTrackingEnabled = !isTrackingEnabled;
                    });
                  },
                  child: Icon(
                    isTrackingEnabled ? Icons.explore : Icons.explore_off,
                    color: const Color(0xFFC09931),
                  ),
                ),
              ),

              _buildOverlayUI(),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),
    );
  }

  Widget _buildOverlayUI() {
    return Stack(
      children: [
        Positioned(top: 50.h, left: 0, right: 0, child: const Center(child: MapHeaderCapsule())),
        
        // زر التراجع
        Positioned(
          top: 50.h,
          right: 20.w,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 45.h, width: 45.h,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFC09931), size: 18),
            ),
          ),
        ),

        // زر المسافة السفلي مع تمرير زاوية الدوران للسهم
        Positioned(
          bottom: 40.h,
          left: 30.w,
          right: 30.w,
          child: MapBottomActionBtn(
            distance: distanceText,
            // ملاحظة: تأكد من تعديل الـ Widget لاستقبال الزاوية وتحريك السهم بها
            bearing: userHeading, 
          ),
        ),
      ],
    );
  }
}