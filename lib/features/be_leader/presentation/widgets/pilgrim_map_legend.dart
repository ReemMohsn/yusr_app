import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/extensions/context_extension.dart';

class PilgrimMapLegend extends StatelessWidget {
  const PilgrimMapLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LegendItem(
            icon: Icons.person_pin_circle,
            text: locale.youWord,
            color: Colors.teal,
          ),
          SizedBox(height: 6.h),
          _LegendItem(
            icon: Icons.person_pin_circle,
            text: locale.supervisor,
            color: Colors.blue.shade700,
          ),
          SizedBox(height: 6.h),
          _LegendItem(
            icon: Icons.circle,
            text: locale.warningZone20m,
            color: Colors.orange,
          ),
          SizedBox(height: 6.h),
          _LegendItem(
            icon: Icons.circle,
            text: locale.dangerZone30m,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}

// ── عنصر وسيلة الإيضاح ──────────────────────────────────────────
class _LegendItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _LegendItem({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        SizedBox(width: 6.w),
        Text(
          text,
          style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
