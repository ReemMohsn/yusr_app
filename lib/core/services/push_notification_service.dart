// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:yusr/core/constants/app_color.dart';
// import 'package:yusr/core/constants/app_route.dart';
// import 'package:yusr/core/extensions/context_extension.dart';
// import 'package:yusr/features/announcements_notifications/data/models/notifications_model.dart';

// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("تم استلام إشعار في الخلفية: ${message.messageId}");
// }

// class PushNotificationService {
//   static Future<void> init() async {
//     FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

//     // 1. حالة التطبيق مغلق تماماً
//     RemoteMessage? initialMessage = await FirebaseMessaging.instance
//         .getInitialMessage();
//     print(
//       "🔎 فحص الإشعارات والتطبيق مغلق: ${initialMessage != null ? 'يوجد إشعار!' : 'لا يوجد'}",
//     );

//     if (initialMessage != null) {
//       print("🌟 تم التقاط الإشعار من حالة الإغلاق التام (Terminated) 🌟");
//       Future.delayed(const Duration(seconds: 1), () {
//         _handleMessage(initialMessage);
//       });
//     }

//     // 2. حالة التطبيق في الخلفية
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print("🔥🔥 تم التقاط الضغطة بنجاح من الخلفية (Background) 🔥🔥");
//       Future.delayed(const Duration(milliseconds: 500), () {
//         _handleMessage(message);
//       });
//     });

//     // 3. حالة التطبيق مفتوح
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       if (message.notification != null) {
//         _showInAppNotification(message);
//       }
//     });
//   }

//   // ==========================================
//   // دالة التوجيه
//   // ==========================================
//   static void _handleMessage(RemoteMessage message) {
//     print("==================================================");
//     print("تم الضغط على الإشعار! البيانات المستلمة هي:");
//     print(message.data);
//     print("==================================================");

//     // 🔥 جلب الـ context من الـ navigatorKey لاستخدام الترجمة
//     final context = navigatorKey.currentContext;

//     // قيم افتراضية في حال كان التطبيق في الخلفية والـ context لم يجهز بعد
//     String defaultTitle = 'إعلان هام';
//     String defaultSender = 'الإدارة';

//     // إذا كان الـ context متاحاً، نستخدم الترجمة
//     if (context != null) {
//       defaultTitle = context.locale.importantAnnouncement;
//       defaultSender = context.locale.administration;
//     }

//     // التحقق من الشرط
//     if (message.data['status'] == 'new_announcement') {
//       final notificationModel = NotificationModel(
//         notificationId:
//             int.tryParse(message.data['notificationId'] ?? '0') ?? 0,
//         title:
//             message.notification?.title ?? defaultTitle, // استخدام الترجمة هنا
//         body: message.notification?.body ?? '',
//         sentAtDate: message.data['sentAtDate'] ?? '',
//         sentAtTime: message.data['sentAtTime'] ?? '',
//         senderName:
//             message.data['senderName'] ?? defaultSender, // استخدام الترجمة هنا
//       );

//       if (navigatorKey.currentState != null) {
//         navigatorKey.currentState!.pushNamed(
//           AppRoute.notificationDetailsView,
//           arguments: notificationModel,
//         );
//       } else {
//         print("⚠️ خطأ: navigatorKey غير جاهز للتوجيه!");
//       }
//     }else if (message.data['status'] == 'start_tracking_session') {
//       final sessionId = message.data['sessionId'] ?? '';
//       final leaderName = message.data['leaderName'] ?? 'مشرف المجموعة';

//       if (sessionId.isNotEmpty) {
//         // استدعاء دالة إظهار الدايلوج
//         _showTrackingAcceptDialog(context, sessionId, leaderName);
//       }
//     } else {
//       print("⚠️ التوجيه لم يحدث! نوع الإشعار غير معروف.");
//     }
//   }

//   // ==========================================
//   // دالة إظهار تنبيه إذا كان التطبيق مفتوحاً
//   // ==========================================
//   static void _showInAppNotification(RemoteMessage message) {
//     final context = navigatorKey.currentContext;

//     if (context != null) {
//       // 🔥 بما أن الـ context متاح هنا دائماً، يمكننا استخدام الترجمة مباشرة
//       final locale = context.locale;

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 message.notification?.title ??
//                     locale.newNotification, // استخدام الترجمة
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 message.notification?.body ?? '',
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//           backgroundColor: AppColor.baseFontColor,
//           duration: const Duration(seconds: 5),
//           action: SnackBarAction(
//             label: locale.viewDetails, // استخدام الترجمة
//             textColor: AppColor.golden,
//             onPressed: () {
//               _handleMessage(message);
//             },
//           ),
//         ),
//       );
//     }
//   }
// }
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as ref show read;
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/announcements_notifications/data/models/notifications_model.dart';
import 'package:yusr/features/be_leader/providers/pilgrim_tracking_controller.dart';
import 'package:yusr/features/home/providers/user_provider.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("تم استلام إشعار في الخلفية: ${message.messageId}");
}

