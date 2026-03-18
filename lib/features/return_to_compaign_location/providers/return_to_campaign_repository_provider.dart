import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/common/providers/api_service_provider.dart';
import '../data/repositories/return_to_campaign_repository.dart';

part 'return_to_campaign_repository_provider.g.dart';

@riverpod
ReturnToCampaignRepository returnToCampaignRepository(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ReturnToCampaignRepository(apiService);
}