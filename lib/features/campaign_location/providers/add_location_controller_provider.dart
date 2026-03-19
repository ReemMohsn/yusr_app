import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/services/API/ApiResponse.dart';
import 'campaign_location_repository_provider.dart';
import 'get_locations_provider.dart';

part 'add_location_controller_provider.g.dart';

@riverpod
class AddLocationController extends _$AddLocationController {
  @override
  FutureOr<ApiResponse<dynamic>?> build() => null;

  Future<void> addNewLocation({
    required String name,
    required String description, // أضفنا الوصف هنا
    required double lat,
    required double lng,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final response = await ref.read(campaignLocationRepositoryProvider).addLocation(
        name: name,
        description: description, // تمرير الوصف للمستودع
        lat: lat,
        lng: lng,
      );
      // تحديث قائمة المواقع تلقائياً بعد الإضافة الناجحة
      ref.invalidate(getCampaignLocationsProvider);
      return response;
    });
  }
}