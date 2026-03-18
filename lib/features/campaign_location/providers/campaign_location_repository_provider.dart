import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/common/providers/api_service_provider.dart';
import '../data/repositories/campaign_location_repository.dart';

final campaignLocationRepositoryProvider = Provider<CampaignLocationRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return CampaignLocationRepository(apiService, ref);
});