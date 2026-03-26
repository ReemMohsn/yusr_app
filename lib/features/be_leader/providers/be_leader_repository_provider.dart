import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/common/providers/api_service_provider.dart';
import 'package:yusr/features/be_leader/data/repositories/leader_tracking_api_repository.dart';

part 'be_leader_repository_provider.g.dart';

@riverpod
LeaderTrackingApiRepository leaderTrackingApiRepository(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return LeaderTrackingApiRepository(apiService, ref);
}
