import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';

class CustomBigButton extends StatelessWidget {
  const CustomBigButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColor.darkBlack,
    this.textColor = AppColor.golden,
  });

  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor; // متغير لون الخلفية
  final Color textColor; // متغير لون النص

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor, // استخدام اللون الممرر للخلفية
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        elevation: 0,
        padding: const EdgeInsets.all(25),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor, // استخدام اللون الممرر للنص
          fontSize: 10.sp, // حجم الخط (يمكنك تعديله حسب الحاجة)
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
