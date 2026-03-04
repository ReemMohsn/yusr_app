import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/home/presentation/widgets/info_box.dart';

class HajjStatusCard extends StatelessWidget {
  const HajjStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    final HijriCalendar today = HijriCalendar.now();
    final String currentHijriDate = today.toFormat("d MMMM");

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColor.darkBlack,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.golden,
            blurRadius: 0,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            locale.journeyOfFaith,
            style: TextStyle(
              color: AppColor.golden,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            locale.labbayk,
            style: TextStyle(
              color: Colors.white,
              fontSize: 30.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 25.h),
          InfoBox(title: locale.hijriDate, value: currentHijriDate),
        ],
      ),
    );
  }
}
