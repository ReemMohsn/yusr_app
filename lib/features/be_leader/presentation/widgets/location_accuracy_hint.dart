import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/extensions/context_extension.dart';

class LocationAccuracyHint extends StatefulWidget {
  const LocationAccuracyHint({super.key});

  @override
  State<LocationAccuracyHint> createState() => _LocationAccuracyHintState();
}

class _LocationAccuracyHintState extends State<LocationAccuracyHint> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();
    final locale = context.locale;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.blue.shade50.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.blue.shade200),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.sensors, color: Colors.blue.shade700, size: 20),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              locale.mapApproxHint,
              style: TextStyle(
                color: Colors.blue.shade900,
                fontSize: 11.sp,
                height: 1.4,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: () => setState(() => _isVisible = false),
            child: Icon(Icons.close, color: Colors.blue.shade400, size: 20),
          ),
        ],
      ),
    );
  }
}
