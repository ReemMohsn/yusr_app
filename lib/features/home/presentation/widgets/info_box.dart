import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';

class InfoBox extends StatelessWidget {
  const InfoBox({super.key, required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.baseFontColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColor.goldenWithOpacity),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(color: AppColor.lightFontColor, fontSize: 8.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              color: AppColor.golden,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
