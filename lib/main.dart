import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/yusr_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  String initialRoute;
  // if (!SharedPreferencesService.isOnboardingCompleted) {
  //   initialRoute = AppRoute.onBoarding;
  // } else if (!SharedPreferencesService.isLoggedIn) {
  //   initialRoute = AppRoute.login;
  // } else {
  //   initialRoute = AppRoute.mainHome;
  // }
  initialRoute = AppRoute.onBoarding;

  runApp(
    ProviderScope(
      child: YusrApp(appRouter: AppRouter(), initialRoute: initialRoute),
    ),
  );
}
