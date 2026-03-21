  import 'package:riverpod_annotation/riverpod_annotation.dart';
  import 'package:yusr/core/services/API/ApiResponse.dart';
  import '../data/models/active_location_model.dart';
  import 'return_to_campaign_repository_provider.dart';

  part 'fetch_camp_location_controller.g.dart';

  @riverpod
  class FetchCampLocationController extends _$FetchCampLocationController {

    @override
    FutureOr<ApiResponse<ActiveLocationModel>> build() async {
      return await _fetchLocationData();
    }

    Future<void> refreshLocation() async {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        return await _fetchLocationData();
      });
    }
    Future<ApiResponse<ActiveLocationModel>> _fetchLocationData() async {
      final repository = ref.watch(returnToCampaignRepositoryProvider);
      final result = await repository.getCampLocation();
      return result; 
    }
  }