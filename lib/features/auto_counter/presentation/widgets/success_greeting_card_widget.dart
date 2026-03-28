import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';

class SuccessGreetingCard extends StatelessWidget {
  const SuccessGreetingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 15.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppColor.lightGolden,
              AppColor.darkGolden,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.9],
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppColor.darkGolden.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              locale.congratulations,
              style: TextStyle(
                color: AppColor.withe,
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
                shadows: [
                  Shadow(
                    color: AppColor.darkBlack.withOpacity(0.1),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  )
                ],
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              locale.all_rounds_completed,
              style: TextStyle(
                color: AppColor.withe.withOpacity(0.95),
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}