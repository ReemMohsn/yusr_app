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
}
