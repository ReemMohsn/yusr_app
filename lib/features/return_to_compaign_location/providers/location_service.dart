import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_service.g.dart';

@riverpod
LocationService locationService(Ref ref) {
  return LocationService();
}

class LocationService {
  // بث لموقع المستخدم
  Stream<Position> get positionStream => Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5,
        ),
      );

  // بث لاتجاه البوصلة
  Stream<CompassEvent>? get compassStream => FlutterCompass.events;

  Future<LocationPermission> requestPermission() => Geolocator.requestPermission();
}