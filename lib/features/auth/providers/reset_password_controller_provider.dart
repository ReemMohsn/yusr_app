import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/services/API/ApiResponse.dart';
import 'package:yusr/features/auth/providers/auth_repository_provider.dart';

part 'reset_password_controller_provider.g.dart';

@riverpod
class ResetPasswordController extends _$ResetPasswordController {
  @override
  FutureOr<ApiResponse<dynamic>?> build() {
    return null;
  }

  Future<void> resetPassword(String newPassword) async {
    // 1. حدد النوع صراحة هنا
    state = const AsyncValue<ApiResponse<dynamic>?>.loading();

    // 2. وحدد النوع صراحة للـ guard هنا بإضافة <...>
    state = await AsyncValue.guard<ApiResponse<dynamic>?>(() async {
      return await ref.read(authRepositoryProvider).resetPassword(newPassword);
    });
  }
}
