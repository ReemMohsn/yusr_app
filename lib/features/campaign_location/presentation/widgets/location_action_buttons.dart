import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_size.dart';

class LocationActionButtons extends StatelessWidget {
  final VoidCallback? onSave;
  final VoidCallback onCancel;
  final String saveLabel;
  final String cancelLabel;
  final bool canSave;
  final TextTheme theme;

  const LocationActionButtons({
    super.key,
    required this.onSave,
    required this.onCancel,
    required this.saveLabel,
    required this.cancelLabel,
    required this.canSave,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        AppSize.paddingOfPage.w, 
        10.h, 
        AppSize.paddingOfPage.w, 
        30.h
      ),
      child: Row(
        children: [
          // زر الحفظ
          Expanded(
            flex: 2,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: canSave ? AppColor.darkBlack : AppColor.inputFieldBoundaries,
                padding: EdgeInsets.symmetric(vertical: 15.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                elevation: 0,
              ),
              onPressed: canSave ? onSave : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.save_outlined, 
                    color: canSave ? AppColor.golden : AppColor.lightFontColor, 
                    size: 22.sp
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    saveLabel,
                    style: theme.bodyLarge?.copyWith(
                      color: canSave ? AppColor.golden : AppColor.lightFontColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 15.w),
          // زر الإلغاء
          Expanded(
            flex: 1,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColor.withe,
                padding: EdgeInsets.symmetric(vertical: 15.h),
                side: const BorderSide(color: AppColor.inputFieldBoundaries),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
              ),
              onPressed: onCancel,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.close_rounded,
                    color: AppColor.midlineColor,
                    size: 18.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    cancelLabel,
                    style: theme.bodyLarge?.copyWith(color: AppColor.midlineColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}