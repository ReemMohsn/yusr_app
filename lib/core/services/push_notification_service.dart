// // import 'package:firebase_messaging/firebase_messaging.dart';
// // import 'package:flutter/material.dart';
// // import 'package:yusr/core/constants/app_color.dart';
// // import 'package:yusr/core/constants/app_route.dart';
// // import 'package:yusr/features/announcements_notifications/data/models/notifications_model.dart'; // مسار ملف الروتس الخاص بك

// // class PushNotificationService {
// //   // دالة التهيئة الرئيسية التي سنستدعيها عند تشغيل التطبيق
// //   static Future<void> init() async {
// //     // 1. حالة التطبيق مغلق تماماً (Terminated)
// //     // إذا فتح المستخدم التطبيق عن طريق الضغط على إشعار
// //     RemoteMessage? initialMessage = await FirebaseMessaging.instance
// //         .getInitialMessage();
// //     if (initialMessage != null) {
// //       Future.delayed(const Duration(seconds: 1), () {
// //         _handleMessage(initialMessage);
// //       });
// //     }

// //     // 2. حالة التطبيق في الخلفية (Background)
// //     // إذا ضغط المستخدم على إشعار والتطبيق يعمل في الخلفية

// //     // FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
// //     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
// //       // 🔥 تأخير نصف ثانية لضمان استيقاظ الواجهة بالكامل
// //       Future.delayed(const Duration(milliseconds: 500), () {
// //         _handleMessage(message);
// //       });
// //     });
// //     // 3. حالة التطبيق مفتوح ومستخدم حالياً (Foreground)
// //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
// //       // 💡 لأن النظام لا يظهر إشعاراً من نفسه والتطبيق مفتوح،
// //       // سنقوم نحن بعرض رسالة (SnackBar أو Dialog) داخل التطبيق للمستخدم
// //       if (message.notification != null) {
// //         _showInAppNotification(message);
// //       }
// //     });
// //   }

// //   // ==========================================
// //   // دالة التوجيه (هنا السحر للذهاب لصفحة الإعلانات)
// //   // ==========================================
// //   static void _handleMessage(RemoteMessage message) {
// //     if (message.data['status'] == 'new_announcement') {
// //       // 1. تجميع البيانات لبناء الأوبجكت (NotificationModel)
// //       final notificationModel = NotificationModel(
// //         // نقرأ الآي دي من الـ data ونحوله إلى رقم (مع وضع 0 كقيمة افتراضية للأمان)
// //         notificationId:
// //             int.tryParse(message.data['notificationId'] ?? '0') ?? 0,

// //         // نقرأ العنوان والمحتوى من الـ notification الأساسي
// //         title: message.notification?.title ?? 'إعلان هام',
// //         body: message.notification?.body ?? '',

// //         // نقرأ الباقي من الـ data
// //         sentAtDate: message.data['sentAtDate'] ?? '',
// //         sentAtTime: message.data['sentAtTime'] ?? '',
// //         senderName: message.data['senderName'] ?? 'الإدارة',
// //       );

// //       // 2. الانتقال إلى واجهة التفاصيل وتمرير الأوبجكت الجاهز!
// //       // التأكد من أن navigatorKey ليس null قبل الانتقال
// //       if (navigatorKey.currentState != null) {
// //         navigatorKey.currentState!.pushNamed(
// //           AppRoute.notificationDetailsView,
// //           arguments: notificationModel,
// //         );
// //       } else {
// //         print("⚠️ خطأ: navigatorKey غير جاهز للتوجيه!");
// //       }
// //       // navigatorKey.currentState?.pushNamed(
// //       //   AppRoute.notificationDetailsView,
// //       //   arguments: notificationModel, // 🔥 نمرر الأوبجكت هنا
// //       // );
// //     }
// //   }

// //   // static void _handleMessage(RemoteMessage message) {
// //   //   // نتأكد أن الباك إند أرسل نوع الإشعار في الـ Data Payload
// //   //   if (message.data['status'] == 'new_announcement') {
// //   //     // يمكننا استخراج رقم الإعلان إذا أردنا عرض إعلان محدد
// //   //     // final announcementId = message.data['announcement_id'];

