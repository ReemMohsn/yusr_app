import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/features/home/presentation/widgets/info_box.dart';

class HajjStatusCard extends StatelessWidget {
  const HajjStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final HijriCalendar _today = HijriCalendar.now();
    final String currentHijriDate = _today.toFormat("d MMMM");

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.darkBlack,
        borderRadius: BorderRadius.circular(40.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.golden,
            blurRadius: 0,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "رِحْلَةُ الإِيمَانِ",
            style: TextStyle(
              color: AppColor.golden,
              fontSize: 8.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            "لبيك اللهم لبيك",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 25.h),
          InfoBox(title: "التاريخ الهجري", value: currentHijriDate),
        ],
      ),
    );
  }
}
