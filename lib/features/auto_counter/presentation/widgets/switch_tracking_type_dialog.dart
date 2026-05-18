import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';

/// ديالوج تأكيد تبديل نوع النسك (طواف ↔ سعي) أثناء التشغيل
///
/// يعيد [true] عند الضغط على تأكيد → ينقل ويُصفِّر كل شيء
/// يعيد [false] عند الضغط على إلغاء أو الإغلاق → لا يتغير شيء
class SwitchTrackingTypeDialog extends StatelessWidget {
  /// النسك الذي سيُنتقل إليه
  final bool toTawaf;

  const SwitchTrackingTypeDialog({super.key, required this.toTawaf});

  /// طريقة الاستخدام من خارج الـ widget:
  /// ```dart
  /// final confirmed = await SwitchTrackingTypeDialog.show(context, toTawaf: true);
  /// if (confirmed == true) { ... }
  /// ```
  static Future<bool?> show(BuildContext context, {required bool toTawaf}) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => SwitchTrackingTypeDialog(toTawaf: toTawaf),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    final targetName = toTawaf ? locale.tawaf : locale.saei;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      backgroundColor: AppColor.withe,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColor.withe,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColor.golden.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── الهيدر ────────────────────────────────────────
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context, false),
                  child: Icon(Icons.close, color: Colors.grey, size: 24.sp),
                ),
                const Spacer(),
                Text(
                  locale.switchTrackingType,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(Icons.swap_horiz, color: AppColor.golden, size: 24.sp),
              ],
            ),

            SizedBox(height: 20.h),

            // ── صندوق التحذير ────────────────────────────────
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColor.golden.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColor.golden.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: AppColor.golden,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      locale.switchTrackingTypeWarning(targetName),
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),
            Divider(color: Colors.grey.shade200, height: 1),
            SizedBox(height: 20.h),

            // ── أزرار الإجراءات ───────────────────────────────
            Row(
              children: [
                // زر الإلغاء
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      locale.cancel,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 12.w),

                // زر التأكيد
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(
                      locale.confirm,
                      style: TextStyle(
                        color: AppColor.golden,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
