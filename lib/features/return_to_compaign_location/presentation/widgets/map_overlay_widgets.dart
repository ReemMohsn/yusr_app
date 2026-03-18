import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/features/return_to_compaign_location/presentation/widgets/map_bottom_action_btn_widget.dart';
import 'package:yusr/features/return_to_compaign_location/presentation/widgets/map_header_capsule_widget.dart';
import 'map_ui_components_widget.dart';

class MapOverlayUI extends StatelessWidget {
  final String distance;
  final double heading;

  const MapOverlayUI({super.key, required this.distance, required this.heading});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(top: 50.h, left: 0, right: 0, child: const Center(child: MapHeaderCapsule())),
        
        Positioned(
          top: 50.h,
          right: 20.w,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 45.h, width: 45.h,
              decoration: const BoxDecoration(color: AppColor.withe, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_back_ios_new, color: AppColor.golden, size: 18),
            ),
          ),
        ),

        Positioned(
          bottom: 40.h,
          left: 30.w,
          right: 30.w,
          child: MapBottomActionBtn(
            distance: distance,
            bearing: heading, // تمرير اتجاه المستخدم للسهم الذهبي
          ),
        ),
      ],
    );
  }
}