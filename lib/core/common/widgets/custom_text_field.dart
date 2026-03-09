// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class SearchField extends StatelessWidget {
//   final String hintText;

//   const SearchField({
//     super.key,
//     required this.hintText, // 🌟 2. جعله مطلوباً عند استدعاء الويدجت
//   });
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 56.h, // ارتفاع مناسب بناءً على فجما
//       alignment: Alignment.center, // ضمان توسيط محتوى الحاوية
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.1),
//             offset: const Offset(0, 1),
//             blurRadius: 3,
//             spreadRadius: 0,
//           ),
//         ],
//       ),
//       child: Center(
//         child: TextField(
//           onTapOutside: (event) =>
//               FocusManager.instance.primaryFocus?.unfocus(),
//           textAlignVertical:
//               TextAlignVertical.center, // 🌟 الحل لتوسيط النص عمودياً
//           controller: null,
//           textInputAction: TextInputAction.next,
//           decoration: InputDecoration(
//             hintText: hintText,
//             fillColor: Colors.transparent,
//             prefixIcon: Icon(
//               Icons.search,
//               // color: AppColor.golden, // لون الأيقونة الذهبي
//               size: 24.sp,
//             ),
//             // إزالة الحدود الافتراضية لأننا نعتمد على حدود الـ Container
//             border: InputBorder.none,
//             enabledBorder: InputBorder.none,
//             focusedBorder: InputBorder.none,
//             // contentPadding: EdgeInsets.zero,
//             contentPadding: EdgeInsets.symmetric(vertical: 16.h),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';

class CustomTextField extends StatelessWidget {
  // 🌟 إجباري
  final String hintText;

  // 🌟 اختياري
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final IconData? prefixIcon; // نمرر فقط الأيقونة والويدجت تتكفل بالتنسيق
  final Widget? suffixIcon; // Widget لتمرير IconButton في حال كلمة المرور
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextInputAction textInputAction;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final int maxLines;
  final bool readOnly;
  final void Function()? onTap;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.obscureText = false, // الافتراضي أن النص غير مخفي
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onFieldSubmitted,
    this.focusNode,
    this.maxLines = 1, // الافتراضي سطر واحد
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // تم إزالة الارتفاع الثابت لكي لا ينكسر التصميم عند ظهور رسالة الخطأ (Validator)
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 1),
            blurRadius: 3,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Center(
        child: TextFormField(
          // 🌟 تم التغيير إلى TextFormField لدعم الفالديشن
          controller: controller,
          validator: validator,
          focusNode: focusNode,
          keyboardType: keyboardType,
          obscureText: obscureText,
          textInputAction: textInputAction,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: hintText,
            fillColor: Colors.transparent,

            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: AppColor.golden, size: 24.sp)
                : null,

            // 🌟 أيقونة النهاية (Suffix)
            suffixIcon: suffixIcon,

            // إزالة الحدود الافتراضية
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,

            // 🌟 هذا البادينج هو ما يعطي الحقل ارتفاعه (بديل الـ height الثابت)
            contentPadding: EdgeInsets.symmetric(
              vertical: 16.h,
              horizontal: 16.w,
            ),
          ),
        ),
      ),
    );
  }
}
