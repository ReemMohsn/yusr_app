import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/constants/api_link.dart';
import 'package:yusr/core/services/API/ApiResponse.dart';
import 'package:yusr/core/services/API/api_service.dart';
import 'package:yusr/core/services/API/repository_request_handler.dart';
import 'package:yusr/features/announcements_notifications/data/models/announcement_model.dart';

class AnnouncementsRepository {
  final ApiService apiService;
  final Ref ref;

  AnnouncementsRepository(this.apiService, this.ref);

  Future<ApiResponse<List<AnnouncementModel>>> getAnnouncements() async {
    final response = await repositoryRequestHandler<List<AnnouncementModel>>(
      () => apiService.get(ApiLink.getAnnouncements),
      fromJson: (data) {
        return (data as List)
            .map((item) => AnnouncementModel.fromJson(item))
            .toList();
      },
    );
    return response;
  }

  Future<ApiResponse<void>> createAnnouncement({
    required String title,
    required String body,
    required int targetAudienceId,
  }) async {
    final response = await repositoryRequestHandler<void>(
      () => apiService.post(
        ApiLink.createAnnouncement,
        data: {
          "title": title,
          "body": body,
          "targetAudienceId": targetAudienceId,
        },
      ),
    );
    return response;
  }
}
