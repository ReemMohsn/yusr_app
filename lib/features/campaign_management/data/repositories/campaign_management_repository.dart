import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/constants/api_link.dart';
import 'package:yusr/core/services/API/ApiResponse.dart';
import 'package:yusr/core/services/API/api_service.dart';
import 'package:yusr/core/services/API/repository_request_handler.dart';
import 'package:yusr/features/campaign_management/data/models/campaign_info_model.dart';
import 'package:yusr/features/campaign_management/data/models/campaign_group_model.dart';
import 'package:yusr/features/campaign_management/data/models/campaign_group_details_model.dart';
import 'package:yusr/features/campaign_management/data/models/campaign_pilgrim_details_model.dart';
class CampaignManagementRepository {
  final ApiService apiService;
  final Ref ref;

  CampaignManagementRepository(this.apiService, this.ref);

  Future<ApiResponse<CampaignInfoModel>> getCampaignInfo() async {
    return repositoryRequestHandler<CampaignInfoModel>(
      () => apiService.get(ApiLink.getCampaignInfoMobile),
      fromJson: (data) =>
          CampaignInfoModel.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<List<CampaignGroupModel>>> getCampaignGroups() async {
    return repositoryRequestHandler<List<CampaignGroupModel>>(
      () => apiService.get(ApiLink.getCampaignGroupsMobile),
      fromJson: (data) {
        if (data is List) {
          return data
              .map((e) => CampaignGroupModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        return [];
      },
    );
  }

  Future<ApiResponse<CampaignGroupDetailsModel>> getCampaignGroupDetails(int groupId) async {
    return repositoryRequestHandler<CampaignGroupDetailsModel>(
      () => apiService.get(ApiLink.getCampaignGroupDetailsMobile(groupId)),
      fromJson: (data) =>
          CampaignGroupDetailsModel.fromJson(data as Map<String, dynamic>),
    );
  }


  Future<ApiResponse<CampaignPilgrimDetailsModel>> getCampaignPilgrimDetails(int userId) async {
    return repositoryRequestHandler<CampaignPilgrimDetailsModel>(
      () => apiService.get(ApiLink.getCampaignPilgrimDetailsMobile(userId)),
      fromJson: (data) =>
          CampaignPilgrimDetailsModel.fromJson(data as Map<String, dynamic>),
    );
  }

}
