import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:yusr/core/constants/app_route.dart'; // مسار ملف الروتس الخاص بك

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
  // دالة التوجيه (هنا السحر للذهاب لصفحة الإعلانات)
  // ==========================================
  static void _handleMessage(RemoteMessage message) {
    // نتأكد أن الباك إند أرسل نوع الإشعار في الـ Data Payload
    if (message.data['type'] == 'announcement') {
      // يمكننا استخراج رقم الإعلان إذا أردنا عرض إعلان محدد
      // final announcementId = message.data['announcement_id'];

      // نستخدم navigatorKey للانتقال لصفحة الإعلانات فوراً
      navigatorKey.currentState?.pushNamed(AppRoute.announcementsView);
    }
  }

  // ==========================================
  // دالة إظهار تنبيه إذا كان التطبيق مفتوحاً في يد المستخدم
  // ==========================================
  static void _showInAppNotification(RemoteMessage message) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.notification?.title ?? 'إشعار جديد',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(message.notification?.body ?? ''),
            ],
          ),
          backgroundColor: Colors.blueGrey.shade800,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'عرض التفاصيل',
            textColor: Colors.amber,
            onPressed: () {
              // عند الضغط على الزر في السناك بار، نوجهه للصفحة
              _handleMessage(message);
            },
          ),
        ),
      );
    }
  }
}
