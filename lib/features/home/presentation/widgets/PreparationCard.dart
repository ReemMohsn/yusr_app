import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_image.dart';

// تأكد من استيراد ملفات الألوان والصور الخاصة بمشروعك هنا
// import 'package:yusr/core/utils/app_colors.dart';
// import 'package:yusr/core/utils/app_images.dart';

class PreparationCard extends StatelessWidget {
  const PreparationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400.h,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            top: 0.h, // يبتعد عن الأعلى بـ 12
            bottom: 170.h, // يبتعد عن أسفل الصورة بـ 12
            left: 0.w, // يبتعد عن اليسار بـ 12
            right: 0.w, // يبتعد عن اليمين بـ 12
            child: Container(
              height: 280.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                image: const DecorationImage(
                  image: AssetImage(AppImage.kabba),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // 2. الكرت الأبيض العائم
          Positioned(
            top: 200.h, // يبتعد عن الأعلى بـ 12
            bottom: 0.h, // يبتعد عن أسفل الصورة بـ 12
            left: 0.w, // يبتعد عن اليسار بـ 12
            right: 0.w, // يبتعد عن اليمين بـ 12
            child: Container(
              height: 150.h,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                color: AppColor.withe,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "تهيئة المناسك خطوة بخطوة",
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColor.darkBlack,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          "ابدأ رحلتك إلى الوجهات، وتعلم خطوات الحج والعمرة الصحيحة بتفاصيل مذهبة.",

                          style: TextStyle(
                            fontSize: 8.sp,
                            color: AppColor.midlineColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 8.w),

                  // زر السهم الذهبي
                  Container(
                    width: 25.w,
                    height: 25.w,
                    decoration: const BoxDecoration(
                      color: AppColor.golden,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white,
                        size: 15.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
