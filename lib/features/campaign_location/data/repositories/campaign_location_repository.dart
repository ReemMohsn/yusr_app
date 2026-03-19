import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/constants/api_link.dart';
import 'package:yusr/core/services/API/ApiResponse.dart';
import 'package:yusr/core/services/API/api_service.dart';
import 'package:yusr/core/services/API/repository_request_handler.dart';
import 'package:yusr/features/campaign_location/data/models/campaign_locations_view_model.dart';
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
  
// في كلاس CampaignLocationRepository

// 1. تحديث إضافة موقع
Future<ApiResponse<dynamic>> addLocation({
  required String name,
  required String description, // إضافة الوصف
  required double lat,
  required double lng,
}) async {
  return await repositoryRequestHandler<dynamic>(
    () => apiService.post(
      ApiLink.addCampaignLocation,
      data: {
        "Name": name,
        "Description": description, // إرسال الوصف (تأكدي من حالة الأحرف حسب الـ Swagger)
        "Latitude": lat,
        "Longitude": lng,
      },
    ),
  );
}

// 2. تحديث تعديل موقع
Future<ApiResponse<dynamic>> updateLocation({
  required int id,
  required String name,
  required String description, // إضافة الوصف
  required double lat,
  required double lng,
}) async {
  return await repositoryRequestHandler<dynamic>(
    () => apiService.put(
      "${ApiLink.updateLocationData}/$id", 
      data: {
        "locationId": id,
        "newName": name,
        "newDescription": description, // إرسال الوصف الجديد
        "newLatitude": lat,
        "newLongitude": lng,
      },
    ),
    fromJson: (data) => data, 
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
    // تأكدي من استخدام النوع PATCH هنا كما يظهر في Swagger
    () => apiService.patch( 
      ApiLink.setActiveLocation, 
      data: {
        "locationId": locationId,
      },
    ),
  );
}

}