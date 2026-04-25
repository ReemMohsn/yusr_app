import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';

class CustomInfoDisplay extends StatelessWidget {
  final String label;
  final String value;

  const CustomInfoDisplay({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColor.lightFontColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp, 
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}