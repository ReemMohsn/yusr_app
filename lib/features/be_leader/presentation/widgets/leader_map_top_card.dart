import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/be_leader/providers/state/tracking_state.dart';

class LeaderMapTopCard extends StatelessWidget {
  final TrackingState state;
  final bool isLeaderConnected;

  const LeaderMapTopCard({
    super.key,
    required this.state,
    required this.isLeaderConnected,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    // عدد الحجاج المؤكَّدين بالبلوتوث (من جميع مناطق الألوان)
    final bleCount = [
      ...state.greenPilgrims,
      ...state.yellowPilgrims,
      ...state.redPilgrims,
    ].where((p) => p.isSafeByBle).length;
    return Row(
      children: [
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
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: !state.isNetworkConnected
                          ? Colors.red
                          : (isLeaderConnected ? Colors.green : Colors.orange),
                      size: 12,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      !state.isNetworkConnected
                          ? locale.noInternet
                          : (isLeaderConnected
                                ? locale.connectedMap
                                : locale.searchingForLocation),
                      style: TextStyle(
                        color: !state.isNetworkConnected
                            ? Colors.red
                            : (isLeaderConnected
                                  ? Colors.green
                                  : Colors.orange),
                        fontWeight: FontWeight.bold,
                        fontSize: isLeaderConnected ? 14.sp : 11.sp,
                      ),
                    ),
                  ],
                ),
                // عداد الحجاج مع ألوان
                Row(
                  children: [
                    if (state.greenPilgrims.isNotEmpty)
                      _PilgrimCount(
                        count: state.greenPilgrims.length,
                        color: Colors.teal,
                      ),
                    if (state.yellowPilgrims.isNotEmpty)
                      _PilgrimCount(
                        count: state.yellowPilgrims.length,
                        color: Colors.orange,
                      ),
                    if (state.redPilgrims.isNotEmpty)
                      _PilgrimCount(
                        count: state.redPilgrims.length,
                        color: Colors.red,
                      ),
                    if (state.totalPilgrims == 0)
                      Text(
                        locale.noPilgrims,
                        style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                      ),
                    // ── فاصل + عداد BLE ────────────────────────────
                    if (state.totalPilgrims > 0) ...([
                      Container(
                        height: 16.h,
                        width: 1,
                        margin: EdgeInsets.symmetric(horizontal: 6.w),
                        color: Colors.grey.shade300,
                      ),
                      _PilgrimCount(
                        count: bleCount,
                        color: Colors.blue.shade600,
                        icon: Icons.bluetooth,
                      ),
                    ]),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PilgrimCount extends StatelessWidget {
  final int count;
  final Color color;
  final IconData? icon;

  const _PilgrimCount({required this.count, required this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 4.w),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...([
            Icon(icon!, size: 11.sp, color: color),
            SizedBox(width: 3.w),
          ]),
          Text(
            '$count',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
