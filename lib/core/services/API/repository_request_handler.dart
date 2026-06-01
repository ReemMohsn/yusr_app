import 'package:dio/dio.dart';
import 'package:yusr/core/services/API/ApiResponse.dart';
import 'package:yusr/core/services/errors/errormodel.dart';
import 'package:yusr/core/services/errors/exception.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/extensions/context_extension.dart';

Future<ApiResponse<T>> repositoryRequestHandler<T>(
  Future<Response> Function() request, {
  T Function(dynamic data)? fromJson,
}) async {
  try {
    final response = await request();
    final data = response.data;

    if (data is Map<String, dynamic>) {
      final isSuccess = data['isSuccess'] == true;

      if (isSuccess) {
        // 1. نسحب الرسالة
        final String message = data['message'] ?? navigatorKey.currentContext?.locale.operationSuccessful ?? 'تمت العملية بنجاح';

        // 2. نسحب الداتا ونحولها (إذا طلبنا ذلك)
        final T parsedData = fromJson != null
            ? fromJson(data['data'])
            : data['data'] as T;

        // 3. نعيد الاثنين معاً في الكلاس الجديد!
        return ApiResponse<T>(data: parsedData, message: message);
      } else {
        throw ServerException(errModel: ErrorModel.fromJson(data));
      }
    } else {
      // 🔥 التعديل هنا: التعامل مع حالة البيانات الغريبة التي ليست Map
      throw ServerException(
        errModel: ErrorModel(
          errorMessage: navigatorKey.currentContext?.locale.unsupportedDataFormat ?? 'صيغة البيانات القادمة من الخادم غير مدعومة',
          statusCode: 404,
          isSuccess: false,
        ),
      );
    }
  } on DioException catch (e) {
    // 3. هنا نستدعي دالتك القوية لمعالجة أخطاء الشبكة
    handleDioExceptions(e);
    rethrow; // لن يصل الكود هنا لأن الدالة أعلاه ترمي استثناء، لكن للأمان
  } catch (e) {
    rethrow;
  }
}
