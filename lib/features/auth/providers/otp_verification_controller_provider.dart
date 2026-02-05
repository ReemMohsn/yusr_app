import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/features/auth/providers/auth_repository_provider.dart';

part 'otp_verification_controller_provider.g.dart';

@riverpod
class OtpVerificationController extends _$OtpVerificationController {
  @override
  FutureOr<void> build() {}

  Future<void> verifyOtp(String code) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).verifyOtp(code);
    });
  }
}
