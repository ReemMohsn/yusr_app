import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/services/API/ApiResponse.dart';
import 'package:yusr/features/be_leader/providers/be_leader_repository_provider.dart';
import '../data/models/session_response_model.dart';

part 'start_session_controller.g.dart';

@riverpod
class StartSessionController extends _$StartSessionController {
  @override
  FutureOr<ApiResponse<SessionResponseModel>?> build() {
    return null;
  }

  Future<void> startTrackingSession() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard<ApiResponse<SessionResponseModel>?>(
      () async {
        return await ref
            .read(leaderTrackingApiRepositoryProvider)
            .startSession();
      },
    );
  }
}
