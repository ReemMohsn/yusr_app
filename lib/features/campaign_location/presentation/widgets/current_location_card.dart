import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/campaign_location/data/models/campaign_location_item_model.dart';

class CurrentLocationCard extends StatelessWidget {
  final CampaignLocationItemModel location;

  const CurrentLocationCard({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    final theme = Theme.of(context).textTheme; // الوصول لثيم النصوص الموحد
    final LatLng locationPos = LatLng(location.latitude, location.longitude);

    return Column(
      mainAxisSize: MainAxisSize.min, // ليأخذ الطول تلقائياً من المحتوى
      children: [
        // 1. كارد الخريطة (تم ضبطه ليكون عرضه إنفنتي)
        Container(
          height: 250.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColor.withe,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppColor.golden, width: 1.2.w),
            boxShadow: [
              BoxShadow(
                color: AppColor.darkBlack.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(19.r),
            child: FlutterMap(
              key: ValueKey('${location.latitude}_${location.longitude}'),
              options: MapOptions(initialCenter: locationPos, initialZoom: 15),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.yusr.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: locationPos,
                      width: 40.w,
                      height: 40.h,
                      child: Icon(
                        Icons.location_on,
                        color: AppColor.golden,
                        size: 35.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 12.h),

        // 2. كارد البيانات
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColor.withe, // استخدام AppColor بدلاً من Colors
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: AppColor.darkBlack.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: AppColor.golden.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: AppColor.golden,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          location.locationName,
                          // استخدام headlineSmall من الثيم للعنوان
                          style: theme.headlineSmall,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          (location.description != null &&
                                  location.description!.isNotEmpty)
                              ? location.description!
                              : locale.currentLocation,
                          // استخدام bodySmall من الثيم للوصف
                          style: theme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // صف الأزرار
              Row(
                children: [
                  // زر "تغيير"
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.golden,
                        foregroundColor: AppColor.darkBlack,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                      ),
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoute.setLocationView,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.sync_alt_rounded, size: 18.sp),
                          SizedBox(width: 8.w),
                          Text(
                            locale.changeLocation,
                            style: theme.bodyMedium?.copyWith(
                              color: AppColor.darkBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 10.w),

                  // زر "تعديل"
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                            AppColor.darkBlack, // استخدام darkBlack الموحد
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                      ),
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoute.editLocationView,
                        arguments: location,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit_note_rounded,
                            color: AppColor.golden,
                            size: 20.sp,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            locale.edit,
                            style: theme.bodyMedium?.copyWith(
                              color: AppColor.golden,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
