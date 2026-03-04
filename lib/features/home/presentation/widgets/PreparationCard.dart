import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_image.dart';
import 'package:yusr/core/extensions/context_extension.dart';

class PreparationCard extends StatelessWidget {
  const PreparationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    return SizedBox(
      height: 280.h,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            top: 0.h, // يبتعد عن الأعلى بـ 12
            // bottom: 210.h, // يبتعد عن أسفل الصورة بـ 12
            bottom: 100.h, // يبتعد عن أسفل الصورة بـ 12
            left: 0.w, // يبتعد عن اليسار بـ 12
            right: 0.w, // يبتعد عن اليمين بـ 12
            child: Container(
              // height: 400.h,
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
            // top: 160.h, // يبتعد عن الأعلى بـ 12
            top: 150.h, // يبتعد عن الأعلى بـ 12
            // bottom: 90.h, // يبتعد عن أسفل الصورة بـ 12
            bottom: 0.h, // يبتعد عن أسفل الصورة بـ 12

            left: 0.w, // يبتعد عن اليسار بـ 12
            right: 0.w, // يبتعد عن اليمين بـ 12
            child: Container(
              height: 5.h,
              padding: EdgeInsets.symmetric(horizontal: 18.w),
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
                          locale.ritualsPreparation,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColor.darkBlack,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          locale.ritualsPreparationDesc,

                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColor.midlineColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // SizedBox(width: 5.w),

                  // زر السهم الذهبي
                  Container(
                    width: 39.w,
                    height: 39.w,
                    decoration: const BoxDecoration(
                      color: AppColor.golden,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white,
                        size: 18.sp,
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
