import 'package:flutter_riverpod/flutter_riverpod.dart'; // 🌟 السطر السحري الذي سيخفي الأخطاء
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/common/providers/shared_preferences_service_provider.dart';
import 'dart:async';
part 'read_notifications_provider.g.dart';

@riverpod
class ReadNotifications extends _$ReadNotifications {
  @override
  Future<List<String>> build() async {
    // قراءة البيانات من SharedPreferences عند تهيئة البروفايدر
    final prefs = ref.watch(sharedPreferencesServiceProvider);
    return await prefs.getReadNotifications();
  }

  Future<void> markAsRead(String id) async {
    final prefs = ref.read(sharedPreferencesServiceProvider);

    // التحقق من أن البيانات تم تحميلها بنجاح مسبقاً
    if (state.hasValue && state.value != null && !state.value!.contains(id)) {
      // 1. الحفظ في الذاكرة المحلية
      await prefs.markNotificationAsRead(id);

      // 2. سحب القائمة القديمة وإضافة العنصر الجديد
      final List<String> currentList = state.value!;

      // 3. تحديث الحالة فوراً لإعادة بناء الواجهة
      state = AsyncValue.data([...currentList, id]);
    }
  }
}
