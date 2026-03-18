import 'dart:async'; // إضافة ضرورية لتعريف FutureOr بشكل صريح
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/services/API/ApiResponse.dart';
import 'campaign_location_repository_provider.dart';
import 'get_locations_provider.dart';

// تأكدي أن اسم الملف في جهازك هو: set_active_location_controller.dart
part 'set_active_location_controller.g.dart'; 

@riverpod
class SetActiveLocationController extends _$SetActiveLocationController {
  @override
  FutureOr<ApiResponse<dynamic>?> build() {
    return null; // الحالة الابتدائية
  }

  Future<void> changeActiveLocation(int locationId) async {
    state = const AsyncValue.loading();
    
    // استخدام AsyncValue.guard لالتقاط النجاح أو الفشل تلقائياً
    state = await AsyncValue.guard(() async {
      final response = await ref.read(campaignLocationRepositoryProvider).setActiveLocation(locationId);
      
      // أهم خطوة: عمل invalidate لتحديث الخريطة والقائمة فوراً بالموقع النشط الجديد
      ref.invalidate(getCampaignLocationsProvider);
      
      return response;
    });
  }
}