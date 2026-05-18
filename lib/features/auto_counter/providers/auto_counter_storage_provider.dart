import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/common/providers/shared_preferences_service_provider.dart';
import '../services/auto_counter_storage_service.dart';

part 'auto_counter_storage_provider.g.dart';

/// بروفايدر خدمة التخزين لعداد الطواف والسعي
///
/// يحقن [SharedPreferencesService] من core تلقائياً
/// keepAlive: true لأن الكونترولر يحتاجها طوال دورة حياته
@Riverpod(keepAlive: true)
AutoCounterStorageService autoCounterStorage(Ref ref) {
  final prefs = ref.watch(sharedPreferencesServiceProvider);
  return AutoCounterStorageService(prefs);
}
