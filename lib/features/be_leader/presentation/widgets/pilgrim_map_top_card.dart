import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/be_leader/providers/state/pilgrim_tracking_state.dart';

class PilgrimMapTopCard extends StatelessWidget {
  final PilgrimTrackingState state;
  final bool isConnected;

  const PilgrimMapTopCard({
    super.key,
    required this.state,
    required this.isConnected,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    final distanceText = state.distance < 1000
        ? '${state.distance.toStringAsFixed(0)} ${locale.meterWord}'
        : '${(state.distance / 1000).toStringAsFixed(2)} ${locale.km}';

    return Column(
      children: [
        Row(
          children: [
            // زر الرجوع
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            height: 45.h,
            width: 45.h,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColor.golden,
              size: 18,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.r),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 5),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // حالة الاتصال
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: !state.isNetworkConnected
                          ? Colors.red
                          : (isConnected ? Colors.green : Colors.orange),
                      size: 12,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      !state.isNetworkConnected
                          ? locale.noInternet
                          : (isConnected
                              ? locale.connectedMap
                              : locale.searchingForLocation),
                      style: TextStyle(
                        color: !state.isNetworkConnected
                            ? Colors.red
                            : (isConnected ? Colors.green : Colors.orange),
                        fontWeight: FontWeight.bold,
                        fontSize: isConnected ? 13.sp : 11.sp,
                      ),
                    ),
                  ],
                ),

                // المسافة + الحالة
                if (isConnected)
                  Row(
                    children: [
                      Icon(
                        Icons.social_distance,
                        size: 14.sp,
                        color: state.statusColor,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        distanceText,
                        style: TextStyle(
                          color: state.statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: state.statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: state.statusColor.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          state.statusText,
                          style: TextStyle(
                            color: state.statusColor,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                if (!isConnected)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.orange,
                    ),
                  ),
              ],
            ),
          ),
        ),
          ],
        ),
      ],
    );
  }
}
