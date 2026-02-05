import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/features/auth/providers/auth_repository_provider.dart';

part 'reset_password_controller_provider.g.dart';

@riverpod
class ResetPasswordController extends _$ResetPasswordController {
  @override
  FutureOr<void> build() {}

  Future<void> resetPassword(String newPassword) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).resetPassword(newPassword);
    });
  }
}
