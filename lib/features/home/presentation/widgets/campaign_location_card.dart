import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';

class CampaignLocationCard extends StatefulWidget {
  const CampaignLocationCard({super.key});

  @override
  State<CampaignLocationCard> createState() => _CampaignLocationCardState();
}

class _CampaignLocationCardState extends State<CampaignLocationCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColor.withe,
        border: Border.all(color: AppColor.goldenWithOpacity),
        borderRadius: BorderRadius.circular(40.r),
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
        children: [
          Container(
            width: 25.w,
            height: 25.w,
            decoration: BoxDecoration(
              color: AppColor.goldenWithOpacity,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_on_outlined,
              color: AppColor.golden,
              size: 14.sp,
            ),
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "لا يوجد",
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColor.darkBlack,
                ),
              ),
              Text(
                "يرجى تسجيل الدخول لعرض موقع استقرار الحملة",
                style: TextStyle(fontSize: 8.sp, color: AppColor.midlineColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
