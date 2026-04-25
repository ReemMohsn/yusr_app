import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/auto_counter/presentation/widgets/custom_info_display.dart';
import '../../providers/auto_counter_controller.dart';

class CounterDetailsCard extends ConsumerWidget {
  const CounterDetailsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale;
    final state = ref.watch(autoCounterControllerProvider);
    final notifier = ref.read(autoCounterControllerProvider.notifier);

    return Card(
      elevation: 0,
      color: AppColor.inputFieldColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(color: AppColor.inputFieldBoundaries),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomInfoDisplay(
                  label: locale.steps,
                  value: "${state.stepsInCurrentLap}",
                ),
                Container(width: 1, height: 30, color: AppColor.iconColors),
                CustomInfoDisplay(
                  label: locale.status,
                  value: state.isMoving ? locale.walking : locale.stopped,
                ),
              ],
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (state.isRunning) {
                    notifier.reset();
                  } else {
                    notifier.startTracking();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: state.isRunning
                      ? AppColor.lightdanger
                      : AppColor.golden,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                ),
                icon: Icon(
                  state.isRunning ? Icons.refresh : Icons.play_arrow,
                  color: state.isRunning ? AppColor.danger : AppColor.withe,
                  size: 22.sp,
                ),
                label: Text(
                  state.isRunning ? locale.reset : locale.start,
                  style: TextStyle(
                    color: state.isRunning ? AppColor.danger : AppColor.withe,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}