import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/services/API/ApiResponse.dart';
import 'package:yusr/features/announcements_notifications/providers/announcements_repository_provider.dart';

part 'add_announcement_provider.g.dart';

@riverpod
class AddAnnouncementNotifier extends _$AddAnnouncementNotifier {
  @override
  FutureOr<ApiResponse<dynamic>?> build() {
    return null;
  }

  Future<void> createAnnouncement({
    required String title,
    required String body,
    required int targetAudienceId,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard<ApiResponse<dynamic>?>(() async {
      return await ref
          .watch(announcementsRepositoryProvider)
          .createAnnouncement(
            title: title,
            body: body,
            targetAudienceId: targetAudienceId,
          );
    });
  }
}
