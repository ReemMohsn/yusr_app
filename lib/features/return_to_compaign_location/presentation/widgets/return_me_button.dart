import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';

class ReturnMeButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;

  const ReturnMeButton({super.key, required this.onTap, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250.w,
        height: 250.w,
        decoration: BoxDecoration(
          color: AppColor.darkBlack,
          shape: BoxShape.circle,
          border: Border.all(color: AppColor.golden, width: 4.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              offset: const Offset(0, 8),
              blurRadius: 15,
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: AppColor.golden,
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
