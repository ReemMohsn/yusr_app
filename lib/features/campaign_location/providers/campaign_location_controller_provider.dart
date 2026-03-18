import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/services/API/ApiResponse.dart';
import '../data/models/campaign_location_model.dart';
import 'campaign_location_repository_provider.dart';
import 'get_locations_provider.dart'; // تأكدي أن هذا هو اسم الملف الذي يحتوي على دالة جلب البيانات

part 'campaign_location_controller_provider.g.dart';
// @riverpod
// class CampaignLocationController extends _$CampaignLocationController {
//   @override
//   FutureOr<void> build() {} // تبسيط الـ build

//   // دالة الحذف
//   // Future<void> removeLocation(int id) async {
//   //   state = const AsyncValue.loading();
//   //   state = await AsyncValue.guard(() async {
//   //     await ref.read(campaignLocationRepositoryProvider).deleteLocation(id);
//   //     // تحديث البروفايدر المسؤول عن جلب البيانات فوراً
//   //     ref.invalidate(getCampaignLocationsProvider); 
//   //   });
//   // }

//   // دالة تفعيل الموقع كـ "موقع حالي"
//   Future<void> makeLocationActive(int id) async {
//     state = const AsyncValue.loading();
//     state = await AsyncValue.guard(() async {
//       await ref.read(campaignLocationRepositoryProvider).setActiveLocation(id);
//       ref.invalidate(getCampaignLocationsProvider);
//     });
//   }
// }
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
// في ملف CampaignLocationController
    Future<bool> removeLocation(int id) async {
      // 1. نجعل الحالة "تحميل"
      state = const AsyncValue.loading();
      
      // 2. ننفذ عملية الحذف ونخزن النتيجة في متغير محلي
      final result = await AsyncValue.guard(() async {
        return await ref.read(campaignLocationRepositoryProvider).deleteLocation(id);
      });

      // 3. التحقق من النتيجة
      if (!result.hasError) {
        // نجاح: نقوم بتحديث المزود المسؤول عن القائمة
        ref.invalidate(getCampaignLocationsProvider);
        
        // نعيد حالة الكنترولر إلى null أو بيانات فارغة بنجاح
        state = const AsyncValue.data(null); 
        return true;
      } else {
        // فشل: هنا المشكلة، لا يمكننا قول state = result بسبب اختلاف الأنواع
        // الحل: نقوم بإنشاء AsyncError متوافق مع النوع المطلوب
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
  