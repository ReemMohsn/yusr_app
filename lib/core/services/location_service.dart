import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  // 🌟 1. إعدادات الموقع المثالية (دقة عالية مع منع التذبذب)
  LocationSettings get optimalLocationSettings {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 2,
        forceLocationManager: false,
        intervalDuration: const Duration(seconds: 5),
      );
    } else {
      return AppleSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        activityType: ActivityType.fitness,
        distanceFilter: 2,
        pauseLocationUpdatesAutomatically: false,
      );
    }
  }

  // 2. بث الموقع العادي (بدون إشعار خلفية)
  Stream<Position> get positionStream =>
      Geolocator.getPositionStream(locationSettings: optimalLocationSettings);

  // 3. بث مخصص للخلفية (Foreground Service) — مهم لوظيفة المشرف لمنع قتل الـ GPS
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
              enableWakeLock: true,
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

  // 4. بث اتجاه البوصلة
  Stream<CompassEvent>? get compassStream => FlutterCompass.events;

  // -----------------------------------------------
  // 🌟 دوال GPS المساعدة (انتُقلت من الكونترولر لهنا)
  // -----------------------------------------------

  /// فحص هل مفتاح خدمة GPS مفعل في إعدادات الهاتف
  Future<bool> isServiceEnabled() => Geolocator.isLocationServiceEnabled();

  /// Stream يراقب لحظة تشغيل/إيقاف مفتاح GPS في الهاتف
  Stream<ServiceStatus> get serviceStatusStream =>
      Geolocator.getServiceStatusStream();

  /// فحص صلاحيات الموقع وطلبها إذا لم تُمنح — يُرجع true إذا تم المنح
  Future<bool> ensurePermissionsGranted() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    final granted = permission != LocationPermission.denied &&
        permission != LocationPermission.deniedForever;
    debugPrint(granted
        ? "✅ [GPS] صلاحيات الموقع ممنوحة."
        : "❌ [GPS] صلاحيات الموقع مرفوضة.");
    return granted;
  }

  /// جلب الموقع الحالي بأمان — يُرجع null بدلاً من رمي خطأ عند الفشل
  Future<Position?> tryGetCurrentPosition() async {
    try {
      debugPrint("⏳ [GPS] جاري جلب الموقع الحالي...");
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: optimalLocationSettings,
      );
      debugPrint(
        "✅ [GPS] تم جلب الموقع: ${pos.latitude}, ${pos.longitude} | دقة: ${pos.accuracy.toStringAsFixed(1)} م",
      );
      return pos;
    } on TimeoutException {
      debugPrint("⏰ [GPS] انتهت مهلة جلب الموقع الأولي.");
      return null;
    } catch (e) {
      debugPrint("❌ [GPS] فشل جلب الموقع: $e");
      return null;
    }
  }

  Future<LocationPermission> requestPermission() =>
      Geolocator.requestPermission();
}