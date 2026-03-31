import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/auto_counter/presentation/widgets/counter_info_item.dart';
import 'package:yusr/features/auto_counter/providers/auto_counter_controller.dart';

class CounterDetailsCard extends ConsumerWidget {
  const CounterDetailsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale;
    final counterState = ref.watch(autoCounterControllerProvider);
    final notifier = ref.read(autoCounterControllerProvider.notifier);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColor.withe,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CounterInfoItem(
                label: locale.remaining,
                value: "${counterState.remainingLaps} ${locale.strokes}",
                color: AppColor.golden,
                align: CrossAxisAlignment.end,
              ),
              CounterInfoItem(
                label: locale.total,
                value: "${counterState.currentLap} ${locale.ofWord} ${counterState.totalLaps}",
                color: AppColor.baseFontColor,
                align: CrossAxisAlignment.start,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: counterState.currentLap / counterState.totalLaps,
              minHeight: 7.h,
              backgroundColor: AppColor.inputFieldBoundaries,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColor.golden),
            ),
          ),
          SizedBox(height: 20.h),

          // الزر (بدء / إعادة تعيين)
          ElevatedButton.icon(
            onPressed: () {
              if (counterState.isRunning) {
                notifier.reset(); // إذا كان يعمل، يقوم بإعادة التعيين
              } else {
                notifier.startTracking(); // إذا كان متوقفاً، يبدأ العمل
              }
            },
            icon: Icon(
              counterState.isRunning ? Icons.refresh : Icons.play_arrow,
              color: counterState.isRunning ? AppColor.lightFontColor : AppColor.withe,
              size: 18.w,
            ),
            label: Text(
              counterState.isRunning ? locale.reset : locale.start,
              style: TextStyle(
                color: counterState.isRunning ? AppColor.lightFontColor : AppColor.withe, 
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: counterState.isRunning 
                  ? AppColor.inputFieldColor 
                  : AppColor.golden,
              elevation: 0,
              minimumSize: Size(double.infinity, 50.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}