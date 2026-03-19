import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/features/instructions/data/models/hajj_details_models.dart';

class ActionItemRow extends StatelessWidget {
  final HajjActionModel action;
  final int number;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;

  const ActionItemRow({
    super.key,
    required this.action,
    required this.number,
    this.isFirst = false,
    this.isLast = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const double cardHeight = 84.0;
    const double bottomSpacing = 24.0;
    const double circleSize = 44.0;

    return SizedBox(
      height: cardHeight.h + bottomSpacing.h,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: GestureDetector(
          onTap: onTap,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Golden numbered circle & Timeline
              SizedBox(
                width: circleSize.w,
                height: cardHeight.h + bottomSpacing.h,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    if (!isFirst)
                      Positioned(
                        top: 0,
                        bottom: (cardHeight.h + bottomSpacing.h) / 2,
                        child: Container(
                          width: 2.w,
                          color: AppColor.golden,
                        ),
                      ),
                    if (!isLast)
                      Positioned(
                        top: (cardHeight.h + bottomSpacing.h) / 2,
                        bottom: -bottomSpacing.h,
                        child: Container(
                          width: 2.w,
                          color: AppColor.golden,
                        ),
                      ),
                      
                    Positioned(
                      top: (cardHeight.h - circleSize.w) / 2,
                      child: Container(
                        width: circleSize.w,
                        height: circleSize.w,
                        decoration: BoxDecoration(
                          color: AppColor.withe,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColor.golden,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            number.toString(),
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: AppColor.golden,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: AppSize.paddingOfPage.w),

              // White action card
              Expanded(
                child: Container(
                  height: cardHeight.h,
                  decoration: BoxDecoration(
                    color: AppColor.withe,
                    borderRadius: BorderRadius.circular(AppSize.borderRadiusCard.r),
                    border: Border.all(
                      color: AppColor.inputFieldBoundaries,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.darkBlack.withValues(alpha: 0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                  child: Row(
                    children: [
                      Container(
                        width: 52.w,
                        height: 52.h,
                        decoration: BoxDecoration(
                          color: AppColor.backgroundColor,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Center(
                          child: Text(
                            action.emoji,
                            style: TextStyle(
                              fontSize: 26.sp,
                              fontFamily: 'Apple Color Emoji',
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 14.w),

                      Expanded(
                        child: Text(
                          action.name,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                            color: AppColor.baseFontColor,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
