import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/services/API/ApiResponse.dart';
import 'campaign_location_repository_provider.dart';
import 'get_locations_provider.dart';

part 'edit_location_controller_provider.g.dart';

@riverpod
class EditLocationController extends _$EditLocationController {
  @override
  FutureOr<ApiResponse<dynamic>?> build() => null;

  Future<void> updateExistingLocation({
    required int id,
    required String name,
    required String description,
    required double lat,
    required double lng,
  }) async {
    // 1. تعيين الحالة إلى loading
    state = const AsyncValue.loading();

    // 2. استخدام guard للتعامل مع الاستجابة أو الخطأ تلقائياً
    state = await AsyncValue.guard<ApiResponse<dynamic>?>(() async {
      final response = await ref.read(campaignLocationRepositoryProvider).updateLocation(
        id: id,
        name: name,
        description: description,
        lat: lat,
        lng: lng,
      );

      // 3. تحديث البيانات في الواجهة الرئيسية فور النجاح
      ref.invalidate(getCampaignLocationsProvider);
      
      return response;
    });
  }
}
