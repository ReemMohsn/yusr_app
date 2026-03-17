import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import '../data/repositories/map_repository.dart'; 

// حالة الخريطة (State)
class MapState {
  final LatLng userLocation;
  final List<LatLng> routePoints;
  final String distance;
  final double heading;
  final bool isTracking;

  MapState({
    required this.userLocation,
    required this.routePoints,
    required this.distance,
    required this.heading,
    required this.isTracking,
  });

  MapState copyWith({
    LatLng? userLocation,
    List<LatLng>? routePoints,
    String? distance,
    double? heading,
    bool? isTracking,
  }) {
    return MapState(
      userLocation: userLocation ?? this.userLocation,
      routePoints: routePoints ?? this.routePoints,
      distance: distance ?? this.distance,
      heading: heading ?? this.heading,
      isTracking: isTracking ?? this.isTracking,
    );
  }
}

// متحكم منطق الخريطة (Notifier)
class MapLogicNotifier extends StateNotifier<MapState> {
  final MapRepository _mapRepository = MapRepository();
  StreamSubscription<Position>? _positionSubscription;

  MapLogicNotifier() : super(MapState(
    userLocation: const LatLng(21.4180, 39.8570), // موقع افتراضي (مكة المكرمة)
    routePoints: const [],
    distance: "جاري الحساب..",
    heading: 0.0,
    isTracking: true,
  ));

  // بدء تتبع موقع المستخدم
  Future<void> startLocationTracking(MapController mapController, LatLng targetLocation) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    await _positionSubscription?.cancel();
    
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high, 
        distanceFilter: 2, // التحديث كل مترين لتقليل استهلاك البطارية والـ API
      ),
    ).listen((Position position) {
      final newLocation = LatLng(position.latitude, position.longitude);
      
      state = state.copyWith(userLocation: newLocation, heading: position.heading);

      if (state.isTracking) {
        mapController.moveAndRotate(newLocation, 17.0, position.heading);
      }
      
      // جلب المسار من الريبوزتري
      fetchRoute(newLocation, targetLocation);
    });
  }

  // جلب المسار (نادينا الريبوزتري هنا تنفيذاً لطلب الـ Reviewer)
  Future<void> fetchRoute(LatLng start, LatLng target) async {
    final data = await _mapRepository.getRoute(start: start, target: target);

    if (data != null) {
      try {
        final List coords = data['features'][0]['geometry']['coordinates'];
        
        final List<LatLng> syncedPoints = [
          start, // البدء من موقع المستخدم الفعلي
          ...coords.map((c) => LatLng(c[1].toDouble(), c[0].toDouble())),
          target // النهاية عند موقع الحملة
        ];

        state = state.copyWith(
          routePoints: syncedPoints,
          distance: "${(data['features'][0]['properties']['segments'][0]['distance'] / 1000).toStringAsFixed(1)} كم",
        );
      } catch (e) {
        debugPrint("Parsing Error: $e");
      }
    }
  }

  void toggleTracking() => state = state.copyWith(isTracking: !state.isTracking);

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }
}

// تعريف الـ Provider
final mapLogicProvider = StateNotifierProvider<MapLogicNotifier, MapState>((ref) => MapLogicNotifier());