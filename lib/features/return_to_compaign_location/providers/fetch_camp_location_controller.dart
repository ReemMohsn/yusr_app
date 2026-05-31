import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/services/API/ApiResponse.dart';
import '../data/models/active_location_model.dart';
import 'return_to_campaign_repository_provider.dart';

part 'fetch_camp_location_controller.g.dart';

@riverpod
class FetchCampLocationController extends _$FetchCampLocationController {
  // build يرجع null لا يجلب شيئاً تلقائياً
  @override
  FutureOr<ApiResponse<ActiveLocationModel>?> build() => null;

  // يُستدعى فقط عند ضغط الزر
  Future<void> fetchLocation() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(returnToCampaignRepositoryProvider);
      return await repository.getCampLocation();
    });
  }
}
