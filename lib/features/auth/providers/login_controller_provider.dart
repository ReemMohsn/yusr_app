import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/features/auth/providers/auth_repository_provider.dart';

part 'login_controller_provider.g.dart';

@riverpod
class LoginController extends _$LoginController {
  @override
  FutureOr<void> build() {
    // الحالة المبدئية
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).login(email, password);
    });
  }
}
