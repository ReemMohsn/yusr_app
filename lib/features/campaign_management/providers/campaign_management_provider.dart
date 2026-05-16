// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:yusr/core/common/providers/api_service_provider.dart';
// import 'package:yusr/features/campaign_management/data/models/campaign_info_model.dart';
// import 'package:yusr/features/campaign_management/data/models/campaign_group_model.dart';
// import 'package:yusr/features/campaign_management/data/models/campaign_group_details_model.dart';
// import 'package:yusr/features/campaign_management/data/models/campaign_pilgrim_details_model.dart';
// import 'package:yusr/features/campaign_management/data/repositories/campaign_management_repository.dart';

// part 'campaign_management_provider.g.dart';

// @riverpod
// CampaignManagementRepository campaignManagementRepository(Ref ref) {
//   final apiService = ref.watch(apiServiceProvider);
//   return CampaignManagementRepository(apiService, ref);
// }

// @riverpod
// Future<CampaignInfoModel> campaignInfo(Ref ref) async {
//   final repository = ref.watch(campaignManagementRepositoryProvider);
//   final response = await repository.getCampaignInfo();

//   if (response.data != null) {
//     return response.data!;
//   } else {
//     throw Exception(response.message);
//   }
// }

// @riverpod
// Future<List<CampaignGroupModel>> campaignGroups(Ref ref) async {
//   final repository = ref.watch(campaignManagementRepositoryProvider);
//   final response = await repository.getCampaignGroups();

//   if (response.data != null) {
//     return response.data!;
//   } else {
//     throw Exception(response.message);
//   }
// }

// @riverpod
// Future<CampaignGroupDetailsModel> campaignGroupDetails(Ref ref, int groupId) async {
//   final repository = ref.watch(campaignManagementRepositoryProvider);
//   final response = await repository.getCampaignGroupDetails(groupId);

//   if (response.data != null) {
//     return response.data!;
//   } else {
//     throw Exception(response.message);
//   }
// }



// @riverpod
// Future<CampaignPilgrimDetailsModel> campaignPilgrimDetails(Ref ref, int userId) async {
//   final repository = ref.watch(campaignManagementRepositoryProvider);
//   final response = await repository.getCampaignPilgrimDetails(userId);

//   if (response.data != null) {
//     return response.data!;
//   } else {
//     throw Exception(response.message);
//   }
// }

