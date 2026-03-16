import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/constants/api_link.dart';
import 'package:yusr/core/services/API/api_service.dart';
import 'package:yusr/core/services/API/repository_request_handler.dart';
import 'package:yusr/core/services/API/ApiResponse.dart';
import '../models/active_location_model.dart';

class LocationRepository {
  final ApiService apiService;
  final Ref ref;

  LocationRepository(this.apiService, this.ref);

  Future<ApiResponse<ActiveLocationModel>> getCampLocation() async {
    return await repositoryRequestHandler<ActiveLocationModel>(
      () => apiService.get(ApiLink.getActiveLocation),
      fromJson: (data) => ActiveLocationModel.fromJson(data),
    );
  }
}
