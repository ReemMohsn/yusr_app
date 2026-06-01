import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';

class TrackingFAB extends StatelessWidget {
  final bool isTracking;
  final VoidCallback onPressed;

  const TrackingFAB({
    super.key,
    required this.isTracking,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 220,
      right: 16,
      child: FloatingActionButton(
        mini: true,
        backgroundColor: AppColor.withe,
        onPressed: onPressed,
        child: Icon(
          isTracking ? Icons.explore : Icons.explore_off,
          color: AppColor.golden,
        ),
      ),
    );
  }
}
