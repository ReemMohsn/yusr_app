import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';

class TawafSaeiToggle extends StatefulWidget {
  const TawafSaeiToggle({super.key});

  @override
  State<TawafSaeiToggle> createState() => _TawafSaeiToggleState();
}

class _TawafSaeiToggleState extends State<TawafSaeiToggle> {
  bool isTawaf = true;

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    return Container(
      height: 50.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColor.lightBlack,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15), 
          borderRadius: BorderRadius.circular(28.r),
        ),
        child: Row(
          children: [
            Expanded(child: _buildTab(locale.saei, !isTawaf, false)),
            Expanded(child: _buildTab(locale.tawaf, isTawaf, true)),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, bool isSelected, bool isTawafTab) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isTawaf = isTawafTab;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? AppColor.golden : Colors.transparent,
          borderRadius: BorderRadius.circular(25.r),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppColor.darkBlack : AppColor.withe,
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
}