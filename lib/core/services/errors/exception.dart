import 'package:dio/dio.dart';

import 'errormodel.dart';

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
        case 400:
        case 401:
        case 403:
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
