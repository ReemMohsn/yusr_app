import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/services/API/ApiResponse.dart';
import 'package:yusr/features/campaign_location/data/models/campaign_locations_view_model.dart';
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

    // Future<void> removeLocation(int id) async {
    //   // 1. تغيير الحالة إلى تحميل فوراً لكي يظهر الـ Loading Dialog في الواجهة
    //   state = const AsyncValue.loading();

    //   // 2. تنفيذ عملية الحذف مع حماية من الأخطاء
    //   final result = await AsyncValue.guard(() async {
    //     return await ref.read(campaignLocationRepositoryProvider).deleteLocation(id);
    //   });

    //   if (!result.hasError) {
    //     // 3. تحديث قائمة المواقع فوراً لكي تختفي من الشاشة
    //     ref.invalidate(getCampaignLocationsProvider);
        
    //     // الانتظار للتأكد من تحديث البيانات قبل إعطاء حالة النجاح
    //     await ref.read(getCampaignLocationsProvider.future); 

    //     // 4. تعيين النتيجة (النجاح) لكي يقوم الـ listen في الواجهة بإغلاق الدايلوج وإظهار رسالة النجاح
    //     state = AsyncValue.data(result.value);
    //   } else {
    //     // 5. في حال الخطأ، نمرر الخطأ للحالة لكي يظهره الـ listen للمستخدم
    //     state = AsyncError(result.error!, result.stackTrace!);
    //   }
    // }
Future<void> removeLocation(int id) async {
  state = const AsyncValue.loading();

  state = await AsyncValue.guard<ApiResponse<CampaignLocationsViewModel>?>(() async {
    // 1. استدعاء الحذف وتخزينه في متغير
    final dynamic result = await ref.read(campaignLocationRepositoryProvider).deleteLocation(id);
    
    // 2. تحديث القائمة
    ref.invalidate(getCampaignLocationsProvider);

    // 3. التحويل الآمن: أخبر Dart أن يعامل result كـ ApiResponse
    // سنستخدم 'as ApiResponse' بدون تحديد النوع الداخلي للوصول للحقول العامة
    final response = result as ApiResponse;

    // 4. إعادة التغليف بالنوع المطلوب للـ State
    return ApiResponse<CampaignLocationsViewModel>(
      message: response.message, // الآن سيتعرف على message
      // إذا كان الحقل عندك اسمه 'success' أو 'status' تأكدي من مسميات الكلاس لديكِ
      // status: response.status, 
      data: null,
    );
  });
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
  