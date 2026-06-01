import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/onboarding/data/models/onboarding_model.dart';

class OnboardingContent extends StatelessWidget {
  final OnboardingModel model;

  const OnboardingContent({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(25.r),
            decoration: const BoxDecoration(
              color: AppColor.black,
              shape: BoxShape.circle,
            ),
            child: Icon(
              model.icon,
              size: 70.r, // حجم متناسق داخل الدائرة
              color: AppColor.golden, // الأيقونة بلون ذهبي يُسْر
            ),
          ),
          SizedBox(height: 40.h),
          Text(
            model.titleBuilder(locale),
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.baseFontColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15.h),
          Text(
            model.descriptionBuilder(locale),
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColor.midlineColor,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
