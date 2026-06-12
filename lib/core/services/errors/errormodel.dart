import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/extensions/context_extension.dart';

class ErrorModel {
  final num statusCode;
  final String errorMessage;
  final bool isSuccess;

  ErrorModel({
    required this.statusCode,
    required this.errorMessage,
    required this.isSuccess,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> jsonData) {
    return ErrorModel(
      statusCode: jsonData["statusCode"] ?? 0,
      isSuccess: jsonData["isSuccess"] ?? false,
      errorMessage: jsonData["message"] ?? navigatorKey.currentContext?.locale.unknownError ?? "حدث خطأ غير معروف",
    );
  }
}
