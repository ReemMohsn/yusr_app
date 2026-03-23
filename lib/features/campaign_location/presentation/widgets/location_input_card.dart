import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';

class LocationInputCard extends StatelessWidget {
  final String title;
  final Widget child;
  final double? height;

  const LocationInputCard({
    super.key,
    required this.title,
    required this.child,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    // الوصول لثيم النصوص الموحد في المشروع
    final theme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      height: height, // يبقى اختيارياً للحالات الخاصة مثل الخريطة
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        // الحفاظ على التصميم الذهبي الجانبي المميز للهوية
        border: const Border(
          right: BorderSide(color: AppColor.golden, width: 4.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // ليأخذ حجم المحتوى فقط ولا يتمدد بدون داعٍ
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // رأس الكرت (العنوان)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColor.golden.withOpacity(0.05), Colors.transparent],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 4.w,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: AppColor.golden,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  title,
                  // 🌟 التعديل هنا: استخدام headlineSmall من التيم الموحد
                  style: theme.headlineSmall?.copyWith(
                    color: const Color(
                      0xFF6A7282,
                    ), // الحفاظ على اللون المطلوب مع حجم الخط من الثيم
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF5F5F0)),

          // 🌟 التعديل هنا: التعامل مع الارتفاع بذكاء
          // إذا كان هناك طول محدد (للخريطة مثلاً) نستخدم Expanded، وإلا نترك المحتوى يأخذ حجمه الطبيعي
          if (height != null)
            Expanded(child: child)
          else
            Padding(padding: EdgeInsets.zero, child: child),
        ],
      ),
    );
  }
}
