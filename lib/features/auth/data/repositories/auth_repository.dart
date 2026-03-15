import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/common/providers/shared_preferences_service_provider.dart';
import 'package:yusr/core/constants/api_link.dart';
import 'package:yusr/core/constants/shared_preferences_keys.dart';
import 'package:yusr/core/services/API/ApiResponse.dart';
import 'package:yusr/core/services/API/api_service.dart';
import 'package:yusr/core/services/API/repository_request_handler.dart';
import 'package:yusr/core/services/errors/errormodel.dart';
import 'package:yusr/core/services/errors/exception.dart';
import 'package:yusr/core/services/notification_service.dart';
import 'package:yusr/features/auth/data/models/login_model.dart';

class AuthRepository {
  final ApiService apiService;
  final Ref ref;
  AuthRepository(this.apiService, this.ref);

  Future<ApiResponse<ProfileModel>> login(
    String identifier,
    String password,
  ) async {
    final response = await repositoryRequestHandler<ProfileModel>(
      () => apiService.post(
        ApiLink.login,
        data: {"identifier": identifier, "password": password},
      ),
      fromJson: (data) => ProfileModel.fromJson(data),
    );
    // استخراج دور المستخدم، مع إزالة الفراغات إن وجدت
    final String userRole = response.data?.userRole.trim() ?? '';

    final List<String> allowedRoles = ['حاج', 'مشرف', 'مدير الحملة'];

    if (!allowedRoles.contains(userRole)) {
      throw ServerException(
        errModel: ErrorModel(
          errorMessage: 'دور المستخدم هذا لا يوجد له صلاحية الدخول إلى التطبيق',
          statusCode: 404,
          isSuccess: false,
        ),
      );
    }
    final sharedPrefs = ref.read(sharedPreferencesServiceProvider);
    await sharedPrefs.setProfile(response.data!);

    final notificationService = NotificationService(sharedPrefs, apiService);

    // نستدعيها بدون await لكي تعمل في الخلفية ولا تؤخر انتقال المستخدم للشاشة الرئيسية
    notificationService.syncUserTopics();
    return response;
  }

  Future<ApiResponse<dynamic>> forgotPassword(String email) async {
    final response = await repositoryRequestHandler<dynamic>(
      () => apiService.post(ApiLink.forgotPassword, data: {"email": email}),
    );
    return response; // نعيد الـ ApiResponse (الذي يحتوي على الرسالة)
  }

  Future<ApiResponse<dynamic>> verifyOtp(String otpCode) async {
    final email = await ref
        .read(sharedPreferencesServiceProvider)
        .getString(SharedPreferencesKeys.resetEmail);
    final response = await repositoryRequestHandler<dynamic>(
      () => apiService.post(
        ApiLink.sendCode,
        data: {"email": email ?? '', "code": otpCode},
      ),
    );
    return response;
  }

  Future<ApiResponse<dynamic>> resetPassword(String newPassword) async {
    final email = await ref
        .read(sharedPreferencesServiceProvider)
        .getString(SharedPreferencesKeys.resetEmail);
    final otpCode = await ref
        .read(sharedPreferencesServiceProvider)
        .getString(SharedPreferencesKeys.otpCode);
    final response = await repositoryRequestHandler<dynamic>(
      () => apiService.post(
        ApiLink.resetPassword,
        data: {
          "email": email ?? '',
          "code": otpCode ?? '',
          "newPassword": newPassword,
        },
      ),
      // fromJson: (data) => data['message'],
    );
    return response;
  }

  Future<void> logout() async {
    try {
      // هنا لا نهتم بإرجاع النتيجة (نضعها في طي النسيان) لأننا سنمسح البيانات بكل الأحوال
      await repositoryRequestHandler<dynamic>(
        () => apiService.post(ApiLink.logout, data: {}),
      );
    } catch (e) {
      debugPrint("حدث خطأ في الخادم أثناء تسجيل الخروج: $e");
    } finally {
      // التعديل الجديد: مسح اشتراكات الإشعارات قبل حذف البروفايل
      final sharedPrefs = ref.read(sharedPreferencesServiceProvider);
      final notificationService = NotificationService(sharedPrefs, apiService);

      // هنا نستخدم await لأننا نريد التأكد من حذف التوكن قبل مسح البيانات
      await notificationService.clearTopicsOnLogout();

      // 🔥 مسح البيانات محلياً
      await sharedPrefs.removeProfile();
      await sharedPrefs.clear();
    }
  }
}
