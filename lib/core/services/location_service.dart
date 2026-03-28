import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  // بث لموقع المستخدم
  Stream<Position> get positionStream => Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 1,
    ),
  );

  // بث لاتجاه البوصلة
  Stream<CompassEvent>? get compassStream => FlutterCompass.events;

  Future<LocationPermission> requestPermission() =>
      Geolocator.requestPermission();
}
