
// تأكدي من هذا الاستيراد
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/features/campaign_location/data/models/campaign_locations_view_model.dart';
import 'campaign_location_repository_provider.dart';

part 'get_locations_provider.g.dart';

@riverpod
// التغيير هنا: استخدمنا Ref بدلاً من الاسم الطويل
Future<CampaignLocationsViewModel?> getCampaignLocations(Ref ref) async {
  final repo = ref.watch(campaignLocationRepositoryProvider);
  
  final response = await repo.getLocations();
  
  return response.data;
}
