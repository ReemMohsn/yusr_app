import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/common/providers/shared_preferences_service_provider.dart';
import 'package:yusr/core/constants/api_link.dart';
import 'package:yusr/core/constants/shared_preferences_keys.dart';
import 'package:yusr/core/services/API/ApiResponse.dart';
import 'package:yusr/core/services/API/api_service.dart';
import 'package:yusr/core/services/API/repository_request_handler.dart';
import 'package:yusr/features/be_leader/data/models/pilgrim_model.dart';
import 'package:yusr/features/be_leader/data/models/session_response_model.dart';

class LeaderTrackingApiRepository {
  final ApiService apiService;
  final Ref ref;

  LeaderTrackingApiRepository(this.apiService, this.ref);

  // دالة لفتح الجلسة في الباك إند
  Future<ApiResponse<SessionResponseModel>> startSession() async {
    final sharedPrefs = ref.read(sharedPreferencesServiceProvider);

    // 2. نقوم بطلب الـ API
    final response = await repositoryRequestHandler<SessionResponseModel>(
      () => apiService.post(ApiLink.startTrackingSession),
      fromJson: (data) {
        return SessionResponseModel.fromJson(data);
      },
    );

    // 3. نحفظ البيانات باستخدام المتغير الذي جلبناه مسبقاً
    if (response.data != null) {
      await sharedPrefs.setInt(
        SharedPreferencesKeys.currentSessionId,
        response.data!.sessionId,
      );
    }

    return response;
  }

  // إضافة هذه الدالة داخل كلاس LeaderTrackingApiRepository

  Future<ApiResponse<List<PilgrimModel>>> getPilgrimsList(int sessionId) async {
    final response = await repositoryRequestHandler<List<PilgrimModel>>(
      () => apiService.get("${ApiLink.getPilgrims}/$sessionId"),
      fromJson: (data) {
        return (data as List)
            .map((item) => PilgrimModel.fromJson(item))
            .toList();
      },
    );
    return response;
  }

  // دالة الرد على دعوة الجلسة (موافقة أو رفض)
  Future<ApiResponse<dynamic>> respondToSession(
    int sessionId,
    int statusId,
  ) async {
    return await repositoryRequestHandler<dynamic>(
      () => apiService.post(
        ApiLink.participantResponse,
        data: {"sessionId": sessionId, "sessionParticipantStatusId": statusId},
      ),
    );
  }
}
