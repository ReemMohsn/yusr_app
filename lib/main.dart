import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/services/push_notification_service.dart';
import 'package:yusr/yusr_app.dart';
import 'firebase_options.dart';

void main() async {
  // 1. تفعيل اللغة العربية لكل التطبيق
  HijriCalendar.setLocal('ar');

  // 2. ضبط التاريخ (اختياري)
  // إذا اكتشفت أن التاريخ في التطبيق متأخر بيوم عن الواقع، اجعلها 1
  // إذا كان صحيحاً اتركها 0
  // HijriCalendar.hAdjustment = 0;
  WidgetsFlutterBinding.ensureInitialized();

  String initialRoute = AppRoute.mainHomeView;
  // 3. تهيئة فايربيس باستخدام الملف المولد
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
