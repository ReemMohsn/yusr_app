import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/constants/api_link.dart';
import 'package:yusr/core/services/API/ApiResponse.dart';
import 'package:yusr/core/services/API/api_service.dart';
import 'package:yusr/core/services/API/repository_request_handler.dart';
import '../models/campaign_location_model.dart';

class CampaignLocationRepository {
  final ApiService apiService;
  final Ref ref;

  CampaignLocationRepository(this.apiService, this.ref);

  Future<ApiResponse<CampaignLocationsViewModel>> getLocations() async {
    return await repositoryRequestHandler<CampaignLocationsViewModel>(
      () => apiService.get(ApiLink.getCampaignLocations),
      fromJson: (data) => CampaignLocationsViewModel.fromJson(data),
    );
  }
  

  Future<ApiResponse<dynamic>> updateLocation({
    required int id,
    required String name,
    required double lat,
    required double lng,
  }) async {
    return await repositoryRequestHandler<dynamic>(
      () => apiService.put(
        ApiLink.updateLocationData, 
        data: {
          "locationId": id,
          "newName": name,
          "newLatitude": lat,
          "newLongitude": lng,
        },
      ),
      // أضيفي هذا السطر لتجنب محاولة تحويل النص إلى Map
      fromJson: (data) => data, 
    );
  }

  // في ملف الـ Repository الخاص بك
  Future<ApiResponse<dynamic>> addLocation({
    required String name,
    required double lat,
    required double lng,
  }) async {
    return await repositoryRequestHandler<dynamic>(
      () => apiService.post(
        ApiLink.addCampaignLocation,
        data: {
          "Name": name,      // اجعلي الحرف الأول كبيراً N
          "Latitude": lat,   // اجعلي الحرف الأول كبيراً L
          "Longitude": lng,  // اجعلي الحرف الأول كبيراً L
        },
      ),
    );
  }

// دالة الحذف
Future<ApiResponse<dynamic>> deleteLocation(int id) async {
  return await repositoryRequestHandler<dynamic>(
    // التأكد من أن المسار ينتهي بـ / ثم الرقم مباشرة
    () => apiService.delete("${ApiLink.deleteLocation}/$id"), 
  );
}
  Future<ApiResponse<dynamic>> setActiveLocation(int locationId) async {
      return await repositoryRequestHandler<dynamic>(
        // استخدمنا post بدلاً من patch لأنها غير معرفة في الـ ApiService عندك
        () => apiService.post(
          ApiLink.setActiveLocation, 
          data: {
            "locationId": locationId,
          },
        ),
      );
    }
}

