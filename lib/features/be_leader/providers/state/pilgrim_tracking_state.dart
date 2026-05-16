
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class PilgrimTrackingState {
  final LatLng? pilgrimLocation;
  final LatLng? leaderLocation;
  final double distance;
  final bool isLoading;
  final String? errorMessage;

  PilgrimTrackingState({
    this.pilgrimLocation,
    this.leaderLocation,
    this.distance = 0.0,
    this.isLoading = false,
    this.errorMessage,
  });

  // دالة مساعدة لتحديد لون حالة الحاج بناءً على المسافة
  Color get statusColor {
    if (distance <= 75.0) return Colors.teal; // النطاق الأخضر
    if (distance <= 150.0) return Colors.amber; // النطاق الأصفر
    return Colors.red; // خارج النطاق (خطر)
  }

  String get statusText {
    if (distance <= 75.0) return 'في النطاق الآمن';
    if (distance <= 150.0) return 'على حدود النطاق';
    return 'خارج النطاق!';
  }
}
