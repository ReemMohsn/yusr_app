import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'dart:math' as math; // استيراد مكتبة الرياضيات للتعامل مع الراديان

class MapBottomActionBtn extends StatelessWidget {
  final String distance;
  final double bearing;

  const MapBottomActionBtn({
    super.key, 
    required this.distance,
    required this.bearing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65.h,
      decoration: BoxDecoration(
        color: AppColor.golden,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, -2),
          )
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // عرض المسافة المحدثة بالكيلومتر
          Text(
            "$distance كم", 
            style: TextStyle(
              color: Colors.white, 
              fontSize: 18.sp, 
              fontWeight: FontWeight.bold,
            ),
          ),
          
          // السهم الذي يدور مع اتجاه البوصلة

          Transform.rotate(
            angle: (bearing * (math.pi / 180)), // تحويل الدرجات لراديان بدقة
            child: Icon(
              Icons.navigation, 
              color: Colors.white,
              size: 28.sp,
            ),
          ),
        ],
      ),
    );
  }
}