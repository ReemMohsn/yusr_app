import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/common/providers/api_service_provider.dart';
import 'package:yusr/features/campaign_management/data/repositories/campaign_management_repository.dart';

part 'campaign_management_repository_provider.g.dart';

@riverpod
CampaignManagementRepository campaignManagementRepository(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return CampaignManagementRepository(apiService, ref);
}
