import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/features/be_leader/data/models/pilgrim_model.dart';

class PilgrimListItemWidget extends StatelessWidget {
  const PilgrimListItemWidget({super.key, required this.pilgrim});

  final PilgrimModel pilgrim;

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;

    switch (pilgrim.statusId) {
      case 2:
        statusColor = Colors.greenAccent;
        statusText = pilgrim.statusName;
        break;
      case 1:
        statusColor = Colors.orangeAccent;
        statusText = pilgrim.statusName;
        break;
      case 3:
        statusColor = Colors.redAccent.withOpacity(0.5);
        statusText = pilgrim.statusName;
      default:
        statusColor = Colors.grey;
        break;
    }

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColor.withe,
        borderRadius: BorderRadius.circular(8.r),
        border: Border(
          right: BorderSide(color: statusColor, width: 4.w),
        ),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            pilgrim.pilgrimName,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              pilgrim.statusName,
              style: TextStyle(
                color: statusColor.withOpacity(1.0),
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
