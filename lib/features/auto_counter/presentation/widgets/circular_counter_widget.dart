import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/auto_counter/providers/auto_counter_controller.dart';
import 'package:yusr/features/auto_counter/providers/state/auto_counter_state.dart';

class CircularCounterWidget extends ConsumerWidget {
  const CircularCounterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale;
    final state = ref.watch(autoCounterControllerProvider);
    double lapProgress = 0.0;
    if (state.trackingType == TrackingType.tawaf) {
      lapProgress = state.accumulatedAngle / 360;
    } else {
      lapProgress = state.stepsInCurrentLap / 350;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        // الدائرة الخلفية الكبيرة
        Container(
          width: 300.w,
          height: 300.w,
          decoration: const BoxDecoration(shape: BoxShape.circle),
        ),

        //  إطار الدائرة الرمادي  
        Container(
          width: 250.w,
          height: 250.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColor.inputFieldBoundaries.withOpacity(0.4), // اللون الرمادي الفاتح للإطار
              width: 12.w,
            ),
          ),
        ),

        // مؤشر التقدم 
        if (state.isRunning)
          SizedBox(
            width: 250.w,
            height: 250.w,
            child: CircularProgressIndicator(
              value: lapProgress.clamp(0.0, 1.0),
              strokeWidth: 12.w,
              color: AppColor.golden, // اللون الذهبي للتقدم
              // backgroundColor: Colors.transparent,
              strokeCap: StrokeCap.round,
            ),
          ),

        // النصوص المركزية
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!state.isRunning || state.currentLap == 0) ...[
              Text(
                locale.start,
                style: TextStyle(
                  fontSize: 60.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColor.baseFontColor,
                  height: 1.1,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                locale.clickToStart,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColor.iconColors,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                locale.autoUpdate,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColor.golden,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ] else ...[
              Text(
                locale.currentStroke,
                style: TextStyle(
                  fontSize: 18.sp,
                  color: AppColor.iconColors,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${state.currentLap}",
                style: TextStyle(
                  fontSize: 80.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColor.baseFontColor,
                  height: 1.1,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
