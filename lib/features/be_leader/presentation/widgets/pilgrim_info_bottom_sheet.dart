import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/be_leader/providers/state/pilgrim_marker_data.dart';

class PilgrimInfoBottomSheet extends StatelessWidget {
  final PilgrimMarkerData pilgrim;
  final Color zoneColor;

  const PilgrimInfoBottomSheet({
    super.key,
    required this.pilgrim,
    required this.zoneColor,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    String fmt(DateTime dt) {
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      final s = dt.second.toString().padLeft(2, '0');
      return '$h:$m:$s';
    }

    final lastMovedText = fmt(pilgrim.lastSeen);
    final lastHeartbeatText = pilgrim.lastHeartbeat != null
        ? fmt(pilgrim.lastHeartbeat!)
        : '--:--:--';

    final isPhoneOnline =
        pilgrim.lastHeartbeat != null &&
        DateTime.now().difference(pilgrim.lastHeartbeat!).inSeconds < 120;

    final distanceText = pilgrim.distance < 1000
        ? '${pilgrim.distance.toStringAsFixed(1)} ${locale.meterWord}'
        : '${(pilgrim.distance / 1000).toStringAsFixed(2)} ${locale.km}';

    String zoneLabel;
    IconData zoneIcon;
    if (zoneColor == Colors.teal) {
      zoneLabel = locale.inSafeZone;
      zoneIcon = Icons.check_circle;
    } else if (zoneColor == Colors.orange) {
      zoneLabel = locale.onBorders;
      zoneIcon = Icons.warning_amber_rounded;
    } else {
      zoneLabel = locale.outOfZoneDanger;
      zoneIcon = Icons.dangerous;
    }

    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // مقبض
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(bottom: 16.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),

          // اسم الحاج
          Row(
            children: [
              CircleAvatar(
                backgroundColor: zoneColor.withOpacity(0.15),
                radius: 24.r,
                child: Icon(Icons.person, color: zoneColor, size: 26.r),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pilgrim.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(zoneIcon, size: 14.sp, color: zoneColor),
                        SizedBox(width: 4.w),
                        Text(
                          zoneLabel,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: zoneColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // مؤشر اتصال الهاتف
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isPhoneOnline
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isPhoneOnline ? Colors.green : Colors.red,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPhoneOnline ? Icons.wifi : Icons.wifi_off,
                      size: 12.sp,
                      color: isPhoneOnline ? Colors.green : Colors.red,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      isPhoneOnline ? locale.connectedMap : locale.disconnectedMap,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: isPhoneOnline ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),
          const Divider(),
          SizedBox(height: 12.h),

          // تفاصيل
          _InfoRow(
            icon: Icons.social_distance,
            label: locale.distanceFromLeader,
            value: distanceText,
            color: Colors.blue,
          ),
          SizedBox(height: 12.h),
          _InfoRow(
            icon: Icons.directions_walk,
            label: locale.lastActualMove,
            value: lastMovedText,
            color: Colors.teal,
          ),
          SizedBox(height: 12.h),
          _InfoRow(
            icon: Icons.phonelink_ring,
            label: locale.lastPhoneSignal,
            value: lastHeartbeatText,
            color: isPhoneOnline ? Colors.green : Colors.red,
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, size: 20.sp, color: color),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 11.sp, color: Colors.grey),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
