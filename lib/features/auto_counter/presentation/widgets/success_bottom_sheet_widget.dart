import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';

class SuccessBottomSheet extends StatelessWidget {
  final String message; 

  const SuccessBottomSheet({super.key, required this.message});

  static Future<void> show(BuildContext context, String message) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SuccessBottomSheet(message: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    
    return Container(
      padding: EdgeInsets.all(30.w),
      decoration: BoxDecoration(
        color: AppColor.withe,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            color: AppColor.golden,
            size: 70.w,
          ),
          SizedBox(height: 15.h),
          Text(
            message,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.baseFontColor,
            ),
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.golden,
              minimumSize: Size(double.infinity, 50.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
            ),
            child: Text(
              locale.done,
              style: const TextStyle(
                color: AppColor.withe,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // إضافة مسافة بسيطة للأسفل لضمان التناسق في شاشات الآيفون
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}