import 'package:dio/dio.dart';
import 'package:yusr/features/auth/data/models/login_model.dart';

import '../shared_preferences_service.dart';

class ApiInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    Future<ProfileModel?> profile = SharedPreferencesService.getProfile();
    options.headers["Authorization"] = "Bearer ${profile}";
    super.onRequest(options, handler);
  }
}

// مثال على بيانات تسجيل الدخول لسرعة وصول جميع المطورين إليها
// {
//   "email": "sys.smartneighborhood@gmail.com",
//   "password": "Mub_12345"
// }
