import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/services/push_notification_service.dart';
import 'package:yusr/yusr_app.dart';
import 'firebase_options.dart';

void main() async {
  // الحفاظ على الشاشة الترحيبية للنظام
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // ضبط لغة التقويم الهجري
  HijriCalendar.setLocal('ar');

  // تهيئة خدمات فايربيس للإشعارات
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(alert: true, badge: true, sound: true);

  // تفعيل خدمة الإشعارات المحلية والالتقاط في الخلفية
  await PushNotificationService.init();

  // التحقق من SharedPreferences لمعرفة هل أكمل المستخدم الـ Onboarding مسبقاً أم لا
  final prefs = await SharedPreferences.getInstance();
  final bool isOnboardingCompleted =
      prefs.getBool('is_onboarding_completed') ?? false;

  // تحديد المسار الابتدائي بناءً على النتيجة
  String initialRoute = isOnboardingCompleted
      ? AppRoute.mainHomeView
      : AppRoute.onboardingView;

  // إزالة الشاشة الترحيبية فقط بعد اكتمال كل شيء
  FlutterNativeSplash.remove();

  runApp(
    ProviderScope(
      child: DevicePreview(
        enabled: false,
        builder: (BuildContext context) {
          return YusrApp(appRouter: AppRouter(), initialRoute: initialRoute);
        },
      ),
    ),
  );
}
