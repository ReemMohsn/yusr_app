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
import 'package:yusr/features/be_leader/providers/leader_tracking_controller.dart';
import 'package:yusr/features/be_leader/providers/pilgrim_tracking_controller.dart';
import 'package:yusr/features/be_leader/providers/pilgrims_list_provider.dart';
import 'package:yusr/features/home/providers/user_provider.dart';

// خارج الكلاس، دالة الخلفية الرئيسية
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("تم استلام إشعار في الخلفية: ${message.messageId}");

  if (message.data['status'] == 'tracking_session_ended') {
    // تهيئة SharedPreferencesAsync المستقلة وحذف الـ sessionId
    final prefs = SharedPreferencesAsync();
    await prefs.remove(SharedPreferencesKeys.sessionId);
    print("تم مسح الجلسة من الهاتف في الخلفية بسبب إيقافها من المشرف");
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
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

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
  static void _handleMessage(RemoteMessage message) {
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
    else if (message.data['status'] == 'start_tracking_session') {
      // تحويل الـ id إلى int
      final sessionId =
          int.tryParse(message.data['sessionId']?.toString() ?? '0') ?? 0;

      // أخذ النص الفعلي للإشعار (البدي)
      final notificationBody =
          message.notification?.body ?? 'هل توافق على مشاركة موقعك الجغرافي؟';

      if (sessionId > 0) {
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
    } // 🌟🌟 4. معالجة إشعار إنهاء الجلسة من المشرف (للحاج) 🌟🌟
    else if (message.data['status'] == 'tracking_session_ended') {
      // إيقاف التتبع محلياً (يُصفِّر activeSessionIdProvider تلقائياً)
      ProviderScope.containerOf(
        context,
      ).read(pilgrimTrackingControllerProvider.notifier).stopTracking();
      // إغلاق خريطة الحاج إن كانت مفتوحة والعودة للرئيسية
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
  static void _showInAppNotification(RemoteMessage message) {
    final context = navigatorKey.currentContext;
    if (context == null) return;
    final status = message.data['status'];
    final locale = context.locale;
    // 🌟 إذا كان الإشعار لطلب المراقبة والتطبيق مفتوح، نظهر الدايلوج فوراً!
    // 🔥 2. معالجة إشعار طلب بدء المراقبة
    if (message.data['status'] == 'start_tracking_session') {
      // تحويل الـ id إلى int
      final sessionId =
          int.tryParse(message.data['sessionId']?.toString() ?? '0') ?? 0;

      // أخذ النص الفعلي للإشعار (البدي)
      final notificationBody =
          message.notification?.body ?? 'هل توافق على مشاركة موقعك الجغرافي؟';

      if (sessionId > 0) {
        _showTrackingAcceptDialog(context, sessionId, notificationBody);
      }
      return; // نخرج من الدالة حتى لا يظهر SnackBar لهذا النوع من الإشعارات
    }
    if (status == 'tracking_session_ended') {
      // 1. نوقف التتبع محلياً
      ProviderScope.containerOf(
        context,
      ).read(pilgrimTrackingControllerProvider.notifier).stopTracking();
      // 2. نتحقق مما إذا كانت واجهة خريطة الحاج مفتوحة لإغلاقها
      // يمكننا معرفة ذلك عبر محاولة إغلاقها، لكن الأفضل التأكد من نوع الـ Widget الحالية
      // طريقة آمنة للرجوع للخلف إذا كنا في شاشة التتبع:
      Navigator.popUntil(context, (route) {
        // نفترض أن مسار الشاشة الرئيسية هو '/' أو اسم مسارك الرئيسي
        // سيقوم بعمل pop للواجهات حتى يصل للرئيسية، وبالتالي يغلق شاشة الخريطة إن وجدت
        return route.settings.name == AppRoute.mainHomeView || route.isFirst;
      });
    }
    // 🌟 معالجة إشعار تغيّر حالة الحاج: SnackBar ذكي + تحديث البيانات
    if (message.data['status'] == 'pilgrim_status_changed') {
      final sessionId =
          int.tryParse(message.data['sessionId']?.toString() ?? '0') ?? 0;
      final pilgrimStatus = message.data['pilgrimStatus']?.toString() ?? '';
      final pilgrimName =
          message.data['pilgrimName']?.toString() ?? 'أحد الحجاج';

      // تحديث بيانات قائمة الحجاج تلقائياً (بدون انتقال قسري للصفحة)
      if (sessionId > 0) {
        ProviderScope.containerOf(
          context,
        ).invalidate(pilgrimsListProvider(sessionId));
      }

      // تحديد رسالة الـ SnackBar بناءً على حالة الحاج
      String snackMessage;
      Color snackColor;
      IconData snackIcon;

      if (pilgrimStatus == '2') {
        // انضم للجلسة وبدأ التتبع
        snackMessage = '✅ "$pilgrimName" انضم إلى الجلسة وبدأ التتبع';
        snackColor = Colors.green.shade700;
        snackIcon = Icons.person_add;
      } else if (pilgrimStatus == '3') {
        // رفض الانضمام
        snackMessage = '❌ "$pilgrimName" رفض الانضمام إلى الجلسة';
        snackColor = Colors.red.shade700;
        snackIcon = Icons.person_remove;
      } else if (pilgrimStatus == '5') {
        // أوقف التتبع بنفسه
        snackMessage = '⚠️ "$pilgrimName" أوقف مشاركة موقعه';
        snackColor = Colors.orange.shade700;
        snackIcon = Icons.location_off;
      } else {
        snackMessage =
            '🔔 ${message.notification?.body ?? 'تغيّرت حالة أحد الحجاج'}';
        snackColor = Colors.blueGrey.shade700;
        snackIcon = Icons.info_outline;
      }

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
      return; // نخرج لكي لا يظهر SnackBar عام أيضاً
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
  }

  // ==========================================
  // دالة الدايلوج الخاصة بطلب التتبع
  // ==========================================
  static void _showTrackingAcceptDialog(
    BuildContext context,
    int sessionId, // أصبح int
    String notificationBody, // أصبحنا نمرر نص الإشعار
  ) {
    showDialog(
      context: context,
      barrierDismissible: false, // لا يمكن إغلاقه بالضغط بالخارج
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.location_on, color: AppColor.golden),
              SizedBox(width: 8),
              Text('طلب مشاركة الموقع', style: TextStyle(fontSize: 16)),
            ],
          ),
          content: Text(notificationBody),
          actions: [
            // زر الرفض
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // استدعاء دالة الرفض
                ProviderScope.containerOf(context)
                    .read(pilgrimTrackingControllerProvider.notifier)
                    .rejectSession(sessionId: sessionId);
              },
              child: const Text('رفض', style: TextStyle(color: Colors.red)),
            ),
            // زر الموافقة
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColor.golden),
              // 🔥 التعديل هنا: تحويل الدالة إلى async
              onPressed: () async {
                Navigator.pop(context); // إغلاق الدايلوج أولاً

                final userState = ProviderScope.containerOf(
                  context,
                ).read(userProfileProvider);
                final profile = userState.value;

                if (profile != null) {
                  try {
                    // 🔥 التعديل هنا: انتظار نجاح دالة الموافقة وبدء التتبع
                    await ProviderScope.containerOf(context)
                        .read(pilgrimTrackingControllerProvider.notifier)
                        .acceptAndStartTracking(
                          sessionId: sessionId,
                          pilgrimId: profile.userId.toString(),
                          pilgrimName: profile.fullName,
                        );

                    // 🔥 التعديل هنا: التوجيه إلى شاشة التتبع بعد النجاح
                    // تأكد أن AppRoute.pilgrimMapTrackingView معرف مسبقاً في ملف app_route.dart
                    navigatorKey.currentState?.pushNamed(
                      AppRoute.pilgrimMapTrackingView,
                      arguments:
                          sessionId, // تمرير الـ sessionId إذا كانت الشاشة تحتاجه
                    );
                  } catch (e) {
                    // يمكنك هنا إضافة سناك بار لإظهار رسالة خطأ للمستخدم في حال فشل العملية
                    print("حدث خطأ أثناء بدء التتبع: $e");
                  }
                }
              },
              child: const Text('موافق', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
