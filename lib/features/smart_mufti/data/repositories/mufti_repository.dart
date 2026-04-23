import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/services/API/api_service.dart';
import 'package:yusr/core/services/API/repository_request_handler.dart';
import 'package:yusr/core/services/API/ApiResponse.dart';
import '../models/mufti_response_model.dart'; // تأكدي من المسار

// class MuftiRepository {
//   final ApiService apiService;
//   final Ref ref;

//   MuftiRepository(this.apiService, this.ref);

//   Future<ApiResponse<MuftiResponseModel>> askMufti(String question) async {
//     const String muftiUrl = 'https://manar13-yusr-hajj-api.hf.space/ask';
//     return await repositoryRequestHandler<MuftiResponseModel>(
//       () => apiService.get(muftiUrl, queryParams: {'question': question}),
//       fromJson: (data) => MuftiResponseModel.fromJson(data),
//     );
//   }
// }
class MuftiRepository {
  final ApiService apiService;
  final Ref ref;

  MuftiRepository(this.apiService, this.ref);

  Future<ApiResponse<MuftiResponseModel>> askMufti(String question) async {
    const String muftiUrl = 'https://manar13-yusr-hajj-api.hf.space/ask';
    
    try {
      final response = await apiService.get(muftiUrl, queryParams: {'question': question});
      final data = response.data;

      // إذا أرسل السيرفر حقل "detail" (خطأ من uvicorn/fastapi)
      if (data is Map<String, dynamic> && data.containsKey('detail')) {
        return ApiResponse<MuftiResponseModel>(
          message: "success", // نجعله success لكي لا يرمي Exception
          data: MuftiResponseModel(
            answer: data['detail'].toString(), // نضع رسالة الخطأ في مكان الإجابة
            confidence: "0%",
           
          ),
        );
      }

      // إذا كان الرد سليم بالهيكلية المعتادة
      return ApiResponse<MuftiResponseModel>(
        message: "success",
        data: MuftiResponseModel.fromJson(data['data'] ?? data),
      );
      
    } catch (e) {
      // في حالة انقطاع الإنترنت أو خطأ كلي في السيرفر
      return ApiResponse<MuftiResponseModel>(
        message: "error",
        data: MuftiResponseModel(
          answer: "عذراً، واجهت مشكلة في الاتصال بالمفتي. يرجى المحاولة لاحقاً.",
          confidence: "0%",
         
        ),
      );
    }
  }
}