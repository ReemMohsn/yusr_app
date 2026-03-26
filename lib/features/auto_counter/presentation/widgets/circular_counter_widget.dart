import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';

class CircularCounterWidget extends StatelessWidget {
  final bool isStarted;
  final int currentStroke;

  const CircularCounterWidget({
    super.key,
    this.isStarted = false,
    this.currentStroke = 0,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 250.w,
          height: 250.w,
          child: CircularProgressIndicator(
            value: isStarted ? (currentStroke / 7) : 0,
            strokeWidth: 12.w,
            backgroundColor: AppColor.inputFieldBoundaries.withOpacity(0.4),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColor.golden),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isStarted ? "$currentStroke" : locale.start,
              style: TextStyle(
                fontSize: 60.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.baseFontColor,
              ),
            ),
            Text(
              isStarted ? locale.currentStroke : locale.clickToStart,
              style: TextStyle(color: AppColor.lightFontColor, fontSize: 14.sp),
            ),
            SizedBox(height: 5.h),
            Text(
              locale.autoUpdate,
              style: TextStyle(
                color: AppColor.golden,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
