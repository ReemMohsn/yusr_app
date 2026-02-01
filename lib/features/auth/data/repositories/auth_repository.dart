import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/common/providers/shared_preferences_service_provider%20.dart';
import 'package:yusr/core/constants/api_link.dart';
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
}
