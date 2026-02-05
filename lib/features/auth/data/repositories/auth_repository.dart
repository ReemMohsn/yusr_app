import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/common/providers/shared_preferences_service_provider%20.dart';
import 'package:yusr/core/constants/api_link.dart';
import 'package:yusr/core/constants/shared_preferences_keys.dart';
import 'package:yusr/core/services/API/api_service.dart';
import 'package:yusr/core/services/API/repository_request_handler.dart';
import 'package:yusr/features/auth/data/models/login_model.dart';

class AuthRepository {
  final ApiService apiService;
  final Ref ref;
  AuthRepository(this.apiService, this.ref);

  Future<ProfileModel> login(String identifier, String password) async {
    ProfileModel profileModel = await repositoryRequestHandler<ProfileModel>(
      () => apiService.post(
        ApiLink.login,
        data: {"identifier": identifier, "password": password},
      ),
      fromJson: (data) => ProfileModel.fromJson(data),
    );
    await ref.read(sharedPreferencesServiceProvider).setProfile(profileModel);
    return profileModel;
  }

  Future<String> forgotPassword(String email) async {
    String message = await repositoryRequestHandler<String>(
      () => apiService.post(ApiLink.forgotPassword, data: {"email": email}),
      fromJson: (data) => data['message'],
    );
    return message;
  }

  Future<String> verifyOtp(String otpCode) async {
    final email = await ref
        .read(sharedPreferencesServiceProvider)
        .getString(SharedPreferencesKeys.resetEmail);
    String message = await repositoryRequestHandler<String>(
      () => apiService.post(
        ApiLink.sendCode,
        data: {"email": email ?? '', "code": otpCode},
      ),
      fromJson: (data) => data['message'],
    );
    return message;
  }

  Future<String> resetPassword(String newPassword) async {
    final email = await ref
        .read(sharedPreferencesServiceProvider)
        .getString(SharedPreferencesKeys.resetEmail);
    final otpCode = await ref
        .read(sharedPreferencesServiceProvider)
        .getString(SharedPreferencesKeys.otpCode);
    String message = await repositoryRequestHandler<String>(
      () => apiService.post(
        ApiLink.resetPassword,
        data: {
          "email": email ?? '',
          "code": otpCode ?? '',
          "newPassword": newPassword,
        },
      ),
      fromJson: (data) => data['message'],
    );
    return message;
  }

  Future<void> logout() async {
    try {
      await repositoryRequestHandler<String>(
        () => apiService.post(ApiLink.logout, data: {}),
        fromJson: (data) => data['message'],
      );
    } catch (e) {
      debugPrint("حدث خطأ");
    } finally {
      // 🔥 هذا هو الجزء الأهم 🔥
      // يتم تنفيذ هذا الكود دائماً سواء نجح السيرفر أو فشل

      // 1. مسح البروفايل
      await ref.read(sharedPreferencesServiceProvider).removeProfile();

      // 2. يفضل مسح كل شيء لضمان عدم بقاء أي بيانات قديمة
      await ref.read(sharedPreferencesServiceProvider).clear();
    }
  }
}