// //   //     // نستخدم navigatorKey للانتقال لصفحة الإعلانات فوراً
// //   //     navigatorKey.currentState?.pushNamed(AppRoute.announcementDetailsView);
// //   //   }
// //   // }

// //   // ==========================================
// //   // دالة إظهار تنبيه إذا كان التطبيق مفتوحاً في يد المستخدم
// //   // ==========================================
// //   static void _showInAppNotification(RemoteMessage message) {
// //     final context = navigatorKey.currentContext;
// //     if (context != null) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(
// //                 message.notification?.title ?? 'إشعار جديد',
// //                 style: const TextStyle(fontWeight: FontWeight.bold),
// //               ),
// //               Text(
// //                 message.notification?.body ?? '',
// //                 maxLines: 1,
// //                 overflow: TextOverflow.ellipsis,
// //               ),
// //             ],
// //           ),
// //           backgroundColor: AppColor.baseFontColor,
// //           duration: const Duration(seconds: 5),
// //           action: SnackBarAction(
// //             label: 'عرض التفاصيل',
// //             textColor: AppColor.golden,
// //             onPressed: () {
// //               // عند الضغط على الزر في السناك بار، نوجهه للصفحة
// //               _handleMessage(message);
// //             },
// //           ),
// //         ),
// //       );
// //     }
// //   }
// // }
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:yusr/core/constants/app_color.dart';
// import 'package:yusr/core/constants/app_route.dart';
// import 'package:yusr/features/announcements_notifications/data/models/notifications_model.dart';

// // 🔥 1. أضفنا هذه الدالة "خارج الكلاس" لحل خطأ الـ Background Message
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
//       // 🔥 هذا الرادار مهم جداً! إذا تم الضغط يجب أن تظهر هذه الجملة
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
//   // static Future<void> init() async {
//   //   // 🔥 ربط دالة الخلفية هنا
//   //   FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

//   //   // 1. حالة التطبيق مغلق تماماً (Terminated)
//   //   RemoteMessage? initialMessage = await FirebaseMessaging.instance
//   //       .getInitialMessage();
//   //   if (initialMessage != null) {
//   //     Future.delayed(const Duration(seconds: 1), () {
//   //       _handleMessage(initialMessage);
//   //     });
//   //   }

//   //   // 2. حالة التطبيق في الخلفية (Background)
//   //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//   //     Future.delayed(const Duration(milliseconds: 500), () {
//   //       _handleMessage(message);
//   //     });
//   //   });

//   //   // 3. حالة التطبيق مفتوح ومستخدم حالياً (Foreground)
//   //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//   //     if (message.notification != null) {
//   //       _showInAppNotification(message);
//   //     }
//   //   });
//   // }

//   // ==========================================
//   // دالة التوجيه
//   // ==========================================
//   static void _handleMessage(RemoteMessage message) {
//     // 🔥 2. السطر الأهم: طباعة البيانات القادمة من تطبيق مدير الحملة لمعرفة شكلها الحقيقي
//     print("==================================================");
//     print("تم الضغط على الإشعار! البيانات المستلمة هي:");
//     print(message.data);
//     print("==================================================");

//     // التحقق من الشرط
//     if (message.data['status'] == 'new_announcement') {
//       final notificationModel = NotificationModel(
//         notificationId:
//             int.tryParse(message.data['notificationId'] ?? '0') ?? 0,
//         title: message.notification?.title ?? 'إعلان هام',
//         body: message.notification?.body ?? '',
//         sentAtDate: message.data['sentAtDate'] ?? '',
//         sentAtTime: message.data['sentAtTime'] ?? '',
//         senderName: message.data['senderName'] ?? 'الإدارة',
//       );

