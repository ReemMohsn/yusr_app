import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/services/API/ApiResponse.dart';
import 'package:yusr/features/auth/data/models/login_model.dart';
import 'package:yusr/features/auth/providers/auth_repository_provider.dart';

part 'login_controller_provider.g.dart';

@riverpod
class LoginController extends _$LoginController {
  @override
  FutureOr<ApiResponse<ProfileModel>?> build() {
    return null; // الحالة المبدئية فارغة
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard<ApiResponse<ProfileModel>?>(() async {
      return await ref.read(authRepositoryProvider).login(email, password);
    });
  }
}
