import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/features/auth/providers/auth_repository_provider.dart';

part 'forgot_password_controller_provider.g.dart';

@riverpod
class ForgotPasswordController extends _$ForgotPasswordController {
  @override
  FutureOr<void> build() {}

  Future<void> sendCode(String email) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).forgotPassword(email);
    });
  }
}
