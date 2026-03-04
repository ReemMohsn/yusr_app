import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';

class PrayerItem extends StatelessWidget {
  const PrayerItem({
    super.key,
    required this.name,
    required this.time,
    required this.icon,
  });

  final String name;
  final String time;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: AppColor.backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColor.golden, size: 18.sp),
        ),
        SizedBox(height: 12.h),
        Text(
          name,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColor.lightFontColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          time,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: AppColor.darkBlack,
          ),
        ),
      ],
    );
  }
}
