import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/auto_counter/providers/auto_counter_controller.dart';

class CircularCounterWidget extends ConsumerWidget {
  const CircularCounterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale;

    // 1. مراقبة حالة العداد بالكامل (للحصول على isRunning و currentLap)
    final counterState = ref.watch(autoCounterControllerProvider);

    // 2. مراقبة الزاوية التراكمية فقط لتحديث "تقدم الشريط" بسلاسة
    final angle = ref.watch(
      autoCounterControllerProvider.select((s) => s.accumulatedAngle),
    );
    // إذا كان العداد يعمل، نقسم الزاوية على 360، وإلا تكون صفر
    double progressValue = counterState.isRunning ? (angle / 360) : 0.0;

    // لضمان أن القيمة لا تتخطى 1.0 ولا تقل عن 0.0 برمجياً
    progressValue = progressValue.clamp(0.0, 1.0);

    return Stack(
      alignment: Alignment.center,
      children: [
        // شريط التقدم الدائري 
        SizedBox(
          width: 250.w,
          height: 250.w,
          child: CircularProgressIndicator(
            value: progressValue,
            strokeWidth: 12.w,
            backgroundColor: AppColor.inputFieldBoundaries.withOpacity(0.4),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColor.golden),
            strokeCap: StrokeCap.round, 
          ),
        ),

        // النصوص المركزية
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              counterState.isRunning
                  ? "${counterState.currentLap}" // عرض رقم الشوط الحالي
                  : locale.start,
              style: TextStyle(
                fontSize: 60.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.baseFontColor,
              ),
            ),
            Text(
              counterState.isRunning 
                  ? locale.currentStroke 
                  : locale.clickToStart,
              style: TextStyle(
                color: AppColor.lightFontColor, 
                fontSize: 14.sp
              ),
            ),
            SizedBox(height: 5.h),
            
            // نص تدل على أن التحديث تلقائي بالحساسات
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