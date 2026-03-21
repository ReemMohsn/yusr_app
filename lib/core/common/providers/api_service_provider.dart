import 'package:yusr/core/common/providers/shared_preferences_service_provider.dart';
import 'package:yusr/core/services/API/api_service.dart';
// هذا مهم من أجل Ref
import 'package:riverpod_annotation/riverpod_annotation.dart';
// final apiServiceProvider = Provider<ApiService>((ref) {
//   // 1. نقرأ خدمة التخزين أولاً
//   final prefsService = ref.read(sharedPreferencesServiceProvider);

//   // 2. نمررها لخدمة الـ API
//   return ApiService(prefsService);
// });

part 'api_service_provider.g.dart';

@riverpod
ApiService apiService(Ref ref) {
  final prefsService = ref.watch(sharedPreferencesServiceProvider);
  return ApiService(prefsService);
}
