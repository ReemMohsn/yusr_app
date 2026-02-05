// user_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/common/providers/shared_preferences_service_provider%20.dart';
import 'package:yusr/features/auth/data/models/login_model.dart';

part 'user_provider.g.dart';

@riverpod
class UserProfile extends _$UserProfile {
  @override
  FutureOr<ProfileModel?> build() async {
    // جلب البيانات من الذاكرة المحلية عند بدء التطبيق
    return await ref.read(sharedPreferencesServiceProvider).getProfile();
  }

  // دالة لتحديث البيانات يدوياً إذا لزم الأمر (مثلاً بعد تعديل البروفايل)
  Future<void> refreshProfile() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref.read(sharedPreferencesServiceProvider).getProfile();
    });
  }
}
