import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/extensions/context_extension.dart';

import 'errormodel.dart';

Future<void> _forceLogout() async {
  try {
    // 1. مسح توكن الفايربيس
    await FirebaseMessaging.instance.deleteToken();

    // 2. مسح التخزين المحلي (بمجرد مسحه، التطبيق سيعتبره زائر)
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // 3. التوجيه وتدمير السجل (The Magic Fix)
    // نوجهه إلى MainHomeView ونمسح كل شيء خلفه
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      AppRoute.mainHomeView, // 🔥 التعديل هنا: نرجعه للرئيسية كزائر
      (route) => false, // 🔥 هذا السطر يدمر أي شاشات محمية سابقة (يحل تخوفك)
    );

    // 4. إشعار المستخدم بما حدث (تجربة مستخدم ممتازة)
    final context = navigatorKey.currentContext;
    if (context != null) {
      final locale = context.locale;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(locale.sessionExpiredGuest),
          backgroundColor: const Color.fromARGB(
            255,
            232,
            197,
            42,
          ), // لون برتقالي للتنبيه
          duration: Duration(seconds: 4),
        ),
      );
    }
  } catch (e) {
    debugPrint("حدث خطأ أثناء تحويل المستخدم لزائر: $e");
  }
}

class ServerException implements Exception {
  final ErrorModel errModel;
  @override
  String toString() => errModel.errorMessage; // سيظهر النص العربي فوراً
  ServerException({required this.errModel});
}

void handleDioExceptions(DioException error) {
  final context = navigatorKey.currentContext;
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
    case DioExceptionType.cancel:
      throw ServerException(
        errModel: ErrorModel(
          errorMessage:
              context?.locale.connectionFailed ??
              'فشل الاتصال، يرجى التحقق من اتصالك بالإنترنت',
          statusCode: 500,
          isSuccess: false,
        ),
      );

    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
      throw ServerException(
        errModel: ErrorModel(
          errorMessage:
              context?.locale.unexpectedError ??
              'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى',
          statusCode: 500,
          isSuccess: false,
        ),
      );

    case DioExceptionType.badResponse:
      switch (error.response?.statusCode) {
        case 401:
          // 1. نجلب مسار الرابط الذي تسبب في الخطأ
          final requestPath = error.requestOptions.path;

          final isLoginRequest = requestPath.contains('LoginMobile');

          // 3. إذا لم يكن الطلب لتسجيل الدخول، إذن التوكن انتهى، نفذ الخروج
          if (!isLoginRequest) {
            _forceLogout();
          }
          throw ServerException(
            errModel: ErrorModel.fromJson(error.response!.data),
          );
        case 403:
        case 400:
        case 404:
        case 409:
        case 422:
          throw ServerException(
            errModel: ErrorModel.fromJson(error.response!.data),
          );
        case 504:
        case 503:
          throw ServerException(
            errModel: ErrorModel(
              errorMessage:
                  context?.locale.serverNotResponding ??
                  'الخادم لا يستجيب حالياً، يرجى المحاولة لاحقاً',
              statusCode: 504,
              isSuccess: false,
            ),
          );
        default:
          throw ServerException(
            errModel: ErrorModel(
              errorMessage:
                  context?.locale.serverError ??
                  'حدث خطأ من الخادم، يرجى المحاولة لاحقاً',
              statusCode: 500,
              isSuccess: false,
            ),
          );
      }
  }
}
