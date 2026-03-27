import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';

class BigcircularButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;

  const BigcircularButton({
    super.key,
    required this.onTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 250.w,
        height: 250.w,
        decoration: BoxDecoration(
          // استخدام اللون الأسود من الثيم (darkBlack)
          color: theme.appBarTheme.backgroundColor,
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
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineLarge?.copyWith(
              // نستخدم اللون الذهبي ليكون متبايناً مع الخلفية السوداء
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
