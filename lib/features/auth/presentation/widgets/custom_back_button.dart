import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Navigator.canPop(context)) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: () => Navigator.maybePop(context),
      customBorder: const CircleBorder(),
      child: Ink(
        width: 30.w,
        height: 30.w,
        decoration: BoxDecoration(
          color: AppColor.withe,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              offset: const Offset(0, 1),
              blurRadius: 3,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              offset: const Offset(0, 1),
              blurRadius: 2,
              spreadRadius: -1,
            ),
          ],
        ),
        child: Center(
          child: Icon(Icons.chevron_left, color: AppColor.golden, size: 20.sp),
        ),
      ),
    );
  }
}
