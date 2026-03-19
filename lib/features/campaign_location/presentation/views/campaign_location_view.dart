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
import 'package:yusr/features/campaign_location/data/models/campaign_location_item_model.dart';
import 'package:yusr/features/campaign_location/data/models/campaign_locations_view_model.dart';

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
              content: Text(locale.unexpectedError),
              backgroundColor: AppColor.danger,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
       appBar: AppBar(
        elevation: 0,
        title: Text(locale.campaignLocation),
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: const UnconstrainedBox(child: CustomGoldenBackButton()),
        ),
      ),
      body: locationsAsync.when(
        data: (data) {
          if (data == null) return Center(child: Text(locale.notFound));

          return RefreshIndicator(
            onRefresh: () async => ref.refresh(getCampaignLocationsProvider.future),
            color: AppColor.golden,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.darkBlack.withOpacity(0.25), // استخدام darkBlack بدلاً من black المباشر
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
                            const Icon(Icons.add, color: AppColor.withe), // استبدال Colors.white
                            SizedBox(width: 8.w),
                            Text(
                              locale.addLocation,
                              style: TextStyle(color: AppColor.withe, fontSize: 18.sp, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 20.h), 
                  Padding(
                    padding: EdgeInsets.only(right: 10.w), 
                    child: _buildSectionHeader(locale.currentLocation),
                  ),
                  SizedBox(height: 16.h),
                  if (data.currentLocation != null)
                    CurrentLocationCard(location: data.currentLocation!)
                  else
                    _buildEmptyCard(locale.notFound),

                  SizedBox(height: 30.h), 

                  Padding(
                    padding: EdgeInsets.only(right: 10.w), 
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
        color: AppColor.baseFontColor, // تم استبدال اللون 1E2939 بـ baseFontColor لتوحيد الهوية
      ),
    );
  }

  Widget _buildEmptyCard(String message) {
    return Center(child: Text(message, style: TextStyle(color: AppColor.lightFontColor))); // استبدال grey بـ lightFontColor
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, dynamic locale) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(locale.fetchDataError),
          TextButton(
            onPressed: () => ref.invalidate(getCampaignLocationsProvider),
            child: Text(locale.retry, style: const TextStyle(color: AppColor.golden)), // إضافة لون النص
          ),
        ],
      ),
    );
  }
}