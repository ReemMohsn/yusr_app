import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';

class InputCardWidget extends StatelessWidget {
  final String title;
  final Widget child;
  final IconData? icon;

  const InputCardWidget({
    super.key,
    required this.title,
    required this.child,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.withe, // تأكد من اسم المتغير في AppColor
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.golden,
            offset: const Offset(3, 0),
            blurRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 1),
            blurRadius: 3,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.withe,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey.shade100, width: 1.w),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // التعديل هنا: إذا كان هناك أيقونة يعرضها، وإلا يعرض المستطيل الذهبي
                if (icon != null)
                  Icon(icon, color: AppColor.golden, size: 18.sp)
                else
                  Container(
                    width: 3.5.w,
                    height: 18.h,
                    decoration: BoxDecoration(
                      color: AppColor.golden,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                SizedBox(width: 10.w),
                // نص العنوان
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1, // صف واحد فقط
                    overflow: TextOverflow.ellipsis, // إظهار النقاط عند الزيادة
                    style: context.theme.textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Divider(color: AppColor.backgroundColor, thickness: 1, height: 1.h),
            SizedBox(height: 16.h),
            child, // محتوى الكرت (مثل TextField أو Dropdown)
          ],
        ),
      ),
    );
  }
}
