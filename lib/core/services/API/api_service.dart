import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:yusr/core/services/API/api_interceptors.dart';
import 'package:yusr/core/services/shared_preferences_service.dart';

class ApiService {
  late final Dio _dio;
  // لا نحتاج لتخزين الـ prefs هنا، فقط نستخدمها في الـ Constructor
  
  ApiService(SharedPreferencesService prefsService) { // نستقبل الخدمة هنا
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://localhost:7122/api',
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 20),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // نمرر الخدمة للـ Interceptor
    _dio.interceptors.add(AuthInterceptor(prefsService));

    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));

    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };
  }
  // دوال الـ CRUD الأساسية (بدون try-catch)
  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    return await _dio.get(path, queryParameters: queryParams);
  }

  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParams}) async {
    return await _dio.post(path, data: data, queryParameters: queryParams);
  }

  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParams}) async {
    return await _dio.put(path, data: data, queryParameters: queryParams);
  }

  Future<Response> delete(String path, {dynamic data, Map<String, dynamic>? queryParams}) async {
    return await _dio.delete(path, data: data, queryParameters: queryParams);
  }
}