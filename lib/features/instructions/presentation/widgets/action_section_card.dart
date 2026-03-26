import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/features/instructions/data/models/hajj_action_model.dart';

class ActionSectionCard extends StatelessWidget {
  final ActionSectionModel section;

  const ActionSectionCard({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    Color bgColor = AppColor.withe;
    Color borderColor = AppColor.inputFieldBoundaries;
    Color titleColor = AppColor.golden;
    IconData titleIcon = Icons.info_outline;

    if (section.type == SectionType.warning) {
      bgColor = const Color(0xFFFFF5F5); // Light danger bg
      borderColor = AppColor.danger.withValues(alpha: 0.2);
      titleColor = AppColor.danger;
      titleIcon = Icons.warning_amber_rounded;
    } else if (section.type == SectionType.dua) {
      bgColor = const Color(0xFFF0FDF4); // Light success bg
      borderColor = AppColor.success.withValues(alpha: 0.2);
      titleColor = AppColor.success;
      titleIcon = Icons.menu_book;
    }

    return Container(
      margin: EdgeInsets.only(bottom: AppSize.paddingOfPage.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(
          16.r,
        ), // Standard card radius for this feature
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: AppColor.darkBlack.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.paddingOfPage.w,
              vertical: 12.h,
            ),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: borderColor)),
            ),
            child: Row(
              children: [
                Icon(titleIcon, color: titleColor, size: 24.sp),
                SizedBox(width: 10.w),
                Text(
                  section.title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppSize.paddingOfPage.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: section.items.map((item) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (section.type != SectionType.dua) ...[
                        Container(
                          margin: EdgeInsets.only(top: 8.h, left: 10.w),
                          width: 6.w,
                          height: 6.w,
                          decoration: BoxDecoration(
                            color: titleColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                      Expanded(
                        child: Text(
                          item,
                          textAlign: section.type == SectionType.dua
                              ? TextAlign.center
                              : TextAlign.right,
                          style: TextStyle(
                            fontSize: 15.sp,
                            height: 1.6,
                            fontWeight: section.type == SectionType.dua
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: section.type == SectionType.dua
                                ? titleColor
                                : AppColor.baseFontColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
