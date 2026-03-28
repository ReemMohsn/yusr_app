import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/auto_counter/presentation/widgets/circular_counter_widget.dart';
import 'package:yusr/features/auto_counter/presentation/widgets/counter_details_card.dart';
import 'package:yusr/features/auto_counter/presentation/widgets/success_greeting_card_widget.dart';
import 'package:yusr/features/auto_counter/presentation/widgets/tawaf_saei_toggle.dart';
import 'package:yusr/features/auto_counter/providers/auto_counter_controller.dart';
import 'package:yusr/features/auto_counter/presentation/widgets/success_bottom_sheet_widget.dart'; 
class TawafCounterView extends ConsumerWidget {
  const TawafCounterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale;
    final counterState = ref.watch(autoCounterControllerProvider);
    ref.listen(autoCounterControllerProvider.select((s) => s.isCompleted), (previous, next) {
      if (next == true) {
        SuccessBottomSheet.show(context, locale.tawaf_saei_success_msg);
      }
    });
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
              SizedBox(height: 20.h),
              const CircularCounterWidget(),

              // بطاقة التفاصيل
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: const CounterDetailsCard(),
              ),

              // بطاقة التهنئة 
              if (counterState.isCompleted) 
                const SuccessGreetingCard(),
                
              // النص السفلي
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
