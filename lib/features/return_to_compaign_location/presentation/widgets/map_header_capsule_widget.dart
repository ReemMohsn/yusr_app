import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart'; 

class MapHeaderCapsule extends StatelessWidget {
  const MapHeaderCapsule({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: AppColor.golden.withOpacity(0.3), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12, 
            blurRadius: 10,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on, color: AppColor.golden, size: 20.sp),
          SizedBox(width: 8.w),
          Text(
            locale.campaignLocation, 
            style: theme.textTheme.headlineSmall?.copyWith(
              fontSize: 16.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}