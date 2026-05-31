import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';

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

  bool get _hasRealUserLocation =>
      userLocation.latitude != 0 || userLocation.longitude != 0;

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    final theme = Theme.of(context);

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(initialCenter: campaignLocation, initialZoom: 17.0),
      children: [
        TileLayer(
          urlTemplate:
              'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
          userAgentPackageName: 'com.yusr.app',
        ),
        PolylineLayer(
          polylines: [
            if (_hasRealUserLocation)
              Polyline(
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
            // ماركر موقع الحملة — يظهر دائماً
            Marker(
              point: campaignLocation,
              width: 80,
              height: 80,
              child: const Icon(
                Icons.location_on,
                color: AppColor.golden,
                size: 45,
              ),
            ),
            // ماركر المستخدم — يظهر فقط بعد وصول GPS حقيقي
            if (_hasRealUserLocation)
              Marker(
                point: userLocation,
                width: 100,
                height: 100,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 4),
                        ],
                      ),
                      child: Text(
                        locale.youAreHere,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 10.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
