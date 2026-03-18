import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/campaign_location/data/models/campaign_location_model.dart';

class CurrentLocationCard extends StatelessWidget {
  final CampaignLocationItemModel location;

  const CurrentLocationCard({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    // الإحداثيات تأتي الآن من الكائن القادم من الـ API
    final LatLng locationPos = LatLng(location.latitude, location.longitude);

    return Column(
      children: [
        // 1. كارد الخريطة المستقل (بنفس التصميم تماماً)
        Container(
          height: 250.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppColor.golden, width: 1.2.w),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(19.r),
              child: FlutterMap(
                // أضيفي هذا السطر (الـ Key) لإجبار الخريطة على التحديث فور تغير الإحداثيات
                key: ValueKey('${location.latitude}_${location.longitude}'), 
                options: MapOptions(
                  initialCenter: locationPos,
                  initialZoom: 15,
                ),
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
                          size: 35.sp
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ),
        ),
        
        SizedBox(height: 12.h),

        // 2. كارد البيانات المستقل
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start, 
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: AppColor.golden.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.location_on, color: AppColor.golden, size: 24.sp),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, 
                      children: [
                        Text(
                          location.locationName, // مربوط باسم الموقع من الـ API
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColor.darkBlack,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                        ),
                        SizedBox(height: 7.h),
                        Text(
                          location.locationName, // يمكنك استبداله بحقل الوصف إذا توفر في الموديل
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF4A5565),
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 16.h),

              // زر التعديل الأسود (في جهة اليسار)
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                onTap: () => Navigator.pushNamed(
                  context, 
                  AppRoute.setLocationView, // تم التغيير لفتح قائمة اختيار المواقع
                  arguments: location,
                ),
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF100F0B),
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit_note_rounded, color: AppColor.golden, size: 20.sp),
                        SizedBox(width: 6.w),
                        Text(
                          locale.edit,
                          style: TextStyle(
                            color: AppColor.golden,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
