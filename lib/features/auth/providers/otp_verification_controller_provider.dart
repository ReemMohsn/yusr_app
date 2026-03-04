import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/services/API/ApiResponse.dart';
import 'package:yusr/features/auth/providers/auth_repository_provider.dart';

part 'otp_verification_controller_provider.g.dart';

@riverpod
class OtpVerificationController extends _$OtpVerificationController {
  @override
  FutureOr<ApiResponse<dynamic>?> build() {
    return null;
  }

  Future<void> verifyOtp(String code) async {
    state = const AsyncValue<ApiResponse<dynamic>?>.loading();
    state = await AsyncValue.guard<ApiResponse<dynamic>?>(() async {
      return await ref.read(authRepositoryProvider).verifyOtp(code);
    });
  }
}
