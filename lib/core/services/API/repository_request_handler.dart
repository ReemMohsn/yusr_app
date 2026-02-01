import 'package:dio/dio.dart';
import 'package:yusr/core/services/errors/errormodel.dart';
import 'package:yusr/core/services/errors/exception.dart';

Future<T> repositoryRequestHandler<T>(
  Future<Response> Function() request, {
  T Function(dynamic data)? fromJson,
}) async {
  try {
    final response = await request();
    final data = response.data;

    if (data is Map<String, dynamic>) {
      // 1. تحقق من نجاح العملية حسب منطق الباك إند لديك
      final isSuccess = data['isSuccess'] == true;

      if (isSuccess) {
        if (fromJson != null) {
          return fromJson(data['data']);
        }
        return data['data'] as T;
      } else {
        // 2. إذا رد السيرفر 200 ولكن isSuccess=false (خطأ منطقي)
        // نقوم برمي استثناء بنفس صيغة ErrorModel
        throw ServerException(
            errModel: ErrorModel.fromJson(data)
        );
      }
    }

    if (fromJson != null) return fromJson(data);
    return data as T;

  } on DioException catch (e) {
    // 3. هنا نستدعي دالتك القوية لمعالجة أخطاء الشبكة
    handleDioExceptions(e);
    throw e; // لن يصل الكود هنا لأن الدالة أعلاه ترمي استثناء، لكن للأمان
  } catch (e) {
    rethrow;
  }
}