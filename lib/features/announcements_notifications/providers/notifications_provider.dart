import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/features/announcements_notifications/data/models/notifications_model.dart';
import 'package:yusr/features/announcements_notifications/providers/announcements_repository_provider.dart';
// استدعِ المستودع والموديل هنا

part 'notifications_provider.g.dart';

@riverpod
Future<List<NotificationModel>> notifications(Ref ref) async {
  final repository = ref.watch(announcementsRepositoryProvider);
  final response = await repository.getNotifications();

  // نعيد قائمة الإعلانات، وإذا كانت null نعيد قائمة فارغة
  return response.data ?? [];
}
