import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/features/announcements_notifications/providers/notifications_provider.dart';
// استدعي الملف الأول الذي أنشأناه للتو
import 'read_notifications_provider.dart';

part 'unread_notifications_count_provider.g.dart';

@riverpod
int unreadNotificationsCount(Ref ref) {
  // مراقبة الإشعارات وقائمة المقروء منها
  final notificationsState = ref.watch(notificationsProvider);
  final readIdsState = ref.watch(
    readNotificationsProvider as ProviderListenable<dynamic>,
  );

  // التأكد من أن الإشعارات والقائمة المقروءة قد تم تحميلها بالفعل بدون أخطاء
  if (notificationsState.hasValue && readIdsState.hasValue) {
    final notifications = notificationsState.value!;
    final readIds = readIdsState.value!;

    int count = 0;
    for (var notification in notifications) {
      // ملاحظة: تأكدي هل المتغير في الموديل اسمه notificationId أم announcementId
      if (!readIds.contains(notification.notificationId.toString())) {
        count++;
      }
    }
    return count;
  }

  // في حالة التحميل أو وجود خطأ، نعيد 0 مؤقتاً
  return 0;
}
