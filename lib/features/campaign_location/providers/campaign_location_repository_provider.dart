// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:yusr/core/common/providers/api_service_provider.dart';
// import '../data/repositories/campaign_location_repository.dart';

// final campaignLocationRepositoryProvider = Provider<CampaignLocationRepository>((ref) {
//   final apiService = ref.read(apiServiceProvider);
//   return CampaignLocationRepository(apiService, ref);
// });
import 'package:flutter_riverpod/flutter_riverpod.dart'; // إضافة هذا السطر ضرورية لتعريف Ref
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/common/providers/api_service_provider.dart';
import '../data/repositories/campaign_location_repository.dart';

// تأكد أن اسم الملف الفعلي هو campaign_location_repository_provider.dart
part 'campaign_location_repository_provider.g.dart'; 

@riverpod
CampaignLocationRepository campaignLocationRepository(Ref ref) {
  // استخدام watch بدلاً من read يضمن تحديث الـ Repository إذا تغير الـ API Service
  final apiService = ref.watch(apiServiceProvider);
  return CampaignLocationRepository(apiService, ref);
}