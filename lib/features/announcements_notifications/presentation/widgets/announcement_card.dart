import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';

class AnnouncementCard extends StatelessWidget {
  final String date;
  final String title;
  final String description;
  final String time;
  final String tag;

  const AnnouncementCard({
    super.key,
    required this.date,
    required this.title,
    required this.description,
    required this.time,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: AppColor.withe,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.golden,
            offset: const Offset(3, 0), // إزاحة خفيفة للأسفل واليمين
            blurRadius: 0, // بدون ضبابية ليكون صلباً
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 1),
            blurRadius: 3,
            spreadRadius: 0,
          ),
        ],
      ),
      // حاوية داخلية لتنظيم المحتوى
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.withe,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey.shade100, width: 1.w),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. قسم التاريخ (أعلى اليمين)
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: AppColor.golden,
                  size: 16.sp,
                ),
                SizedBox(width: 8.w),
                Text(date, style: context.theme.textTheme.bodySmall),
              ],
            ),

            SizedBox(height: 12.h),

            // 2. الخط الخفيف الفاصل
            Divider(color: AppColor.backgroundColor, thickness: 1, height: 1.h),

            SizedBox(height: 16.h),

            // 3. العنوان وبجانبه الخط العمودي
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // الخط العمودي الذهبي
                Container(
                  width: 3.5.w,
                  height: 18.h,
                  decoration: BoxDecoration(
                    color: AppColor.golden,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(width: 10.w),
                // نص العنوان
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1, // صف واحد فقط
                    overflow: TextOverflow.ellipsis, // إظهار النقاط عند الزيادة
                    style: context.theme.textTheme.headlineSmall,
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.h),

            // 4. الوصف (المحتوى)
            Text(
              description,
              maxLines: 2, // صفين كحد أقصى
              overflow: TextOverflow.ellipsis, // إظهار النقاط عند الزيادة
              style: context.theme.textTheme.bodySmall,
            ),
            SizedBox(height: 20.h),

            // 5. التاج (يمين) والتوقيت (يسار)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                    tag,
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
                    Icon(Icons.access_time, color: AppColor.golden, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      time,
                      textDirection:
                          TextDirection.ltr, // للحفاظ على شكل الوقت (14:30)
                      style: context.theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
