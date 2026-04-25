import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/constants/api_link.dart';
import 'package:yusr/core/services/API/ApiResponse.dart';
import 'package:yusr/core/services/API/api_service.dart';
import 'package:yusr/core/services/API/repository_request_handler.dart';
import 'package:yusr/features/group/data/models/group_model.dart';

class GroupRepository {
  final ApiService apiService;
  final Ref ref;

  GroupRepository(this.apiService, this.ref);

  // ─── Step 1: get the groupId from SyncData ───────────────────────────────

  Future<int?> _fetchGroupId() async {
    try {
      final response = await repositoryRequestHandler<Map<String, dynamic>>(
        () => apiService.get(ApiLink.syncData),
        fromJson: (data) => data as Map<String, dynamic>,
      );
      return response.data?['groupId'] as int?;
    } catch (e) {
      if (e.toString().contains('غير مسجل في الحملة')) {
        return null;
      }
      rethrow;
    }
  }

  // ─── Hajji: group info view ───────────────────────────────────────────────

  /// Fetches the Hajji's group information.
  ///
  /// Two-step:
  ///   1. [SyncData] → retrieve `groupId`
  ///   2. [GetGroupDetails/{groupId}] → retrieve full group data
  ///
  /// Throws if the user has no group yet (groupId == null).
  Future<ApiResponse<GroupInfoModel>> getGroupInfo() async {
    final groupId = await _fetchGroupId();

    if (groupId == null) {
      throw Exception('لم يتم تعيينك في مجموعة بعد');
    }

    return repositoryRequestHandler<GroupInfoModel>(
      () => apiService.get(ApiLink.getGroupDetailsMobile(groupId)),
      fromJson: (data) =>
          GroupInfoModel.fromJson(data as Map<String, dynamic>),
    );
  }

  // ─── Supervisor: group details view ──────────────────────────────────────

  /// Fetches the Supervisor's group details (list of pilgrims).
  ///
  /// Uses a specialized endpoint that fetches the group based on the currently
  /// logged-in supervisor's ID, completely bypassing the SyncData payload.
  ///
  /// Throws if the supervisor has no assigned group yet.
  Future<ApiResponse<SupervisorGroupModel>> getSupervisorGroupInfo() async {
    return repositoryRequestHandler<SupervisorGroupModel>(
      () => apiService.get(ApiLink.getMyGroupPilgrimsMobile),
      fromJson: (data) =>
          SupervisorGroupModel.fromJson(data as Map<String, dynamic>),
    );
  }

  // ─── Supervisor: pilgrim details ─────────────────────────────────────────

  Future<ApiResponse<PilgrimDetailsModel>> getPilgrimDetails(int userId) async {
    return repositoryRequestHandler<PilgrimDetailsModel>(
      () => apiService.get(ApiLink.getHajDetailsMobile(userId)),
      fromJson: (data) =>
          PilgrimDetailsModel.fromJson(data as Map<String, dynamic>),
    );
  }
}
