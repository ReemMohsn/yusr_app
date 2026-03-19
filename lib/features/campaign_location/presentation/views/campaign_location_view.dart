import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/common/widgets/custom_golden_back_button.dart';
import 'package:yusr/core/common/widgets/widget.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/campaign_location/providers/campaign_location_controller_provider.dart';
import 'package:yusr/features/campaign_location/providers/get_locations_provider.dart';
import '../widgets/current_location_card.dart';
import '../widgets/other_location_item.dart';

class CampaignLocationView extends ConsumerWidget {
  const CampaignLocationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale;
    final locationsAsync = ref.watch(getCampaignLocationsProvider);
    ref.listen(campaignLocationControllerProvider, (previous, next) {
    next.whenOrNull(
      error: (error, stack) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(locale.unexpectedError), // تأكدي من وجود الترجمة
            backgroundColor: AppColor.danger,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  });
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0), // نفس لون الخلفية في الصور
      appBar: AppBar(
        title: Text(
          locale.campaignLocation,
          style: TextStyle(color: AppColor.golden, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A1A1A), // AppBar غامق كما في التصميم
        leading: const UnconstrainedBox(child: CustomGoldenBackButton()),
      ),
      body: locationsAsync.when(
        data: (data) {
          if (data == null) return Center(child: Text(locale.notFound));

      return RefreshIndicator(
        onRefresh: () async => ref.refresh(getCampaignLocationsProvider.future),
        color: AppColor.golden,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          // الـ padding هنا هو الذي يحدد المسافة عن حافة الجوال (20 من اليمين و20 من اليسار)
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          child: Column(
            // جعل كل محتويات العمود تبدأ من اليمين لتكون بمحاذاة حافة الخريطة
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              // 1. زر إضافة موقع جديد (محاذى لليسار تماماً)
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.golden,
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    onPressed: () => Navigator.pushNamed(context, AppRoute.addLocationView),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add, color: Colors.white),
                        SizedBox(width: 8.w),
                        Text(
                          locale.addLocation,
                          style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 20.h), // مسافة إضافية قبل "الموقع الحالي"
              // 2. عنوان الموقع الحالي (بمحاذاة الخريطة تماماً)
              Padding(
                        padding: EdgeInsets.only(right: 10.w), // إضافة مسافة بسيطة لضبط المحاذاة مع الكرت
                        child: _buildSectionHeader(locale.currentLocation),
                      ),
              SizedBox(height: 16.h),
              if (data.currentLocation != null)
                CurrentLocationCard(location: data.currentLocation!)
              else
                _buildEmptyCard(locale.notFound),

              SizedBox(height: 30.h), // مسافة إضافية قبل "مواقع استقرار أخرى"

              // 3. عنوان مواقع استقرار أخرى (بمحاذاة الكروت تماماً)
              Padding(
                        padding: EdgeInsets.only(right: 10.w), // إضافة مسافة بسيطة لضبط المحاذاة مع الكروت
                        child: _buildSectionHeader(locale.otherLocations),
                      ),
                SizedBox(height: 16.h), 
              if (data.previousLocations.isEmpty)
                _buildEmptyCard(locale.notFound)
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.previousLocations.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    return OtherLocationItem(
                      // هذا السطر هو السر في جعل العنصر يختفي فوراً من الشاشة
                      key: ValueKey(data.previousLocations[index].locationId), 
                      location: data.previousLocations[index],
                    );
                  },
                ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      );
        },
        error: (error, stack) => _buildErrorState(context, ref, locale),
        loading: () => const Center(child: CircularProgressIndicator(color: AppColor.golden)),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      textAlign: TextAlign.right,
      style: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF1E2939),
      ),
    );
  }

  Widget _buildEmptyCard(String message) {
    return Center(child: Text(message, style: const TextStyle(color: Colors.grey)));
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, dynamic locale) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(locale.fetchDataError),
          TextButton(
            onPressed: () => ref.invalidate(getCampaignLocationsProvider),
            child: Text(locale.retry),
          ),
        ],
      ),
    );
  }
}
