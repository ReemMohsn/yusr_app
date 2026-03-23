import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/services/push_notification_service.dart';
import 'package:yusr/yusr_app.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. تفعيل اللغة العربية لكل التطبيق
  HijriCalendar.setLocal('ar');

  // 2. ضبط التاريخ (اختياري)
  // إذا اكتشفت أن التاريخ في التطبيق متأخر بيوم عن الواقع، اجعلها 1
  // إذا كان صحيحاً اتركها 0
  // HijriCalendar.hAdjustment = 0;

  // if (!SharedPreferencesService.isOnboardingCompleted) {
  //   initialRoute = AppRoute.onBoarding;
  // } else if (!SharedPreferencesService.isLoggedIn) {
  //   initialRoute = AppRoute.login;
  // } else {
  //   initialRoute = AppRoute.mainHome;
  // }
  String initialRoute = AppRoute.mainHomeView;

  // 3. تهيئة فايربيس باستخدام الملف المولد
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(alert: true, badge: true, sound: true);
  try {
    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $token");
  } catch (e) {
    print("Failed to get token: $e");
  }

  // 2. تفعيل خدمة التقاط الضغطات والإشعارات التي برمجناها
  await PushNotificationService.init();
  // await Firebase.initializeApp();

  // طلب صلاحية الإشعارات
  // await FirebaseMessaging.instance.requestPermission();

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
