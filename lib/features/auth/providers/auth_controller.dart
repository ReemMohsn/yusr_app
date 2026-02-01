import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/features/auth/providers/auth_repository_provider.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).login(email, password);
    });
  }

  Future<void> forgotPassword(String email) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).forgotPassword(email);
    });
  }

  // Future<void> verifyOtp(String code) async {
  //   state = const AsyncValue.loading();
  //   await Future.delayed(const Duration(seconds: 2));
  //   state = const AsyncValue.data(null);
  // }
}
