import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/services/API/ApiResponse.dart';
import 'package:yusr/features/auth/providers/auth_repository_provider.dart';

part 'forgot_password_controller_provider.g.dart';

@riverpod
class ForgotPasswordController extends _$ForgotPasswordController {
  @override
  // الحالة المبدئية فارغة، وتتوقع استلام ApiResponse
  FutureOr<ApiResponse<dynamic>?> build() {
    return null;
  }

  Future<void> sendCode(String email) async {
    state = const AsyncValue<ApiResponse<dynamic>?>.loading();
    state = await AsyncValue.guard<ApiResponse<dynamic>?>(() async {
      return await ref.read(authRepositoryProvider).forgotPassword(email);
    });
  }
}
