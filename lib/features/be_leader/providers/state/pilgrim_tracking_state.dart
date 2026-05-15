import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class PilgrimTrackingState {
  final LatLng? pilgrimLocation;
  final LatLng? leaderLocation;
  final double distance;
  final bool isLoading;
  final String? errorMessage;
  final String? gpsWarning;
  final String? bleWarning; // 🌟 تحذير حالة البلوتوث
  final bool isNetworkConnected; // 🌐 إضافة لحالة الإنترنت

  PilgrimTrackingState({
    this.pilgrimLocation,
    this.leaderLocation,
    this.distance = 0.0,
    this.isLoading = false,
    this.errorMessage,
    this.gpsWarning,
    this.bleWarning,
    this.isNetworkConnected = true,
  });

  /// نسخة محدَّثة من الحالة مع تغيير حقول بعينها فقط
  PilgrimTrackingState copyWith({
    LatLng? pilgrimLocation,
    LatLng? leaderLocation,
    double? distance,
    bool? isLoading,
    String? errorMessage,
    // استخدم Object() كـ sentinel لتمييز null المقصودة من الحقل غير الممرَّر
    Object? gpsWarning = _sentinel,
    Object? bleWarning = _sentinel,
    bool? isNetworkConnected,
  }) {
    return PilgrimTrackingState(
      pilgrimLocation: pilgrimLocation ?? this.pilgrimLocation,
      leaderLocation: leaderLocation ?? this.leaderLocation,
      distance: distance ?? this.distance,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      gpsWarning: gpsWarning == _sentinel ? this.gpsWarning : gpsWarning as String?,
      bleWarning: bleWarning == _sentinel ? this.bleWarning : bleWarning as String?,
      isNetworkConnected: isNetworkConnected ?? this.isNetworkConnected,
    );
  }

  Color get statusColor {
    if (distance <= 75.0) return Colors.teal;
    if (distance <= 150.0) return Colors.amber;
    return Colors.red;
  }

  String get statusText {
    if (distance <= 75.0) return 'في النطاق الآمن';
    if (distance <= 150.0) return 'على حدود النطاق';
    return 'خارج النطاق!';
  }
}

// ثابت داخلي للـ sentinel pattern في copyWith
const Object _sentinel = Object();
