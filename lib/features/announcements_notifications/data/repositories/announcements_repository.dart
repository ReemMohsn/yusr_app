import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/constants/api_link.dart';
import 'package:yusr/core/services/API/ApiResponse.dart';
import 'package:yusr/core/services/API/api_service.dart';
import 'package:yusr/core/services/API/repository_request_handler.dart';
import 'package:yusr/features/announcements_notifications/data/models/announcement_model.dart';
import 'package:yusr/features/announcements_notifications/data/models/notifications_model.dart' show NotificationModel;

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

  Future<ApiResponse<dynamic>> createAnnouncement({
    required String title,
    required String body,
    required int targetAudienceId,
  }) async {
    final response = await repositoryRequestHandler<dynamic>(
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

  Future<ApiResponse<dynamic>> deleteAnnouncement(int id) async {
    final response = await repositoryRequestHandler<dynamic>(
      () => apiService.delete("${ApiLink.deleteAnnouncement}/$id"),
    );
    return response;
  }
  Future<ApiResponse<List<NotificationModel>>> getNotifications() async {
    final response = await repositoryRequestHandler<List<NotificationModel>>(
      () => apiService.get(ApiLink.getNotifications),
      fromJson: (data) {
        return (data as List)
            .map((item) => NotificationModel.fromJson(item))
            .toList();
      },
    );
    return response;
  }
}
