import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

// class LocationService {
//   // بث لموقع المستخدم
//   Stream<Position> get positionStream => Geolocator.getPositionStream(
//     locationSettings: const LocationSettings(
//       accuracy: LocationAccuracy.high,
//       distanceFilter: 3,
//     ),
//   );
//   // 2. 👈 بث مخصص للعمل في الخلفية (Foreground Service) مهم جداً لوظيفة المشرف
//   Stream<Position> get foregroundPositionStream {
//     final locationSettings = AndroidSettings(
//       accuracy: LocationAccuracy.high,
//       distanceFilter: 3,
//       foregroundNotificationConfig: const ForegroundNotificationConfig(
//         notificationText: "التطبيق يقوم بتتبع موقعك لإرشاد الحجاج",
//         notificationTitle: "مرافق الحاج - كن قائد نشط",
//         enableWakeLock: true, // يمنع النظام من إقفال الـ GPS
//       ),
//     );
//     return Geolocator.getPositionStream(locationSettings: locationSettings);
//   }

//   // بث لاتجاه البوصلة
//   Stream<CompassEvent>? get compassStream => FlutterCompass.events;

//   Future<LocationPermission> requestPermission() =>
//       Geolocator.requestPermission();
// }

import 'package:flutter/foundation.dart';

class LocationService {
  // 🌟 1. إعدادات الموقع المثالية (السر في دقة الأماكن المغلقة ومنع التذبذب)
  LocationSettings get optimalLocationSettings {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidSettings(
        accuracy: LocationAccuracy.bestForNavigation, // أعلى دقة
        distanceFilter: 2, // لا يُحدث الموقع إلا إذا تحرك مترين
        forceLocationManager:
            false, // false = استخدام (Wi-Fi + أبراج الاتصالات + GPS) معاً
        intervalDuration: const Duration(seconds: 5),
      );
    } else {
      return AppleSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        activityType:
            ActivityType.fitness, // يخبر الآيفون أنه يتحرك مشياً لرفع الدقة
        distanceFilter: 2,
        pauseLocationUpdatesAutomatically: false,
      );
    }
  }

  // بث لموقع المستخدم العادي
  Stream<Position> get positionStream =>
      Geolocator.getPositionStream(locationSettings: optimalLocationSettings);

  // 2. 👈 بث مخصص للعمل في الخلفية (Foreground Service)
  Stream<Position> get foregroundPositionStream {
    final locationSettings = defaultTargetPlatform == TargetPlatform.android
        ? AndroidSettings(
            accuracy: LocationAccuracy.bestForNavigation,
            distanceFilter: 2,
            forceLocationManager: false,
            intervalDuration: const Duration(seconds: 5),
            foregroundNotificationConfig: const ForegroundNotificationConfig(
              notificationText: "التطبيق يقوم بتتبع موقعك لإرشاد الحجاج",
              notificationTitle: "مرافق الحاج - كن قائد نشط",
              enableWakeLock: true, // يمنع النظام من إقفال الـ GPS
            ),
          )
        : AppleSettings(
            accuracy: LocationAccuracy.bestForNavigation,
            activityType: ActivityType.fitness,
            distanceFilter: 2,
            pauseLocationUpdatesAutomatically: false,
          );

    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  // بث لاتجاه البوصلة
  Stream<CompassEvent>? get compassStream => FlutterCompass.events;

  Future<LocationPermission> requestPermission() =>
      Geolocator.requestPermission();
}
