import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/services/API/ApiResponse.dart';
import 'package:yusr/features/announcements_notifications/providers/announcements_repository_provider.dart';

part 'delete_announcement_provider.g.dart';

@riverpod
class DeleteAnnouncementNotifier extends _$DeleteAnnouncementNotifier {
  @override
  FutureOr<ApiResponse<dynamic>?> build() {
    return null;
  }

  Future<void> deleteAnnouncement(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard<ApiResponse<dynamic>?>(() async {
      return await ref
          .read(announcementsRepositoryProvider)
          .deleteAnnouncement(id);
    });
  }
}
