import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/features/be_leader/data/models/pilgrim_model.dart';
import 'package:yusr/features/be_leader/providers/be_leader_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'pilgrims_list_provider.g.dart';

@riverpod
Future<List<PilgrimModel>> pilgrimsList(Ref ref, int sessionId) async {
  final repository = ref.watch(leaderTrackingApiRepositoryProvider);
  final response = await repository.getPilgrimsList(sessionId);

  return response.data ?? [];
}
