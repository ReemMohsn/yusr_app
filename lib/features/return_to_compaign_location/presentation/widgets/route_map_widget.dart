import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:yusr/core/constants/app_color.dart';

class RouteMapWidget extends StatelessWidget {
  final LatLng campaignLocation;
  final LatLng userLocation;
  final List<LatLng> routePoints;

  const RouteMapWidget({
    super.key,
    required this.campaignLocation,
    required this.userLocation,
    required this.routePoints,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: campaignLocation,
        initialZoom: 14.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: routePoints.isNotEmpty ? routePoints : [userLocation, campaignLocation],
              color: AppColor.golden,
              strokeWidth: 5.0,
            ),
          ],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: campaignLocation,
              width: 80, height: 80,
              child: const Icon(Icons.location_on, color: AppColor.golden, size: 40),
            ),
          ],
        ),
      ],
    );
  }
}