import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/features/campaign_management/data/models/campaign_group_details_model.dart';
import 'package:yusr/features/campaign_management/providers/campaign_management_repository_provider.dart';

part 'campaign_group_details_provider.g.dart';

@riverpod
Future<CampaignGroupDetailsModel> campaignGroupDetails(Ref ref, int groupId) async {
  final repository = ref.watch(campaignManagementRepositoryProvider);
  final response = await repository.getCampaignGroupDetails(groupId);

  if (response.data != null) {
    return response.data!;
  } else {
    throw Exception(response.message);
  }
}
