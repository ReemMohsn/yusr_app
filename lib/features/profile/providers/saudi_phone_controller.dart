import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/services/API/ApiResponse.dart';
import 'package:yusr/features/profile/providers/profile_repository_provider.dart';

part 'saudi_phone_controller.g.dart';

@riverpod
class SaudiPhoneController extends _$SaudiPhoneController {
  @override
  FutureOr<ApiResponse<dynamic>?> build() {
    return null; // الحالة المبدئية فارغة
  }

  Future<void> updateSaudiPhone(String number) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard<ApiResponse<dynamic>?>(() async {
      return await ref
          .read(profileRepositoryProvider)
          .updateProfileRaw('+966$number');
    });
  }
}