class PushNotificationService {
  // دالة التهيئة الرئيسية التي سنستدعيها عند تشغيل التطبيق
  static Future<void> init() async {
    // 1. حالة التطبيق مغلق تماماً (Terminated)
    // إذا فتح المستخدم التطبيق عن طريق الضغط على إشعار
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // 2. حالة التطبيق في الخلفية (Background)
    // إذا ضغط المستخدم على إشعار والتطبيق يعمل في الخلفية
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    // 3. حالة التطبيق مفتوح ومستخدم حالياً (Foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // 💡 لأن النظام لا يظهر إشعاراً من نفسه والتطبيق مفتوح،
      // سنقوم نحن بعرض رسالة (SnackBar أو Dialog) داخل التطبيق للمستخدم
      if (message.notification != null) {
        _showInAppNotification(message);
      }
    });
  }

  // ==========================================
  // دالة التوجيه (عند الضغط على الإشعار من الخلفية أو الإغلاق)
  // ==========================================
  static void _handleMessage(RemoteMessage message) {
    print("==================================================");
    print("تم الضغط على الإشعار! البيانات المستلمة هي:");
    print(message.data);
    print("==================================================");

    final context = navigatorKey.currentContext;
    if (context == null) {
      print("⚠️ خطأ: navigatorKey غير جاهز للتوجيه!");
      return;
    }

    final locale = context.locale;

    // 🔥 1. معالجة إعلانات الحملة
    if (message.data['status'] == 'new_announcement') {
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
    } else {
      print("⚠️ التوجيه لم يحدث! نوع الإشعار غير معروف.");
    }
  }

  // ==========================================
  // دالة إظهار التنبيه إذا كان التطبيق مفتوحاً
  // ==========================================
  static void _showInAppNotification(RemoteMessage message) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

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

    // 🌟 أما إذا كان إشعاراً عادياً، نظهره كشريط (SnackBar) كما كان سابقاً
    final locale = context.locale;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
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
        ),
        backgroundColor: AppColor.baseFontColor,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: locale.viewDetails,
          textColor: AppColor.golden,
          onPressed: () {
            _handleMessage(message);
          },
        ),
      ),
    );
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
              onPressed: () {
                Navigator.pop(context);

                final userState = ProviderScope.containerOf(
                  context,
                ).read(userProfileProvider);
                final profile = userState.value;

                if (profile != null) {
                  ProviderScope.containerOf(context)
                      .read(pilgrimTrackingControllerProvider.notifier)
                      .acceptAndStartTracking(
                        sessionId: sessionId,
                        pilgrimId: profile.userId.toString(),
                        pilgrimName: profile.fullName,
                      );
                }
                // 🔥 2. نوجه الحاج لشاشة الخريطة الخاصة به ونمرر لها رقم الجلسة
                // navigatorKey.currentState!.pushNamed(
                //   AppRoute.pilgrimMapView, // تأكدي من إضافة هذا المسار في راوتر التطبيق
                //   arguments: sessionId,
                // );
              },
              child: const Text('موافق', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}