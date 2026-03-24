import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/auto_counter/presentation/widgets/counter_info_item.dart';

class CounterDetailsCard extends StatelessWidget {
  const CounterDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    int current = 0;
    int totalStrokes = 7;

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
                value: "${totalStrokes - current} ${locale.strokes}",
                color: AppColor.golden,
                align: CrossAxisAlignment.end,
              ),
              CounterInfoItem(
                label: locale.total,
                value: "$current ${locale.ofWord} $totalStrokes",
                color: AppColor.baseFontColor,
                align: CrossAxisAlignment.start,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: current / totalStrokes,
              minHeight: 7.h,
              backgroundColor: AppColor.inputFieldBoundaries,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColor.golden),
            ),
          ),
          SizedBox(height: 20.h),
          ElevatedButton.icon(
            onPressed: () {
              // منطق إعادة التعيين هنا
            },
            icon: Icon(Icons.refresh, color: AppColor.lightFontColor, size: 18.w),
            label: Text(
              locale.reset, 
              style: TextStyle(
                color: AppColor.lightFontColor,
                fontSize: 14.sp,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.inputFieldColor,
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