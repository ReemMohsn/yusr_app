import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/constants/api_link.dart';
import 'package:yusr/core/services/API/ApiResponse.dart';
import 'package:yusr/core/services/API/api_service.dart';
import 'package:yusr/core/services/API/repository_request_handler.dart';
import 'package:yusr/features/profile/data/models/user_details_model.dart';

class ProfileRepository {
  final ApiService apiService;
  final Ref ref;

  ProfileRepository(this.apiService, this.ref);

  Future<ApiResponse<UserDetailsModel>> getUserDetails() async {
    final response = await repositoryRequestHandler<UserDetailsModel>(
      () => apiService.get(ApiLink.getProfile),
      fromJson: (data) => UserDetailsModel.fromJson(data),
    );
    return response;
  }

  Future<ApiResponse<bool>> updateProfile(UpdateProfileDto dto) async {
    final response = await repositoryRequestHandler<bool>(
      () => apiService.post(ApiLink.updateProfile, data: dto.toJson()),
      fromJson: (data) => true,
    );
    return response;
  }

  /// Fetches raw user details specifically to safely construct an UpdateProfileDto
  Future<ApiResponse<Map<String, dynamic>>> getRawUserDetails() async {
    // using the explicit GetUserDetails endpoint String since ApiLink.getProfile is GetProfileMobile
    final endpoint = '${ApiLink.server}/Profile/GetUserDetails';
    final response = await repositoryRequestHandler<Map<String, dynamic>>(
      () => apiService.get(endpoint),
      fromJson: (data) => data as Map<String, dynamic>,
    );
    return response;
  }

  Future<ApiResponse<bool>> updateProfileRaw(String number) async {
    final response = await repositoryRequestHandler<bool>(
      () => apiService.post(
        ApiLink.updateProfile,
        data: {"saudiContactNumber": number},
      ),
      fromJson: (data) => true,
    );
    return response;
  }
}
