import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/features/announcements_notifications/data/models/announcement_model.dart';
import 'package:yusr/features/announcements_notifications/providers/announcements_repository_provider.dart';
// استدعِ المستودع والموديل هنا

part 'announcements_provider.g.dart';

@riverpod
Future<List<AnnouncementModel>> announcements(Ref ref) async {
  final repository = ref.watch(announcementsRepositoryProvider);
  final response = await repository.getAnnouncements();

  // نعيد قائمة الإعلانات، وإذا كانت null نعيد قائمة فارغة
  return response.data ?? [];
}
