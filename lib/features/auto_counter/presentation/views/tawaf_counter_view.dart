import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/auto_counter/presentation/widgets/circular_counter_widget.dart';
import 'package:yusr/features/auto_counter/presentation/widgets/counter_details_card.dart';
import 'package:yusr/features/auto_counter/presentation/widgets/success_greeting_card_widget.dart';
import 'package:yusr/features/auto_counter/presentation/widgets/tawaf_saei_toggle.dart';
import 'package:yusr/features/auto_counter/presentation/widgets/success_bottom_sheet_widget.dart';

import 'package:yusr/features/auto_counter/providers/auto_counter_controller.dart';

class TawafCounterView extends ConsumerWidget {
  const TawafCounterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale;

    final counterState = ref.watch(autoCounterControllerProvider);

    // الاستماع لتغير الأشواط لتنفيذ الاهتزاز
    ref.listen<int>(autoCounterControllerProvider.select((s) => s.currentLap), (
      previous,
      next,
    ) {
      final isRunning = ref.read(autoCounterControllerProvider).isRunning;

      if (isRunning && previous != null && next > previous && next <= 7) {
        HapticFeedback.heavyImpact();
      }
    });

    // الاستماع لحالة الانتهاء
    ref.listen<bool>(
      autoCounterControllerProvider.select((s) => s.isCompleted),
      (previous, next) {
        if (next == true) {
          SuccessBottomSheet.show(context, locale.tawaf_saei_success_msg);
        }
      },
    );

    return Scaffold(
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // جزء التبديل (طواف / سعي)
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(30.w, 30.h, 30.w, 20.h),
                child: const TawafSaeiToggle(),
              ),

              // العداد الدائري
              const CircularCounterWidget(),

              // عرض رسالة خطأ الحساس إن وُجدت
              if (counterState.permissionError != null)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 25.w,
                    vertical: 10.h,
                  ),
                  child: Text(
                    counterState.permissionError!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColor.danger,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              // بطاقة التفاصيل
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: const CounterDetailsCard(),
              ),

              // بطاقة التهنئة عند الانتهاء
              if (counterState.isCompleted) const SuccessGreetingCard(),

              // النص التوضيحي السفلي
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 25.h),
                child: Text(
                  locale.tawafDescription,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColor.lightFontColor,
                    fontSize: 11.sp,
                    height: 1.5,
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
