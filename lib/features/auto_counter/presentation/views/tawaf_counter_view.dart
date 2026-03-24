import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/auto_counter/presentation/widgets/circular_counter_widget.dart';
import 'package:yusr/features/auto_counter/presentation/widgets/counter_details_card.dart';
import 'package:yusr/features/auto_counter/presentation/widgets/tawaf_saei_toggle.dart';

class TawafCounterView extends StatelessWidget {
  const TawafCounterView({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                  30.w,
                  30.h,
                  30.w,
                  20.h,
                ), 
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.r),
                    bottomRight: Radius.circular(30.r),
                  ),
                ),
                child: const TawafSaeiToggle(),
              ),

              // العداد الدائري 
              SizedBox(height: 20.h),
              const CircularCounterWidget(isStarted: false),

              // بطاقة التفاصيل 
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: const CounterDetailsCard(),
              ),

              // النص السفلي 
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 15.h),
                child: Text(
                  locale.tawafDescription,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColor.lightFontColor,
                    fontSize: 10.sp, 
                    height: 1.3,
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