//       if (navigatorKey.currentState != null) {
//         navigatorKey.currentState!.pushNamed(
//           AppRoute.notificationDetailsView,
//           arguments: notificationModel,
//         );
//       } else {
//         print("⚠️ خطأ: navigatorKey غير جاهز للتوجيه!");
//       }
//     } else {
//       // 🔥 إذا لم يتحقق الشرط، سيطبع هذا السطر لتعرفي السبب!
//       print(
//         "⚠️ التوجيه لم يحدث! لأن قيمة status ليست 'new_announcement' أو أنها غير موجودة أصلاً.",
//       );
//     }
//   }

//   // ==========================================
//   // دالة إظهار تنبيه إذا كان التطبيق مفتوحاً
//   // ==========================================
//   static void _showInAppNotification(RemoteMessage message) {
//     final context = navigatorKey.currentContext;
//     if (context != null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 message.notification?.title ?? 'إشعار جديد',
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
//             label: 'عرض التفاصيل',
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
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/announcements_notifications/data/models/notifications_model.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("تم استلام إشعار في الخلفية: ${message.messageId}");
}

class PushNotificationService {
  static Future<void> init() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 1. حالة التطبيق مغلق تماماً
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();
    print(
      "🔎 فحص الإشعارات والتطبيق مغلق: ${initialMessage != null ? 'يوجد إشعار!' : 'لا يوجد'}",
    );

    if (initialMessage != null) {
      print("🌟 تم التقاط الإشعار من حالة الإغلاق التام (Terminated) 🌟");
      Future.delayed(const Duration(seconds: 1), () {
        _handleMessage(initialMessage);
      });
    }

    // 2. حالة التطبيق في الخلفية
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("🔥🔥 تم التقاط الضغطة بنجاح من الخلفية (Background) 🔥🔥");
      Future.delayed(const Duration(milliseconds: 500), () {
        _handleMessage(message);
      });
    });

    // 3. حالة التطبيق مفتوح
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showInAppNotification(message);
      }
    });
  }

  // ==========================================
  // دالة التوجيه
  // ==========================================
  static void _handleMessage(RemoteMessage message) {
    // نتأكد أن الباك إند أرسل نوع الإشعار في الـ Data Payload
    if (message.data['status'] == 'new_announcement') {
      // يمكننا استخراج رقم الإعلان إذا أردنا عرض إعلان محدد
      // final announcementId = message.data['announcement_id'];

    // إذا كان الـ context متاحاً، نستخدم الترجمة
    if (context != null) {
      defaultTitle = context.locale.importantAnnouncement;
      defaultSender = context.locale.administration;
    }

    // التحقق من الشرط
    if (message.data['status'] == 'new_announcement') {
      final notificationModel = NotificationModel(
        notificationId:
            int.tryParse(message.data['notificationId'] ?? '0') ?? 0,
        title:
            message.notification?.title ?? defaultTitle, // استخدام الترجمة هنا
        body: message.notification?.body ?? '',
        sentAtDate: message.data['sentAtDate'] ?? '',
        sentAtTime: message.data['sentAtTime'] ?? '',
        senderName:
            message.data['senderName'] ?? defaultSender, // استخدام الترجمة هنا
      );

      if (navigatorKey.currentState != null) {
        navigatorKey.currentState!.pushNamed(
          AppRoute.notificationDetailsView,
          arguments: notificationModel,
        );
      } else {
        print("⚠️ خطأ: navigatorKey غير جاهز للتوجيه!");
      }
    } else {
      print(
        "⚠️ التوجيه لم يحدث! لأن قيمة status ليست 'new_announcement' أو أنها غير موجودة أصلاً.",
      );
    }
  }

  // ==========================================
  // دالة إظهار تنبيه إذا كان التطبيق مفتوحاً
  // ==========================================
  static void _showInAppNotification(RemoteMessage message) {
    final context = navigatorKey.currentContext;

    if (context != null) {
      // 🔥 بما أن الـ context متاح هنا دائماً، يمكننا استخدام الترجمة مباشرة
      final locale = context.locale;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.notification?.title ??
                    locale.newNotification, // استخدام الترجمة
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
            label: locale.viewDetails, // استخدام الترجمة
            textColor: AppColor.golden,
            onPressed: () {
              _handleMessage(message);
            },
          ),
        ),
      );
    }
  }
}
