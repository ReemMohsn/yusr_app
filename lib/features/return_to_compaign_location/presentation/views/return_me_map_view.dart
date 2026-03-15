import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import '../widgets/map_ui_components_widget.dart';
import '../widgets/route_map_widget.dart';

class ReturnMeMapView extends ConsumerStatefulWidget {
  const ReturnMeMapView({super.key});
  @override
  ConsumerState<ReturnMeMapView> createState() => _ReturnMeMapViewState();
}

class _ReturnMeMapViewState extends ConsumerState<ReturnMeMapView> {
  final String orsApiKey = 'eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6ImExNzU1NTJjOTM5ZDQwMzliNDg4MTAyMWMwNjljYjJmIiwiaCI6Im11cm11cjY0In0=';
  final LatLng campaignLocation = const LatLng(21.4225, 39.8262);
  final LatLng fakeUserLocation = const LatLng(21.4180, 39.8570);

  List<LatLng> routePoints = [];
  String distanceText = "جاري الحساب..";

  @override
  void initState() {
    super.initState();
    fetchRoute(fakeUserLocation);
  }

  // دالة جلب المسار (تبقى هنا أو تنقل لـ Service مستقلة لاحقاً)
  Future<void> fetchRoute(LatLng start) async {
    final url = Uri.parse('https://api.openrouteservice.org/v2/directions/driving-car?api_key=$orsApiKey&start=${start.longitude},${start.latitude}&end=${campaignLocation.longitude},${campaignLocation.latitude}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List coords = data['features'][0]['geometry']['coordinates'];
        setState(() {
          routePoints = coords.map((c) => LatLng(c[1].toDouble(), c[0].toDouble())).toList();
          distanceText = "${(data['features'][0]['properties']['segments'][0]['distance'] / 1000).toStringAsFixed(1)} كم";
        });
      }
    } catch (e) { debugPrint("Error: $e"); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الخريطة المنفصلة
          RouteMapWidget(
            campaignLocation: campaignLocation,
            userLocation: fakeUserLocation,
            routePoints: routePoints,
          ),
          // الواجهات العلوية
          Positioned(top: 50.h, left: 0, right: 0, child: const Center(child: MapHeaderCapsule())),
          // الزر السفلي
          Positioned(bottom: 40.h, left: 30.w, right: 30.w, child: MapBottomActionBtn(distance: distanceText)),
        ],
      ),
    );
  }
}