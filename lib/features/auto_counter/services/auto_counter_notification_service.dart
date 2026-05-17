import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../services/auto_counter_strings.dart';

class AutoCounterNotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const String _channelId = 'tawaf_counter';

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
    final type = isTawaf ? AutoCounterStrings.tawaf : AutoCounterStrings.saee;
    final remaining = 7 - completedLap;
    try {
      await _notifications.show(
        completedLap,
        AutoCounterStrings.lapCompletedTitle(type, completedLap),
        remaining > 0
            ? AutoCounterStrings.lapsRemaining(remaining)
            : AutoCounterStrings.allLapsCompleted,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            AutoCounterStrings.notificationChannelName,
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
    final type = isTawaf ? AutoCounterStrings.tawaf : AutoCounterStrings.saee;
    try {
      await _notifications.show(
        100,
        AutoCounterStrings.completionNotificationTitle(type),
        AutoCounterStrings.completionNotificationBody,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            AutoCounterStrings.notificationChannelName,
            importance: Importance.max,
            priority: Priority.max,
            playSound: true,
          ),
        ),
      );
    } catch (_) {}
  }
}
