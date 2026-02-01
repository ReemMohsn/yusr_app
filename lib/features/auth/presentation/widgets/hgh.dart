import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';

class CustomLable extends StatelessWidget {
  const CustomLable({super.key, required this.context, required this.text});

  final BuildContext context;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 2.w,
          height: 30.h,
          decoration: BoxDecoration(
            color: AppColor.golden,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 4.w),
        Text(text, style: context.theme.textTheme.bodyLarge),
      ],
    );
  }
}
