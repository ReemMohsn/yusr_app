import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/common/widgets/custom_text_field.dart';
import 'package:yusr/core/constants/app_color.dart';

class QuestionCard extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;

 const QuestionCard({
    super.key, 
    required this.label, 
    required this.hint, 
    required this.controller, // إضافة هذا السطر
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.withe,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColor.golden.withOpacity(0.5), width: 0.7),
        boxShadow: [
          BoxShadow(
            color: AppColor.baseFontColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.bodyMedium),
          SizedBox(height: 12.h),
          CustomTextField(
            controller: controller,
            hintText: hint,
            maxLines: 4,
          ),
        ],
      ),
    );
  }
}