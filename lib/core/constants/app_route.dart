// مثال فقط لروابط  التنقل لإتباع نفس الإسلوب
import 'package:flutter/material.dart';
import 'package:yusr/features/auth/presentation/views/view.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoute.onBoarding:
        return MaterialPageRoute(
          builder: (_) => const MyHomePage(title: 'OnBoarding'),
        );
      default:
        return null;
    }
  }
}

class AppRoute {
  static const String onBoarding = '/onBoarding';
}
