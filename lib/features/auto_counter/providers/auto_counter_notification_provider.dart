import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/auto_counter_notification_service.dart';

part 'auto_counter_notification_provider.g.dart';

/// بروفايدر خدمة الإشعارات لعداد الطواف والسعي
///
/// keepAlive: true ضروري لأن الخدمة تحتفظ بـ _initialized
/// لو أُعيد إنشاؤها ستحتاج init() من جديد وقد تفشل الإشعارات
@Riverpod(keepAlive: true)
AutoCounterNotificationService autoCounterNotification(Ref ref) {
  return AutoCounterNotificationService();
}
