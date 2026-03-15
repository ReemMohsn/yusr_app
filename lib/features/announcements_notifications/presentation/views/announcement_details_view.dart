import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/common/widgets/custom_golden_back_button.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/announcements_notifications/data/models/announcement_model.dart';

class AnnouncementDetailsView extends StatelessWidget {
  // نستقبل الموديل كامل هنا
  final AnnouncementModel announcement;

  const AnnouncementDetailsView({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('التفاصيل'),
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: const UnconstrainedBox(child: CustomGoldenBackButton()),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(AppSize.paddingOfPage),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColor.withe,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppColor.golden,
                offset: const Offset(
                  3,
                  0,
                ), // نفس تأثير الظل الذهبي الرائع الخاص بك
                blurRadius: 0,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                offset: const Offset(0, 1),
                blurRadius: 3,
                spreadRadius: 0,
              ),
            ],
          ),
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. العنوان
              Text(
                announcement.title,
                style: context.theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColor.baseFontColor,
                ),
              ),

              SizedBox(height: 16.h),

              // 2. التاريخ (محاذاة لليسار كما في الصورة)
              Row(
                // mainAxisAlignment: MainAxisAlignment.start, // لجعله في اليسار
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey.shade400,
                    size: 18.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    announcement.sentAtDate,
                    style: context.theme.textTheme.bodySmall,
                  ),
                ],
              ),

              SizedBox(height: 24.h),
              Divider(
                color: AppColor.backgroundColor,
                thickness: 1,
                height: 1.h,
              ),
              SizedBox(height: 24.h),

              // 3. عنوان المحتوى
              Text(
                'محتوى الإعلان',
                style: context.theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 12.h),

              // 4. الحاوية الداخلية للمحتوى (ذات الخط الذهبي)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50, // لون رمادي فاتح جداً للخلفية
                  borderRadius: BorderRadius.circular(16.r),

                  // الخط الذهبي على اليمين (نستخدم Directional ليدعم اللغة العربية تلقائياً)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // النص الفعلي للإعلان
                    Text(
                      announcement.body,
                      style: context.theme.textTheme.bodySmall,
                    ),

                    SizedBox(height: 30.h),

                    // 5. التاج (يمين) والتوقيت (يسار)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // التاج (جميع الحجاج)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.golden,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Text(
                            announcement.targetAudienceName,
                            style: TextStyle(
                              color: AppColor.withe,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // التوقيت
                        Row(
                          children: [
                            Text(
                              announcement.sentAtTime,
                              textDirection: TextDirection.ltr,
                              style: context.theme.textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey.shade600),
                            ),
                            SizedBox(width: 6.w),
                            Icon(
                              Icons.access_time,
                              color: Colors.grey.shade400,
                              size: 18.sp,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
