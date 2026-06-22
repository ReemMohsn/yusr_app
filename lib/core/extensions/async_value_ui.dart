import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/services/errors/exception.dart';

extension AsyncValueUI on AsyncValue {
  String get errorMessage {
    // 1. يفحص هل يوجد خطأ
    if (!hasError || error == null) return "";

    // 2. يفحص النوع
    if (error is ServerException) {
      return (error as ServerException).errModel.errorMessage;
    }
    // 3. يرجع النص الافتراضي
    return error.toString();
  }
}
