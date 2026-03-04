import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';

class CampaignLocationCard extends StatefulWidget {
  const CampaignLocationCard({super.key});

  @override
  State<CampaignLocationCard> createState() => _CampaignLocationCardState();
}

class _CampaignLocationCardState extends State<CampaignLocationCard> {
  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColor.withe,
        border: Border.all(color: AppColor.goldenWithOpacity),
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            offset: const Offset(0, 1),
            blurRadius: 3,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: -1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 39.w,
            height: 39.w,
            decoration: BoxDecoration(
              color: AppColor.goldenWithOpacity,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_on_outlined,
              color: AppColor.golden,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  locale.notFound,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.darkBlack,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  locale.loginToViewCampaignLocation,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColor.midlineColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
