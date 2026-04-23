import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';

class MuftiHeaderSection extends StatelessWidget {
  final String title;
  final String subtitle;

  const MuftiHeaderSection({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    
     return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.headlineSmall?.copyWith(
              fontSize: 20.sp,
              color: AppColor.baseFontColor,
            ),
          ),
          SizedBox(height: 4.h),
          Text(subtitle, style: theme.bodySmall),
        ],
      );

  }
}