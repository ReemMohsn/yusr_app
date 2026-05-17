import 'package:yusr/core/constants/shared_preferences_keys.dart';
import 'package:yusr/core/services/shared_preferences_service.dart';

/// خدمة حفظ واستعادة حالة عداد الطواف والسعي
///
/// تتبع أسلوب المشروع: تعتمد على [SharedPreferencesService] من core
/// بدلاً من استدعاء [SharedPreferences.getInstance()] مباشرة
class AutoCounterStorageService {
  final SharedPreferencesService _prefs;

  const AutoCounterStorageService(this._prefs);

  /// حفظ الشوط الحالي ونوع النسك وحالة التشغيل
  Future<void> saveState({
    required bool isTawaf,
    required int lap,
    required bool isRunning,
  }) async {
    try {
      await _prefs.setInt(SharedPreferencesKeys.tawafSavedLap, lap);
      await _prefs.setBool(SharedPreferencesKeys.tawafSavedType, isTawaf);
      await _prefs.setBool(SharedPreferencesKeys.tawafSavedRunning, isRunning);
    } catch (_) {}
  }

  /// استعادة الشوط المحفوظ إذا كانت هناك جلسة سابقة لم تكتمل
  /// يعيد 1 إذا لم توجد جلسة سابقة أو كانت من نوع مختلف
  Future<int> loadSavedLap(bool isTawaf) async {
    try {
      final savedRunning =
          await _prefs.getBool(SharedPreferencesKeys.tawafSavedRunning) ??
          false;
      final savedType =
          await _prefs.getBool(SharedPreferencesKeys.tawafSavedType) ?? isTawaf;

      if (savedRunning && savedType == isTawaf) {
        final lap =
            await _prefs.getInt(SharedPreferencesKeys.tawafSavedLap) ?? 1;
        return lap.clamp(1, 7);
      }
    } catch (_) {}
    return 1;
  }

  /// مسح الحالة المحفوظة عند انتهاء النسك أو إعادة الضبط
  Future<void> clearSavedState() async {
    try {
      await _prefs.removeInt(SharedPreferencesKeys.tawafSavedLap);
      await _prefs.removeInt(SharedPreferencesKeys.tawafSavedType);
      await _prefs.removeInt(SharedPreferencesKeys.tawafSavedRunning);
    } catch (_) {}
  }
}
