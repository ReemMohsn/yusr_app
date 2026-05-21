import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/constants/shared_preferences_keys.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/announcements_notifications/data/models/notifications_model.dart';
import 'package:yusr/features/announcements_notifications/providers/notifications_provider.dart';
import 'package:yusr/features/be_leader/data/models/tracking_notification_model.dart';
import 'package:yusr/features/be_leader/presentation/widgets/tracking_session_dialog.dart';
import 'package:yusr/features/be_leader/providers/leader_tracking_controller.dart';
import 'package:yusr/features/be_leader/providers/pilgrim_tracking_controller.dart';
import 'package:yusr/features/be_leader/providers/pilgrims_list_provider.dart';
import 'package:yusr/features/be_leader/providers/tracking_notifications_store.dart';

// خارج الكلاس، دالة الخلفية الرئيسية
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("تم استلام إشعار في الخلفية: ${message.messageId}");

  final prefs = SharedPreferencesAsync();

  if (message.data['status'] == 'tracking_session_ended') {
    // حذف الجلسة النشطة + بطاقة الدعوة المعلقة من الجهاز
    await prefs.remove(SharedPreferencesKeys.sessionId);
    await prefs.remove(SharedPreferencesKeys.pendingTrackingSessionId);
    await prefs.remove(SharedPreferencesKeys.pendingTrackingBody);
    print("[الخلفية] ✅ تم مسح الجلسة وبطاقة الدعوة من الجهاز");
  }

  if (message.data['status'] == 'start_tracking_session') {
    // حفظ الدعوة لتنجو من إغلاق التطبيق
    final sessionId = message.data['sessionId']?.toString() ?? '';
    final body = message.notification?.body ?? 'هل توافق على مشاركة موقعك الجغرافي؟';
    if (sessionId.isNotEmpty && sessionId != '0') {
      await prefs.setString(SharedPreferencesKeys.pendingTrackingSessionId, sessionId);
      await prefs.setString(SharedPreferencesKeys.pendingTrackingBody, body);
      print("[الخلفية] ✅ تم حفظ دعوة الجلسة ($sessionId) في الجهاز");
    }
  }
}

