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

    // المسافة: إذا BLE مؤكَّد → "مسافة مؤكدة"، وإلا → "مسافة تقديرية"
    final distanceLabel = pilgrim.isSafeByBle
        ? locale.distanceConfirmed
        : locale.distanceApprox;
    final distancePrefix = pilgrim.isSafeByBle ? '' : '~';
    final distanceValue = pilgrim.distance < 1000
        ? '$distancePrefix${pilgrim.distance.toStringAsFixed(1)} ${locale.meterWord}'
        : '$distancePrefix${(pilgrim.distance / 1000).toStringAsFixed(2)} ${locale.km}';

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

    return SingleChildScrollView(
      child: Padding(
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
                backgroundColor: zoneColor.withValues(alpha: 0.15),
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
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1),
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
                      isPhoneOnline
                          ? locale.connectedMap
                          : locale.disconnectedMap,
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

          SizedBox(height: 16.h),

          // ── بطاقة حالة BLE ───────────────────────────────────────────
          _BleBadge(isSafeByBle: pilgrim.isSafeByBle, locale: locale),

          SizedBox(height: 16.h),
          const Divider(),
          SizedBox(height: 12.h),

          // تفاصيل المسافة (مع توضيح تقديري/مؤكَّد)
          _InfoRow(
            icon: Icons.social_distance,
            label: distanceLabel,
            value: distanceValue,
            color: pilgrim.isSafeByBle ? Colors.blue : Colors.blueGrey,
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

          SizedBox(height: 12.h),
          // تنبيه صغير في الأسفل
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.blueGrey.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: Colors.blueGrey.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 14.sp,
                  color: Colors.blueGrey.shade500,
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    locale.mapApproxHint,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.blueGrey.shade600,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),
        ],
      ),
      ),
    );
  }
}

/// بطاقة BLE: خضراء إذا مؤكَّد، رمادية إذا غير مرصود
class _BleBadge extends StatelessWidget {
  final bool isSafeByBle;
  final dynamic locale; // AppLocalizations

  const _BleBadge({required this.isSafeByBle, required this.locale});

  @override
  Widget build(BuildContext context) {
    final color = isSafeByBle ? Colors.blue.shade600 : Colors.grey.shade500;
    final bgColor = isSafeByBle
        ? Colors.blue.withValues(alpha: 0.08)
        : Colors.grey.withValues(alpha: 0.07);
    final borderColor = isSafeByBle
        ? Colors.blue.withValues(alpha: 0.3)
        : Colors.grey.withValues(alpha: 0.3);
    final label = isSafeByBle
        ? locale.bleConfirmedNearby as String
        : locale.bleNotDetected as String;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          // دائرة BLE
          Container(
            width: 14.w,
            height: 14.w,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: isSafeByBle
                  ? [
                      BoxShadow(
                        color: Colors.blue.withValues(alpha: 0.4),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                locale.bleProximityLabel as String,
                style: TextStyle(fontSize: 10.sp, color: Colors.grey.shade600),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
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
            color: color.withValues(alpha: 0.1),
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
