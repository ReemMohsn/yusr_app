import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';

class CustomGoldenBackButton extends StatelessWidget {
  const CustomGoldenBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Navigator.canPop(context)) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: () => Navigator.maybePop(context),
      customBorder: const CircleBorder(),
      child: Ink(
        width: 39.w,
        height: 39.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent, // تأكيد إزالة لون الخلفية
          border: Border.all(
            color: AppColor.golden, // لون الحدود الذهبي
            width: 1, // يمكنك تعديل سمك الحد حسب رغبتك
          ),
        ),
        child: Center(
          child: Icon(Icons.chevron_left, color: AppColor.golden, size: 25.sp),
        ),
      ),
    );
  }
}
