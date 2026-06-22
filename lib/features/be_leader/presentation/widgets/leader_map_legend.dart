import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/extensions/context_extension.dart';

class LeaderMapLegend extends StatelessWidget {
  const LeaderMapLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LegendItem(text: locale.insideZone, color: Colors.teal),
          SizedBox(height: 6.h),
          _LegendItem(text: locale.onBordersOnly, color: Colors.orange),
          SizedBox(height: 6.h),
          _LegendItem(text: locale.outOfZone, color: Colors.red),
          SizedBox(height: 8.h),
          Divider(height: 1, thickness: 0.8, color: Colors.grey.shade300),
          SizedBox(height: 8.h),
          _BleLegendItem(text: locale.bleConfirmedLegend),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String text;
  final Color color;

  const _LegendItem({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.location_on, color: color, size: 18),
        SizedBox(width: 6.w),
        Text(
          text,
          style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

/// عنصر BLE بنقطة زرقاء بدل أيقونة الموقع
class _BleLegendItem extends StatelessWidget {
  final String text;

  const _BleLegendItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: Colors.blue.shade600,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withValues(alpha: 0.4),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: Colors.blue.shade700,
          ),
        ),
      ],
    );
  }
}
