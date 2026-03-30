import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  // بث لموقع المستخدم
  Stream<Position> get positionStream => Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    ),
  );
  // 2. 👈 بث مخصص للعمل في الخلفية (Foreground Service) مهم جداً لوظيفة المشرف
  Stream<Position> get foregroundPositionStream {
    final locationSettings = AndroidSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
      foregroundNotificationConfig: const ForegroundNotificationConfig(
        notificationText: "التطبيق يقوم بتتبع موقعك لإرشاد الحجاج",
        notificationTitle: "مرافق الحاج - كن قائد نشط",
        enableWakeLock: true, // يمنع النظام من إقفال الـ GPS
      ),
    );
    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  // بث لاتجاه البوصلة
  Stream<CompassEvent>? get compassStream => FlutterCompass.events;

  Future<LocationPermission> requestPermission() =>
      Geolocator.requestPermission();
}
