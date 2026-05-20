// features/campaign_location/providers/add_location_map_controller.dart

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:yusr/core/common/providers/location_service.dart';

part 'add_location_map_controller.g.dart';

@riverpod
class AddLocationMapController extends _$AddLocationMapController {
  
  @override
  LatLng build() {
    // الإحداثيات الافتراضية (مثلاً: مكة المكرمة) عند فتح الصفحة لأول مرة
    return const LatLng(21.4225, 39.8262);
  }

  /// تحديث الإحداثيات عند النقر على الخريطة
  void updateSelectedPosition(LatLng point) {
    state = point;
  }

  /// جلب الموقع الحالي للمستخدم وتحريك الخريطة إليه بأمان
/// جلب الموقع الحالي للمستخدم وتحريك الخريطة إليه بأمان
  Future<void> initializeUserLocation({required MapController mapController}) async {
    try {
      final locationService = ref.read(locationServiceProvider);
      final permission = await locationService.requestPermission();

      if (!ref.mounted) return;

      if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        final position = await Geolocator.getCurrentPosition();
        final userLatLng = LatLng(position.latitude, position.longitude);

        // تحديث حالة البروفايدر بالموقع الجديد
        state = userLatLng;

        // تحريك الخريطة مباشرة بعد تأكد بناء الواجهة (آمن تماماً)
        WidgetsBinding.instance.addPostFrameCallback((_) {
          mapController.move(userLatLng, 15.0);
        });
      }
    } catch (e) {
      debugPrint("تعذر جلب موقع المستخدم الحالي عبر الـ GPS: $e");
    }
  }
}