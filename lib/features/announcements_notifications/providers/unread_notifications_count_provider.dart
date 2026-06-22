import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/features/announcements_notifications/providers/notifications_provider.dart';
// استدعي الملف الأول الذي أنشأناه للتو
import 'read_notifications_provider.dart';

part 'unread_notifications_count_provider.g.dart';

@riverpod
int unreadNotificationsCount(Ref ref) {
  // مراقبة الإشعارات وقائمة المقروء منها
  final notificationsState = ref.watch(notificationsProvider);
  final readIdsState = ref.watch(readNotificationsProvider);

  // ستجلب البيانات إذا اكتمل التحميل، وإذا كان هناك خطأ أو لا تزال تحمل ستعطي null
  final notifications = notificationsState.asData?.value;
  final readIds = readIdsState.asData?.value;

  // التأكد من أن الإشعارات والقائمة المقروءة قد تم تحميلها بالفعل وليست فارغة (null)
  if (notifications != null && readIds != null) {
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
