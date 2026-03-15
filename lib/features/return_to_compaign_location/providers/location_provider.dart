import 'package:geolocator/geolocator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// هذا الـ Provider سيسمح لك بجلب الموقع في أي مكان بالتطبيق
final locationProvider = FutureProvider<Position>((ref) async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw 'خدمات الموقع معطلة، يرجى تفعيلها';
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw 'تم رفض الوصول للموقع';
    }
  }

  return await Geolocator.getCurrentPosition();
});