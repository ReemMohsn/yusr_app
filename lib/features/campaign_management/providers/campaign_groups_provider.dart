import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/features/campaign_management/data/models/campaign_group_model.dart';
import 'package:yusr/features/campaign_management/providers/campaign_management_repository_provider.dart';

part 'campaign_groups_provider.g.dart';

@riverpod
Future<List<CampaignGroupModel>> campaignGroups(Ref ref) async {
  final repository = ref.watch(campaignManagementRepositoryProvider);
  final response = await repository.getCampaignGroups();

  if (response.data != null) {
    return response.data!;
  } else {
    throw Exception(response.message);
  }
}
