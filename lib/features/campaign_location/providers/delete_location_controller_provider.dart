import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/services/API/ApiResponse.dart';
import 'package:yusr/features/campaign_location/data/models/campaign_locations_view_model.dart';
import 'campaign_location_repository_provider.dart';
import 'get_locations_provider.dart';

part 'delete_location_controller_provider.g.dart';

@riverpod
class DeleteLocationController extends _$DeleteLocationController {
  @override
  FutureOr<ApiResponse<CampaignLocationsViewModel>?> build() {
    return null; // الحالة المبدئية فارغة ليتطابق مع الـ State المطلوب
  }

  Future<void> removeLocation(int id) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard<ApiResponse<CampaignLocationsViewModel>?>(() async {
      // 1. استدعاء الحذف وتخزينه في متغير ديناميكي
      final dynamic result = await ref.read(campaignLocationRepositoryProvider).deleteLocation(id);
      
      // 2. تحديث قائمة المواقع فوراً في الخلفية لكي تنعكس بالواجهة الرئيسية
      ref.invalidate(getCampaignLocationsProvider);

      // 3. التحويل الآمن: معاملة النتيجة كـ ApiResponse للوصول للحقول العامة
      final response = result as ApiResponse;

      // 4. إعادة التغليف بالنوع المطلوب للـ State (تثبيت الـ النوع ليتوافق مع الـ listen في الواجهة)
      return ApiResponse<CampaignLocationsViewModel>(
        message: response.message,
        data: null,
      );
    });
  }
}