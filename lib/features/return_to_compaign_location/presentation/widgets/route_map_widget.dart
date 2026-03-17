import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:yusr/core/constants/app_color.dart';

class RouteMapWidget extends StatelessWidget {
  final LatLng campaignLocation;
  final LatLng userLocation;
  final List<LatLng> routePoints;
  final MapController mapController;

  const RouteMapWidget({
    super.key,
    required this.campaignLocation,
    required this.userLocation,
    required this.routePoints,
    required this.mapController,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: campaignLocation,
        initialZoom: 17.0, // زووم أقرب لرؤية التضاريس بوضوح
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
          userAgentPackageName: 'com.yusr.app',
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              // التأكد من إكمال القوس وإضافة النقطتين في حال كانت القائمة فارغة
              points: routePoints.isNotEmpty 
                  ? routePoints 
                  : [userLocation, campaignLocation], 
              color: AppColor.golden,
              strokeWidth: 5.0,
            ),
          ],
        ),
        MarkerLayer(
          markers: [
            // ماركر موقع الحملة
            Marker(
              point: campaignLocation,
              width: 80, height: 80,
              child: const Icon(Icons.location_on, color: AppColor.golden, size: 45),
            ),
            // ماركر المستخدم مع عبارة "أنت هنا"
            Marker(
              point: userLocation,
              width: 100, // زيادة العرض لاستيعاب النص
              height: 100,
              child: Column(
                children: [
                  // عبارة "أنت هنا" داخل كبسولة بيضاء
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    child: Text(
                      "أنت هنا",
                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  // النقطة الزرقاء (موقعك)
                  const Icon(Icons.circle, color: Colors.blue, size: 20),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}