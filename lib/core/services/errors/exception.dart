import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yusr/core/constants/app_route.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'انتهت صلاحية الجلسة أو تم تعديل بياناتك. أنت الآن تتصفح كزائر.',
          ),
          backgroundColor: Colors.orange, // لون برتقالي للتنبيه
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
  ServerException({required this.errModel});
}

void handleDioExceptions(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
    case DioExceptionType.cancel:
      throw ServerException(
        errModel: ErrorModel(
          errorMessage: 'فشل الاتصال، يرجى التحقق من اتصالك بالإنترنت',
          statusCode: 500,
          isSuccess: false,
        ),
      );

    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
      throw ServerException(
        errModel: ErrorModel(
          errorMessage: 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى',
          statusCode: 500,
          isSuccess: false,
        ),
      );

    case DioExceptionType.badResponse:
      switch (error.response?.statusCode) {
        case 401:
          _forceLogout();
          throw ServerException(
            errModel: ErrorModel.fromJson(error.response!.data),
          );
        case 403:
        case 400:
        case 404:
        case 409:
        case 422:
        case 504:
          throw ServerException(
            errModel: ErrorModel.fromJson(error.response!.data),
          );
        default:
          throw ServerException(
            errModel: ErrorModel(
              errorMessage: 'حدث خطأ من الخادم، يرجى المحاولة لاحقاً',
              statusCode: 500,
              isSuccess: false,
            ),
          );
      }
  }
}
