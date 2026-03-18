// // import 'package:riverpod_annotation/riverpod_annotation.dart';
// // // تأكدي من صحة هذا المسار لملف الـ Repository Provider
// // import 'campaign_location_repository_provider.dart';
// // import '../data/models/campaign_location_model.dart';

// // // تأكدي أن اسم هذا الملف في المجلد هو get_locations_provider.dart
// // part 'get_locations_provider.g.dart';

// // @riverpod
// // Future<CampaignLocationsViewModel?> getCampaignLocations(GetCampaignLocationsRef ref) async {
// //   // استخدام الـ Repository Provider الذي تم تعريفه يدوياً
// //   final repo = ref.watch(campaignLocationRepositoryProvider);
// //   final response = await repo.getLocations();
// //   return response.data;
// // }

// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'campaign_location_repository_provider.dart';
// // استيراد الموديل ضروري حتى لو استخدمنا dynamic
// import '../data/models/campaign_location_model.dart'; 

// part 'get_locations_provider.g.dart';

// @riverpod
// // هنا التغيير: اجعلي نوع الإرجاع Future<dynamic> بدلاً من الموديل المعقد
// Future<CampaignLocationsViewModel?> getCampaignLocations(GetCampaignLocationsRef ref) async  {
//   final repo = ref.watch(campaignLocationRepositoryProvider);
  
//   final response = await repo.getLocations();
  
//   // البيانات ستعود كـ CampaignLocationsViewModel وسيفهمها التطبيق تلقائياً
//   return response.data;
// }
import 'package:flutter_riverpod/flutter_riverpod.dart'; // تأكدي من هذا الاستيراد
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'campaign_location_repository_provider.dart';
import '../data/models/campaign_location_model.dart'; 

part 'get_locations_provider.g.dart';

@riverpod
// التغيير هنا: استخدمنا Ref بدلاً من الاسم الطويل
Future<CampaignLocationsViewModel?> getCampaignLocations(Ref ref) async {
  final repo = ref.watch(campaignLocationRepositoryProvider);
  
  final response = await repo.getLocations();
  
  return response.data;
}
