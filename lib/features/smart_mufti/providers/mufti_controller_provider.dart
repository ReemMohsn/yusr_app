import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/services/API/ApiResponse.dart';
import 'package:yusr/features/smart_mufti/data/models/mufti_response_model.dart';
import 'package:yusr/features/smart_mufti/providers/mufti_repository_provider.dart';

part 'mufti_controller_provider.g.dart';

// استخدام الـ typedef يساعد المولد في فهم النوع المعقد
typedef MuftiState = ApiResponse<MuftiResponseModel>?;

@riverpod
class MuftiController extends _$MuftiController {
  @override
  FutureOr<MuftiState> build() => null;

  Future<void> sendQuestion(String question) async {
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard<MuftiState>(() async {
      final repository = ref.read(muftiRepositoryProvider);
      return await repository.askMufti(question);
    });
  }
}