import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/features/campaign_location/data/models/campaign_location_item_model.dart';
class LocationItemCard extends StatelessWidget {
  final CampaignLocationItemModel loc;
  final bool isSelected;
  final bool isCurrentlyActive;
  final dynamic locale;
  final TextTheme theme;
  final VoidCallback onTap;

  const LocationItemCard({
    super.key,
    required this.loc,
    required this.isSelected,
    required this.isCurrentlyActive,
    required this.locale,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
        decoration: BoxDecoration(
          color: AppColor.withe,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? AppColor.golden
                : (isCurrentlyActive
                      ? AppColor.golden.withOpacity(0.3)
                      : AppColor.withe),
            width: 1.5.w,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColor.golden.withOpacity(0.08)
                  : AppColor.darkBlack.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Radio Indicator
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 22.w,
                  width: 22.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppColor.golden
                          : AppColor.lightFontColor,
                      width: 2.w,
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    height: 12.w,
                    width: 12.w,
                    decoration: const BoxDecoration(
                      color: AppColor.golden,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.locationName,
                    style: theme.bodyMedium?.copyWith(
                      color: isSelected
                          ? AppColor.baseFontColor
                          : AppColor.midlineColor,
                    ),
                  ),
                  if (isCurrentlyActive)
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: Text(
                        locale.currentLocation,
                        style: theme.bodySmall?.copyWith(
                          color: AppColor.golden,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.location_on_rounded,
              color: isSelected
                  ? AppColor.golden
                  : AppColor.inputFieldBoundaries,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}
