import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/features/group/data/models/group_model.dart';
import 'package:yusr/features/group/providers/group_repository_provider.dart';

part 'group_provider.g.dart';

/// Fetches the Hajji's group information.
///
/// Reads from [groupRepositoryProvider] → calls [GroupRepository.getGroupInfo].
/// Throws if the user has not been assigned to a group yet, which the view
/// handles via the `error` branch showing the "no group" UI.
@riverpod
Future<GroupInfoModel> groupInfo(Ref ref) async {
  final repository = ref.watch(groupRepositoryProvider);
  final response = await repository.getGroupInfo();

  if (response.data != null) {
    return response.data!;
  } else {
    throw Exception(response.message);
  }
}

/// Fetches the Supervisor's group details (full pilgrim list).
///
/// Reads from [groupRepositoryProvider] → calls
/// [GroupRepository.getSupervisorGroupInfo].
@riverpod
Future<SupervisorGroupModel> supervisorGroupDetails(Ref ref) async {
  final repository = ref.watch(groupRepositoryProvider);
  final response = await repository.getSupervisorGroupInfo();

  if (response.data != null) {
    return response.data!;
  } else {
    throw Exception(response.message);
  }
}

/// Fetches detailed information for a specific pilgrim (by userId).
@riverpod
Future<PilgrimDetailsModel> pilgrimDetails(Ref ref, int userId) async {
  final repository = ref.watch(groupRepositoryProvider);
  final response = await repository.getPilgrimDetails(userId);

  if (response.data != null) {
    return response.data!;
  } else {
    throw Exception(response.message);
  }
}
