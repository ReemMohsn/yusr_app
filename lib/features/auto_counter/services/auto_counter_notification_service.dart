import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// خدمة الإشعارات المحلية لعداد الطواف والسعي
///
/// مسؤولية واحدة: إرسال الإشعارات عند اكتمال الأشواط
/// مستقلة تماماً — لا تعرف شيئاً عن الكونترولر أو الـ State
class AutoCounterNotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const String _channelId = 'tawaf_counter';
  static const String _channelName = 'عداد الطواف والسعي';

  /// تهيئة الإشعارات — يُستدعى مرة واحدة عند بناء الكونترولر
  Future<void> init() async {
    if (_initialized) return;
    try {
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      await _notifications.initialize(
        const InitializationSettings(android: androidSettings),
      );
      _initialized = true;
    } catch (_) {}
  }

  /// إشعار اكتمال شوط واحد
  Future<void> showLapNotification({
    required int completedLap,
    required bool isTawaf,
  }) async {
    if (!_initialized) return;
    final type = isTawaf ? 'الطواف' : 'السعي';
    final remaining = 7 - completedLap;
    try {
      await _notifications.show(
        completedLap,
        '✅ $type — الشوط $completedLap مكتمل',
        remaining > 0 ? 'تبقّى $remaining أشواط' : 'اكتمل النسك بحمد الله!',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            importance: Importance.high,
            priority: Priority.high,
            playSound: false,
          ),
        ),
      );
    } catch (_) {}
  }

  /// إشعار اكتمال النسك كاملاً (الشوط السابع)
  Future<void> showCompletionNotification({required bool isTawaf}) async {
    if (!_initialized) return;
    final type = isTawaf ? 'الطواف' : 'السعي';
    try {
      await _notifications.show(
        100,
        '🎉 تم إتمام $type',
        'اكتملت الأشواط السبعة بحمد الله وفضله',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            importance: Importance.max,
            priority: Priority.max,
            playSound: true,
          ),
        ),
      );
    } catch (_) {}
  }
}
