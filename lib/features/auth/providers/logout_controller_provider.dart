import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/features/auth/providers/auth_repository_provider.dart';

part 'logout_controller_provider.g.dart';

@riverpod
class LogoutController extends _$LogoutController {
  @override
  FutureOr<void> build() {}

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).logout();
    });
  }
}
