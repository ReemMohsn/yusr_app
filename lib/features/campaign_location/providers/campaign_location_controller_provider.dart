import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/services/API/ApiResponse.dart';
import '../data/models/campaign_location_model.dart';
import 'campaign_location_repository_provider.dart';
import 'get_locations_provider.dart'; // تأكدي أن هذا هو اسم الملف الذي يحتوي على دالة جلب البيانات

part 'campaign_location_controller_provider.g.dart';
  @riverpod
  class CampaignLocationController extends _$CampaignLocationController {
    @override
    FutureOr<ApiResponse<CampaignLocationsViewModel>?> build() {
      return null; // الحالة المبدئية فارغة مثل LoginController
    }

    Future<void> fetchLocations() async {
      state = const AsyncValue.loading();

      state = await AsyncValue.guard<ApiResponse<CampaignLocationsViewModel>?>(() async {
        return await ref.read(campaignLocationRepositoryProvider).getLocations();
      });
    }

  Future<bool> removeLocation(int id) async {
    // لا نغير حالة الكنترولر نفسه إلى loading إذا كان ذلك سيؤثر على الشاشة كاملة بشكل مزعج
    // بل نكتفي بتنفيذ العملية
    final result = await AsyncValue.guard(() async {
      return await ref.read(campaignLocationRepositoryProvider).deleteLocation(id);
    });

    if (!result.hasError) {
      // هذه الخطوة هي الأهم: تجبر المزود المسؤول عن القائمة على إعادة جلب البيانات
      ref.invalidate(getCampaignLocationsProvider);
      
      // انتظر قليلاً لضمان أن الـ Provider بدأ التحميل الجديد
      await ref.read(getCampaignLocationsProvider.future); 
      
      return true;
    } else {
      state = AsyncError(result.error!, result.stackTrace!);
      return false;
    }
  }
          //   // دالة تفعيل الموقع كـ "موقع حالي"
      Future<void> makeLocationActive(int id) async {
        state = const AsyncValue.loading();
        state = await AsyncValue.guard(() async {
          await ref.read(campaignLocationRepositoryProvider).setActiveLocation(id);
          ref.invalidate(getCampaignLocationsProvider);
        });
      }
    }
  