import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/constants/api_link.dart';
import 'package:yusr/core/services/API/ApiResponse.dart';
import 'package:yusr/core/services/API/api_service.dart';
import 'package:yusr/core/services/API/repository_request_handler.dart';
import 'package:yusr/features/announcements_notifications/data/models/notifications_model.dart';

class NotificationsRepository {
  final ApiService apiService;
  final Ref ref;

  NotificationsRepository(this.apiService, this.ref);

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
