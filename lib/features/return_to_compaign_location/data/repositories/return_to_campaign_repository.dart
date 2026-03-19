import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:yusr/core/constants/api_link.dart';
import 'package:yusr/core/services/API/api_service.dart';
import 'package:yusr/core/services/API/repository_request_handler.dart';
import 'package:yusr/core/services/API/ApiResponse.dart';
import '../models/active_location_model.dart';

class ReturnToCampaignRepository {
  final ApiService apiService;
  final Ref ref;
  final Dio _dio = Dio();
  final String _orsApiKey = 'eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6ImExNzU1NTJjOTM5ZDQwMzliNDg4MTAyMWMwNjljYjJmIiwiaCI6Im11cm11cjY0In0=';

  ReturnToCampaignRepository(this.apiService, this.ref);

  // جلب إحداثيات الحملة من السيرفر
  Future<ApiResponse<ActiveLocationModel>> getCampLocation() async {
    return await repositoryRequestHandler<ActiveLocationModel>(
      () => apiService.get(ApiLink.getActiveLocation),
      fromJson: (data) => ActiveLocationModel.fromJson(data),
    );
  }

  // جلب نقاط المسار من OpenRouteService
  Future<Map<String, dynamic>?> getRoute({required LatLng start, required LatLng target}) async {
    const url = 'https://api.openrouteservice.org/v2/directions/driving-car';
    try {
      final response = await _dio.get(url, queryParameters: {
        'api_key': _orsApiKey,
        'start': '${start.longitude},${start.latitude}',
        'end': '${target.longitude},${target.latitude}',
      });
      return response.statusCode == 200 ? response.data : null;
    } catch (e) {
      return null;
    }
  }
}