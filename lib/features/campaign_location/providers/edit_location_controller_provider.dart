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
    required double lat,
    required double lng,
  }) async {
    state = const AsyncValue.loading();
    
    // استخدام try-catch يدوي أحياناً أفضل لتحديد مكان الخطأ في الـ Mapping
    try {
      final response = await ref.read(campaignLocationRepositoryProvider).updateLocation(
        id: id,
        name: name,
        lat: lat,
        lng: lng,
      );
      
      ref.invalidate(getCampaignLocationsProvider);
      state = AsyncValue.data(response);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
