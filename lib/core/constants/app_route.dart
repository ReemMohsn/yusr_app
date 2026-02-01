// مثال فقط لروابط  التنقل لإتباع نفس الإسلوب
import 'package:flutter/material.dart';
import 'package:yusr/features/auth/presentation/views/account_verification.dart';
import 'package:yusr/features/auth/presentation/views/forgot_password.dart';
import 'package:yusr/features/auth/presentation/views/login_view.dart';
import 'package:yusr/features/home/presentation/views/main_home_view.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoute.mainHomeView:
        return MaterialPageRoute(builder: (_) => const MainHomeView());
      case AppRoute.loginView:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case AppRoute.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPassword());
      case AppRoute.otpVerificationView:
        return MaterialPageRoute(builder: (_) => const OtpVerificationView());
      default:
        return null;
    }
  }
}

class AppRoute {
  static const String mainHomeView = '/MainHomeView';
  static const String loginView = '/loginView';
  static const String forgotPassword = '/ForgotPassword';
  static const String otpVerificationView = '/OtpVerificationView';
}
