import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/common/providers/shared_preferences_service_provider%20.dart';
import 'package:yusr/core/services/API/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  // 1. نقرأ خدمة التخزين أولاً
  final prefsService = ref.read(sharedPreferencesServiceProvider);
  
  // 2. نمررها لخدمة الـ API
  return ApiService(prefsService);
});