import 'dart:async';
import 'package:dio/dio.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';

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

class MapLogicNotifier extends StateNotifier<MapState> {
  final Dio _dio = Dio();
  StreamSubscription<Position>? _positionSubscription;
  final String _orsApiKey = 'eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6ImExNzU1NTJjOTM5ZDQwMzliNDg4MTAyMWMwNjljYjJmIiwiaCI6Im11cm11cjY0In0=';

  MapLogicNotifier() : super(MapState(
    userLocation: const LatLng(21.4180, 39.8570),
    routePoints: const [],
    distance: "جاري الحساب..",
    heading: 0.0,
    isTracking: true,
  ));

  Future<void> startLocationTracking(MapController mapController, LatLng targetLocation) async {
    // طلب الأذونات أولاً لضمان عمل الكود
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    await _positionSubscription?.cancel();
    
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 2),
    ).listen((Position position) {
      final newLocation = LatLng(position.latitude, position.longitude);
      
      state = state.copyWith(userLocation: newLocation, heading: position.heading);

      if (state.isTracking) {
        mapController.moveAndRotate(newLocation, 17.0, position.heading);
      }
      
      // تحديث المسار مع كل حركة للمستخدم
      fetchRoute(newLocation, targetLocation);
    });
  }

  Future<void> fetchRoute(LatLng start, LatLng target) async {
    final url = 'https://api.openrouteservice.org/v2/directions/driving-car';
    try {
      final response = await _dio.get(url, queryParameters: {
        'api_key': _orsApiKey,
        'start': '${start.longitude},${start.latitude}',
        'end': '${target.longitude},${target.latitude}',
      });

      if (response.statusCode == 200) {
        final data = response.data;
        final List coords = data['features'][0]['geometry']['coordinates'];
        
        // دمج موقع المستخدم الحالي مع نقاط المسار لضمان اتصال الخط
        final List<LatLng> syncedPoints = [
          start,
          ...coords.map((c) => LatLng(c[1].toDouble(), c[0].toDouble())),
          target
        ];

        state = state.copyWith(
          routePoints: syncedPoints,
          distance: "${(data['features'][0]['properties']['segments'][0]['distance'] / 1000).toStringAsFixed(1)} كم",
        );
      }
    } catch (e) {
      debugPrint("Dio Error: $e");
    }
  }

  void toggleTracking() => state = state.copyWith(isTracking: !state.isTracking);

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }
}

final mapLogicProvider = StateNotifierProvider<MapLogicNotifier, MapState>((ref) => MapLogicNotifier());