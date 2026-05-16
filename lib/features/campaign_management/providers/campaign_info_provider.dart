import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/features/campaign_management/data/models/campaign_info_model.dart';
import 'package:yusr/features/campaign_management/providers/campaign_management_repository_provider.dart';

part 'campaign_info_provider.g.dart';

@riverpod
Future<CampaignInfoModel> campaignInfo(Ref ref) async {
  final repository = ref.watch(campaignManagementRepositoryProvider);
  final response = await repository.getCampaignInfo();

  if (response.data != null) {
    return response.data!;
  } else {
    throw Exception(response.message);
  }
}
