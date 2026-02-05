// --- ويدجت خاصة لحقل إدخال رقم واحد (تم فصلها للتنظيم) ---
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';

class OtpDigitField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final FocusNode? prevFocusNode;

  const OtpDigitField({
    required this.controller,
    required this.focusNode,
    this.nextFocusNode,
    this.prevFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30.w, // عرض ثابت ومناسب
      height: 60.h, // ارتفاع ثابت
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace) {
            // إذا كان الحقل فارغاً وضغط المستخدم حذف، عد للخلف
            if (controller.text.isEmpty && prevFocusNode != null) {
              prevFocusNode!.requestFocus();
            }
          }
        },
        child: TextFormField(
          // validator: AppValidator.validateEmptyField,
          controller: controller,
          focusNode: focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: AppColor.lightBlack,
          ),
          decoration: InputDecoration(contentPadding: EdgeInsets.zero),
          onChanged: (value) {
            if (value.isNotEmpty) {
              // إذا تم إدخال رقم، انتقل للتالي
              if (nextFocusNode != null) {
                nextFocusNode!.requestFocus();
              } else {
                // إذا كان آخر حقل، أخف لوحة المفاتيح
                focusNode.unfocus();
              }
            } else {
              // إذا قام المستخدم بحذف الرقم (أصبح فارغاً)، عد للسابق
              if (value.isEmpty && prevFocusNode != null) {
                prevFocusNode!.requestFocus();
              }
            }
          },
        ),
      ),
    );
  }
}
