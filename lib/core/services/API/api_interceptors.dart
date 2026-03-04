import 'package:dio/dio.dart';

import '../shared_preferences_service.dart';

class AuthInterceptor extends Interceptor {
  final SharedPreferencesService _prefsService;

  AuthInterceptor(this._prefsService);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // الآن نستخدم النسخة المحقونة (Instance)
      final profile = await _prefsService.getProfile();
      if (profile?.token != null) {
        options.headers["Authorization"] = "Bearer ${profile!.token}";
      }
    } catch (e) {
      // ignore error
    }
    super.onRequest(options, handler);
  }
}
