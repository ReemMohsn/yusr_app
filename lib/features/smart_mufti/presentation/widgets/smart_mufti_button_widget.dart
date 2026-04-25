import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';

class SmartMuftiButtonWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isLoading;
  const SmartMuftiButtonWidget({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // عرض كامل حسب التعليمات
      height: 56.h, // طول ثابت للزر لضمان تناسق الضغط
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.lightBlack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 0,
        ),
        // تعطيل الزر برمجياً أثناء التحميل لضمان عدم تكرار الطلب
        onPressed: isLoading ? null : onPressed, 
        child: isLoading
            ? SizedBox(
                height: 24.h,
                width: 24.h,
                child: const CircularProgressIndicator(
                  color: AppColor.golden,
                  strokeWidth: 2,
                ),
              )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Icon(
            icon,
            color: AppColor.golden,
            size: 20.sp,
          ),
            SizedBox(width: 8.w),
            Text(
              text,
              // استخدام تنسيق من الـ Theme (BodyMedium) مع تعديل اللون للذهبي
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColor.golden,
                  ),
            ),
            
          ],
        ),
      ),
    );
  }
}