import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/common/providers/shared_preferences_service_provider.dart';
import 'package:yusr/core/services/shared_preferences_service.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/constants/shared_preferences_keys.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/announcements_notifications/data/models/notifications_model.dart';
import 'package:yusr/features/announcements_notifications/providers/notifications_provider.dart';
import 'package:yusr/features/be_leader/data/models/tracking_notification_model.dart';
import 'package:yusr/features/be_leader/presentation/widgets/tracking_session_dialog.dart';
import 'package:yusr/features/be_leader/providers/leader_tracking_controller.dart';
import 'package:yusr/features/be_leader/providers/pilgrims_list_provider.dart';
import 'package:yusr/features/be_leader/providers/tracking_notifications_store.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("[الخلفية] 📩 إشعار وصل في الخلفية");
  debugPrint("[الخلفية] messageId: ${message.messageId}");
  debugPrint("[الخلفية] data: ${message.data}");
  debugPrint("[الخلفية] notification title: ${message.notification?.title}");
  debugPrint("[الخلفية] notification body: ${message.notification?.body}");

  final prefs = SharedPreferencesService();
  final status = message.data['status'];

  // ✅ إشعار إنهاء الجلسة
  // if (status == 'end_tracking_session') {
  //   // 1️⃣ مسح البيانات من الذاكرة لكي لا تُقرأ كجلسة معلقة
  //   await prefs.removeKey(SharedPreferencesKeys.sessionId);
  //   await prefs.removeKey(SharedPreferencesKeys.pendingTrackingSessionId);
  //   await prefs.removeKey(SharedPreferencesKeys.pendingTrackingBody);
  //   debugPrint(
  //     '[الخلفية] ✅ تم مسح الجلسة المعلقة من الذاكرة (سيتولى MainHomeView التحقق عبر Firebase)',
  //   );
  //   return;
  // }

  // ✅ إشعار بدء الجلسة — حفظ الدعوة لتنجو من إغلاق/خلفية التطبيق
  if (status == 'start_tracking_session') {
    final sessionId = message.data['sessionId']?.toString() ?? '';
    final locale = navigatorKey.currentContext?.locale;
    final title =
        message.data['title'] ??
        locale?.locationRequestTitle ??
        '📍 طلب مشاركة الموقع';
    final body =
        message.data['body'] ??
        locale?.locationRequestBody ??
        'هل توافق على مشاركة موقعك الجغرافي؟';
    if (sessionId.isNotEmpty && sessionId != '0') {
      await prefs.setString(
        SharedPreferencesKeys.pendingTrackingSessionId,
        sessionId,
      );
      await prefs.setString(SharedPreferencesKeys.pendingTrackingBody, body);
      debugPrint("[الخلفية] ✅ تم حفظ دعوة الجلسة ($sessionId) في الجهاز");

      // إظهار الإشعار يدوياً لأن النظام لن يظهره تلقائياً للـ Data-Only message
      try {
        final FlutterLocalNotificationsPlugin localPlugin =
            FlutterLocalNotificationsPlugin();
        const AndroidInitializationSettings initSettingsAndroid =
            AndroidInitializationSettings('ic_notification');
        const InitializationSettings initSettings = InitializationSettings(
          android: initSettingsAndroid,
          iOS: DarwinInitializationSettings(),
        );
        await localPlugin.initialize(initSettings);

        const AndroidNotificationDetails androidDetails =
            AndroidNotificationDetails(
              'yusr_channel_id',
              'Yusr Notifications',
              importance: Importance.max,
              priority: Priority.high,
              icon: 'ic_notification',
              color: Color(0xFFD4AF37),
              playSound: true,
            );
        const NotificationDetails platformDetails = NotificationDetails(
          android: androidDetails,
          iOS: DarwinNotificationDetails(),
        );
        final int notificationId =
            DateTime.now().millisecondsSinceEpoch ~/ 1000;
        await localPlugin.show(
          notificationId,
          title,
          body,
          platformDetails,
          payload: 'start_tracking_session_from_background',
        );
      } catch (e) {
        debugPrint("[الخلفية] ❌ خطأ في عرض الإشعار المحلي: $e");
      }
    }
    return;
  }

  debugPrint("[الخلفية] ⚠️ status غير معروف أو لا يحتاج معالجة: '$status'");
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
        InitializationSettings(
          android: initializationSettingsAndroid,
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
        } else if (response.payload ==
            'start_tracking_session_from_background') {
          final context = navigatorKey.currentContext;
          if (context != null) {
            Future(() async {
              final container = ProviderScope.containerOf(context);
              final prefs = container.read(sharedPreferencesServiceProvider);
              final sessionIdStr = await prefs.getString(
                SharedPreferencesKeys.pendingTrackingSessionId,
              );
              final body =
                  await prefs.getString(
                    SharedPreferencesKeys.pendingTrackingBody,
                  ) ??
                  'هل توافق على مشاركة موقعك الجغرافي؟';
              final sessionId = int.tryParse(sessionIdStr ?? '0') ?? 0;
              if (sessionId > 0 && context.mounted) {
                _showTrackingAcceptDialog(context, sessionId, body);
              }
            });
          }
        }
      },
    );

    // ==========================================
    // 2. تهيئة إشعارات فايربيس (FCM) - (الكود الحالي الخاص بك)
    // ==========================================

    // تسجيل دالة الخلفية (مهم جداً جداً لاستلام Data-Only Messages والتطبيق مغلق)
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 1. حالة التطبيق مغلق تماماً (Terminated)
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();
    if (initialMessage != null) {
      final initStatus = initialMessage.data['status'];
      if (initStatus != 'start_tracking_session') {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleMessage(initialMessage);
        });
      }
    }

    // 2. حالة التطبيق في الخلفية (Background)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    // 3. حالة التطبيق مفتوح ومستخدم حالياً (Foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final status = message.data['status'];

      debugPrint("═══════════════════════════════════════════════");
      debugPrint("[المقدمة] 📩 إشعار وصل والتطبيق مفتوح");
      debugPrint("[المقدمة] data: ${message.data}");
      debugPrint("[المقدمة] status: '$status'");
      debugPrint("[المقدمة] notification: ${message.notification?.title}");
      debugPrint("═══════════════════════════════════════════════");

      // ✅ الرسائل الحرجة تُعالَج دائماً (حتى بدون notification)، أما الباقي فيحتاج لـ notification
      if (status == 'end_tracking_session' ||
          status == 'start_tracking_session' ||
          message.notification != null) {
        _showInAppNotification(message);
      } else {
        debugPrint(
          "[المقدمة] ⚠️ رسالة بدون notification ولا تنتمي للحالات الحرجة — تُجاهَل",
        );
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
    // 🔥 2. معالجة إشعار طلب بدء المراقبة
    // else if (message.data['status'] == 'start_tracking_session') {
    //   final sessionId =
    //       int.tryParse(message.data['sessionId']?.toString() ?? '0') ?? 0;
    //   final notificationBody =
    //       message.data['body'] ??
    //       locale.locationRequestBody ??
    //       'هل توافق على مشاركة موقعك الجغرافي؟';
    //   if (sessionId > 0) {
    //     _showTrackingAcceptDialog(context, sessionId, notificationBody);
    //   }
    // }
    else if (message.data['status'] == 'pilgrim_status_changed') {
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
      final title =
          message.data['title'] ??
          locale.locationRequestTitle ??
          '📍 طلب مشاركة الموقع';
      final body =
          message.data['body'] ??
          locale.locationRequestBody ??
          'هل توافق على مشاركة موقعك الجغرافي؟';
      if (sessionId > 0) {
        // حفظ الدعوة في SharedPreferences لتنجو من إغلاق التطبيق
        final container = ProviderScope.containerOf(context);
        final prefs = container.read(sharedPreferencesServiceProvider);

        await prefs.setString(
          SharedPreferencesKeys.pendingTrackingSessionId,
          sessionId.toString(),
        );
        await prefs.setString(SharedPreferencesKeys.pendingTrackingBody, body);
        if (!context.mounted) return;
        // حفظ الدعوة في المخزن (RAM) لتظهر في واجهة الإشعارات فوراً
        container
            .read(trackingNotificationsStoreProvider.notifier)
            .addNotification(
              TrackingNotificationModel(
                id: 'session_invite_$sessionId',
                title: title,
                body: body,
                timestamp: DateTime.now().toIso8601String(),
                type: TrackingNotificationType.sessionInvite,
                sessionId: sessionId,
              ),
            );
        _showTrackingAcceptDialog(context, sessionId, body);
      }
      return;
    }
    if (status == 'end_tracking_session') {
      // 💡 تنظيف الدعوة المعلقة إذا كان المستخدم لم يقبلها بعد
      final container = ProviderScope.containerOf(context);
      final prefs = container.read(sharedPreferencesServiceProvider);
      final pendingSessionId = await prefs.getString(
        SharedPreferencesKeys.pendingTrackingSessionId,
      );
      final endedSessionId = message.data['sessionId']?.toString();

      // بما أن الباك إند لم يرسل sessionId في إشعار الإنهاء، سنقوم بالتنظيف إذا كان
      // endedSessionId null، أو إذا كان يطابق pendingSessionId.
      if (pendingSessionId != null &&
          (endedSessionId == null || pendingSessionId == endedSessionId)) {
        if (context.mounted) {
          final container = ProviderScope.containerOf(context);
          container
              .read(trackingNotificationsStoreProvider.notifier)
              .clearSessionInvite();
        }
        debugPrint(
          "✅ [PushNotification] تم مسح الدعوة المعلقة لأن المشرف أنهى الجلسة قبل القبول.",
        );
      } else {
        debugPrint(
          "✅ [PushNotification] تم تجاهل إشعار end_tracking_session في المقدمة لتجنب التكرار (سيتولى الفايربيس الباقي).",
        );
      }
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
        snackMessage = locale.pilgrimJoinedSession(pilgrimName);
        snackColor = Colors.green.shade700;
        snackIcon = Icons.person_add;
      } else if (pilgrimStatus == '3') {
        snackMessage = locale.pilgrimRejectedSession(pilgrimName);
        snackColor = Colors.red.shade700;
        snackIcon = Icons.person_remove;
      } else if (pilgrimStatus == '5') {
        snackMessage = locale.pilgrimStoppedSharingLocation(pilgrimName);
        snackColor = Colors.orange.shade700;
        snackIcon = Icons.location_off;
      } else {
        snackMessage =
            '🔔 ${message.notification?.body ?? locale.pilgrimStatusChanged}';
        snackColor = Colors.blueGrey.shade700;
        snackIcon = Icons.info_outline;
      }

      // حفظ في المخزن لتظهر في واجهة الإشعارات
      ProviderScope.containerOf(context)
          .read(trackingNotificationsStoreProvider.notifier)
          .addNotification(
            TrackingNotificationModel(
              id: 'status_${pilgrimName}_${DateTime.now().millisecondsSinceEpoch}',
              title: locale.pilgrimStatusChangedTitle,
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
            message.data['title'] ??
                message.notification?.title ??
                locale.newNotification,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            message.data['body'] ?? message.notification?.body ?? '',
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
            message.data['title'] ??
                message.notification?.title ??
                locale.newNotification,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            message.data['body'] ?? message.notification?.body ?? '',
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

    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'yusr_channel_id',
          'Yusr Notifications',
          importance: Importance.max,
          priority: Priority.high,
          icon: 'ic_notification',
          color: const Color(
            0xFFD4AF37,
          ), // اللون الذهبي للدائرة المحيطة باللوحة المنسدلة
          playSound: true,
        );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: const DarwinNotificationDetails(),
    );

    await _localNotificationsPlugin.show(
      notificationId,
      message.data['title'] ??
          message.notification?.title ??
          locale.newNotification,
      message.data['body'] ?? message.notification?.body ?? '',
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
    showTrackingDialog(context, sessionId, notificationBody);
  }

  /// دالة عامة (public) لعرض Dialog قبول/رفض الجلسة.
  /// تُستدعى من [MainHomeView] عند عودة التطبيق من الخلفية/الإغلاق.
  static void showTrackingDialog(
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
