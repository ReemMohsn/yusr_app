import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/yusr_app.dart';

void main() {
  // 1. تفعيل اللغة العربية لكل التطبيق
  HijriCalendar.setLocal('ar');

  // 2. ضبط التاريخ (اختياري)
  // إذا اكتشفت أن التاريخ في التطبيق متأخر بيوم عن الواقع، اجعلها 1
  // إذا كان صحيحاً اتركها 0
  // HijriCalendar.hAdjustment = 0;
  WidgetsFlutterBinding.ensureInitialized();

  String initialRoute;
  // if (!SharedPreferencesService.isOnboardingCompleted) {
  //   initialRoute = AppRoute.onBoarding;
  // } else if (!SharedPreferencesService.isLoggedIn) {
  //   initialRoute = AppRoute.login;
  // } else {
  //   initialRoute = AppRoute.mainHome;
  // }
  initialRoute = AppRoute.mainHomeView;

  runApp(
    ProviderScope(
      child: DevicePreview(
        enabled: true,
        builder: (BuildContext context) {
          return YusrApp(appRouter: AppRouter(), initialRoute: initialRoute);
        },
      ),
    ),
  );
}