class PushNotificationService {
  // تعريف متغير الإشعارات المحلية
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // دالة التهيئة الرئيسية التي سنستدعيها عند تشغيل التطبيق
  static Future<void> init() async {
    // ==========================================
    // 1. تهيئة الإشعارات المحلية (Local Notifications)
    // ==========================================
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_notification');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid,
        iOS: DarwinInitializationSettings(),
        );

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // 🔥 هنا نستمع للضغطات على الإشعارات المحلية 🔥
        if (response.payload == 'emergency_notification') {
          // إذا ضغط المشرف على إشعار الطوارئ، نوقف الصوت ونفعل خاصية الكتم اليدوي
          final context = navigatorKey.currentContext;
          if (context != null) {
            ProviderScope.containerOf(context)
                .read(leaderTrackingControllerProvider.notifier)
                .stopAlarmManual(isUserAction: true);
          }
        }
      },
    );

    // ==========================================
    // 2. تهيئة إشعارات فايربيس (FCM) - (الكود الحالي الخاص بك)
    // ==========================================

    // 1. حالة التطبيق مغلق تماماً (Terminated)
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // 2. حالة التطبيق في الخلفية (Background)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    // 3. حالة التطبيق مفتوح ومستخدم حالياً (Foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showInAppNotification(message);
      }
    });
  }

  // ==========================================
  // دالة التوجيه (عند الضغط على الإشعار من الخلفية أو الإغلاق)
  // ==========================================
  static Future<void> _handleMessage(RemoteMessage message) async {
    debugPrint("==================================================");
    debugPrint("تم الضغط على الإشعار! البيانات المستلمة هي:");
    debugPrint("${message.data}");
    debugPrint("==================================================");

    final context = navigatorKey.currentContext;
    if (context == null) {
      debugPrint("⚠️ خطأ: navigatorKey غير جاهز للتوجيه!");
      return;
    }

    final locale = context.locale;

    // 🔥 1. معالجة إعلانات الحملة
    if (message.data['status'] == 'new_announcement') {
      // ✅ إجبار قائمة الإشعارات على إعادة الجلب من السيرفر لتحديث العداد والقائمة
      ProviderScope.containerOf(context).invalidate(notificationsProvider);

      final notificationModel = NotificationModel(
        notificationId:
            int.tryParse(message.data['notificationId'] ?? '0') ?? 0,
        title: message.notification?.title ?? locale.importantAnnouncement,
        body: message.notification?.body ?? '',
        sentAtDate: message.data['sentAtDate'] ?? '',
        sentAtTime: message.data['sentAtTime'] ?? '',
        senderName: message.data['senderName'] ?? locale.administration,
      );

      navigatorKey.currentState!.pushNamed(
        AppRoute.notificationDetailsView,
        arguments: notificationModel,
      );
    }
    // 🔥 2. معال جة إشعار طلب بدء المراقبة
    else if (message.data['status'] == 'start_tracking_session') {
      final sessionId =
          int.tryParse(message.data['sessionId']?.toString() ?? '0') ?? 0;
      final notificationBody =
          message.notification?.body ?? 'هل توافق على مشاركة موقعك الجغرافي؟';

      if (sessionId > 0) {
        // ─── حفظ الدعوة في SharedPreferences لتنجو من إغلاق التطبيق ───
        final prefs = SharedPreferencesAsync();
        // نحفظ الـ container قبل الـ await لتجنب مشكلة BuildContext عبر الـ async
        final container = ProviderScope.containerOf(context);
        await prefs.setString(
          SharedPreferencesKeys.pendingTrackingSessionId,
          sessionId.toString(),
        );
        await prefs.setString(
          SharedPreferencesKeys.pendingTrackingBody,
          notificationBody,
        );
        // ─── حفظ الدعوة في المخزن (RAM) لتظهر في واجهة الإشعارات فوراً ───
        container
            .read(trackingNotificationsStoreProvider.notifier)
            .addNotification(
              TrackingNotificationModel(
                id: 'session_invite_$sessionId',
                title: '📍 طلب مشاركة الموقع',
                body: notificationBody,
                timestamp: DateTime.now().toIso8601String(),
                type: TrackingNotificationType.sessionInvite,
                sessionId: sessionId,
              ),
            );
        _showTrackingAcceptDialog(context, sessionId, notificationBody);
      }
    } else if (message.data['status'] == 'pilgrim_status_changed') {
      final sessionId =
          int.tryParse(message.data['sessionId']?.toString() ?? '0') ?? 0;

      if (sessionId > 0) {
        // تحديث البيانات قبل الانتقال
        ProviderScope.containerOf(
          context,
        ).invalidate(pilgrimsListProvider(sessionId));

        // التوجيه إلى صفحة قائمة الحجاج
        navigatorKey.currentState!.pushNamed(
          AppRoute.leaderPilgrimsListView,
          arguments: sessionId,
        );
      }
    }
    else if (message.data['status'] == 'tracking_session_ended') {
      final sessionId =
          int.tryParse(message.data['sessionId']?.toString() ?? '0') ?? 0;
      // نحفظ الـ container قبل الـ await لتجنب مشكلة BuildContext عبر الـ async
      final container = ProviderScope.containerOf(context);
      // إيقاف التتبع (يُصفِّر activeSessionIdProvider تلقائياً)
      container.read(pilgrimTrackingControllerProvider.notifier).stopTracking();
      // حذف بطاقة الدعوة من SharedPreferences
      final prefs = SharedPreferencesAsync();
      await prefs.remove(SharedPreferencesKeys.pendingTrackingSessionId);
      await prefs.remove(SharedPreferencesKeys.pendingTrackingBody);
      // حذف إشعارات الجلسة من المخزن (RAM)
      final store = container.read(trackingNotificationsStoreProvider.notifier);
      if (sessionId > 0) {
        store.clearBySessionId(sessionId);
      } else {
        store.clearSessionInvite();
      }
      // إغلاق خريطة الحاج والعودة للرئيسية
      navigatorKey.currentState?.popUntil((route) {
        return route.settings.name == AppRoute.mainHomeView || route.isFirst;
      });
    } else {
      debugPrint("⚠️ التوجيه لم يحدث! نوع الإشعار غير معروف.");
    }
  }

  // ==========================================
  // دالة إظهار التنبيه إذا كان التطبيق مفتوحاً
  // ==========================================
  static Future<void> _showInAppNotification(RemoteMessage message) async {
    final context = navigatorKey.currentContext;
    if (context == null) return;
    final status = message.data['status'];
    final locale = context.locale;
    // 🌟 إذا كان الإشعار لطلب المراقبة والتطبيق مفتوح، نظهر الدايلوج فوراً!
    // 🔥 2. معالجة إشعار طلب بدء المراقبة
    if (message.data['status'] == 'start_tracking_session') {
      final sessionId =
          int.tryParse(message.data['sessionId']?.toString() ?? '0') ?? 0;
      final notificationBody =
          message.notification?.body ?? 'هل توافق على مشاركة موقعك الجغرافي؟';
      if (sessionId > 0) {
        // حفظ الدعوة في SharedPreferences لتنجو من إغلاق التطبيق
        final prefs = SharedPreferencesAsync();
        // نحفظ الـ container قبل الـ await لتجنب مشكلة BuildContext عبر الـ async
        final container = ProviderScope.containerOf(context);
        await prefs.setString(
          SharedPreferencesKeys.pendingTrackingSessionId,
          sessionId.toString(),
        );
        await prefs.setString(
          SharedPreferencesKeys.pendingTrackingBody,
          notificationBody,
        );
        // حفظ الدعوة في المخزن (RAM) لتظهر في واجهة الإشعارات فوراً
        container
            .read(trackingNotificationsStoreProvider.notifier)
            .addNotification(
              TrackingNotificationModel(
                id: 'session_invite_$sessionId',
                title: '📍 طلب مشاركة الموقع',
                body: notificationBody,
                timestamp: DateTime.now().toIso8601String(),
                type: TrackingNotificationType.sessionInvite,
                sessionId: sessionId,
              ),
            );
        _showTrackingAcceptDialog(context, sessionId, notificationBody);
      }
      return;
    }
    if (status == 'tracking_session_ended') {
      final sessionId =
          int.tryParse(message.data['sessionId']?.toString() ?? '0') ?? 0;
      // نحفظ الـ container قبل الـ await لتجنب مشكلة BuildContext عبر الـ async
      final container = ProviderScope.containerOf(context);
      // إيقاف التتبع
      container.read(pilgrimTrackingControllerProvider.notifier).stopTracking();
      // حذف بطاقة الدعوة من SharedPreferences
      final prefs = SharedPreferencesAsync();
      await prefs.remove(SharedPreferencesKeys.pendingTrackingSessionId);
      await prefs.remove(SharedPreferencesKeys.pendingTrackingBody);
      // حذف إشعارات الجلسة من المخزن (RAM)
      final store = container.read(trackingNotificationsStoreProvider.notifier);
      if (sessionId > 0) {
        store.clearBySessionId(sessionId);
      } else {
        store.clearSessionInvite();
      }
      Navigator.popUntil(context, (route) {
        return route.settings.name == AppRoute.mainHomeView || route.isFirst;
      });
    }
    // 🌟 معالجة إشعار تغيّر حالة الحاج: SnackBar ذكي + تحديث البيانات + حفظ في الواجهة
    if (message.data['status'] == 'pilgrim_status_changed') {
      final sessionId =
          int.tryParse(message.data['sessionId']?.toString() ?? '0') ?? 0;
      final pilgrimStatus = message.data['pilgrimStatus']?.toString() ?? '';
      final pilgrimName =
          message.data['pilgrimName']?.toString() ?? 'أحد الحجاج';

      if (sessionId > 0) {
        ProviderScope.containerOf(
          context,
        ).invalidate(pilgrimsListProvider(sessionId));
      }

      String snackMessage;
      Color snackColor;
      IconData snackIcon;

      if (pilgrimStatus == '2') {
        snackMessage = '✅ "$pilgrimName" انضم إلى الجلسة وبدأ التتبع';
        snackColor = Colors.green.shade700;
        snackIcon = Icons.person_add;
      } else if (pilgrimStatus == '3') {
        snackMessage = '❌ "$pilgrimName" رفض الانضمام إلى الجلسة';
        snackColor = Colors.red.shade700;
        snackIcon = Icons.person_remove;
      } else if (pilgrimStatus == '5') {
        snackMessage = '⚠️ "$pilgrimName" أوقف مشاركة موقعه';
        snackColor = Colors.orange.shade700;
        snackIcon = Icons.location_off;
      } else {
        snackMessage =
            '🔔 ${message.notification?.body ?? 'تغيّرت حالة أحد الحجاج'}';
        snackColor = Colors.blueGrey.shade700;
        snackIcon = Icons.info_outline;
      }

      // حفظ في المخزن لتظهر في واجهة الإشعارات
      ProviderScope.containerOf(context)
          .read(trackingNotificationsStoreProvider.notifier)
          .addNotification(
            TrackingNotificationModel(
              id: 'status_${pilgrimName}_${DateTime.now().millisecondsSinceEpoch}',
              title: '👥 تغيّر حالة حاج',
              body: snackMessage,
              timestamp: DateTime.now().toIso8601String(),
              type: TrackingNotificationType.statusChange,
              sessionId: sessionId,
              pilgrimName: pilgrimName,
            ),
          );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(snackIcon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  snackMessage,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: snackColor,
          duration: const Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    // ✅ تحديث قائمة الإشعارات عند وصول إعلان جديد وهو مفتوح
    if (status == 'new_announcement') {
      ProviderScope.containerOf(context).invalidate(notificationsProvider);
    }

    // 3. بناء الـ SnackBar content بشكل ديناميكي حسب نوع الإشعار
    Widget snackBarContent;

    if (status == 'new_announcement') {
      // إشعار إعلان جديد: نضع زري "رؤية التفاصيل" و"إغلاق" داخل الـ content
      // لأن SnackBar يدعم زراً واحداً فقط في الـ action
      snackBarContent = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.notification?.title ?? locale.newNotification,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            message.notification?.body ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  _handleMessage(message);
                },
                child: Text(
                  locale.viewDetails,
                  style: const TextStyle(color: AppColor.golden),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      // باقي الإشعارات: عرض عادي بدون أزرار
      snackBarContent = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.notification?.title ?? locale.newNotification,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            message.notification?.body ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
    }

    // مسح أي SnackBar قديم لمنع التراكم في الـ queue
    ScaffoldMessenger.of(context).clearSnackBars();

    final controller = ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: snackBarContent,
        backgroundColor: AppColor.baseFontColor,
        duration: const Duration(seconds: 5),
      ),
    );

    // إغلاق إجباري بعد 5 ثوانٍ — يضمن الاختفاء حتى مع وجود أزرار داخل الـ content
    Timer(const Duration(seconds: 5), () {
      controller.close();
    });
    //كود اظهار الايقونة الخاصة بالتطبيق للاشعارات
    final int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'yusr_channel_id',        
      'Yusr Notifications',     
      importance: Importance.max,
      priority: Priority.high,
      icon: 'ic_notification',  
      color: const Color(0xFFD4AF37), // اللون الذهبي للدائرة المحيطة باللوحة المنسدلة
      playSound: true,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: const DarwinNotificationDetails(),
    );

    await _localNotificationsPlugin.show(
      notificationId,
      message.notification?.title ?? locale.newNotification,
      message.notification?.body ?? '',
      notificationDetails,
      payload: status, 
    );
  }

  // ==========================================
  // دالة الدايلوج — مُوحَّدة في TrackingSessionDialog
  // ==========================================
  static void _showTrackingAcceptDialog(
    BuildContext context,
    int sessionId,
    String notificationBody,
  ) {
    TrackingSessionDialog.show(
      context,
      sessionId: sessionId,
      notificationBody: notificationBody,
    );
  }
}
