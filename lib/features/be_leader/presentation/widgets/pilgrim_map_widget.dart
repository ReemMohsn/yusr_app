import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/be_leader/providers/state/pilgrim_tracking_state.dart';

class PilgrimMapWidget extends ConsumerWidget {
  final MapController mapController;
  final PilgrimTrackingState mapState;

  const PilgrimMapWidget({
    super.key,
    required this.mapController,
    required this.mapState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale;

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter:
            mapState.pilgrimLocation ??
            mapState.leaderLocation ??
            const LatLng(21.422487, 39.826206),
        initialZoom: 17.0,
      ),
      children: [
        // 🛰️ طبقة القمر الصناعي
        TileLayer(
          urlTemplate:
              'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
          userAgentPackageName: 'com.yusr.app',
        ),

        // ── دوائر نطاق المشرف ──────────────────────────────────
        if (mapState.leaderLocation != null)
          CircleLayer(
            circles: [
              // 🔴 دائرة الخطر (30م)
              CircleMarker(
                point: mapState.leaderLocation!,
                color: Colors.red.withOpacity(0.08),
                borderColor: Colors.red.withOpacity(0.6),
                borderStrokeWidth: 2,
                radius: 30,
                useRadiusInMeter: true,
              ),
              // 🟠 دائرة التحذير (20م)
              CircleMarker(
                point: mapState.leaderLocation!,
                color: Colors.orange.withOpacity(0.1),
                borderColor: Colors.orange.withOpacity(0.7),
                borderStrokeWidth: 2,
                radius: 20,
                useRadiusInMeter: true,
              ),
            ],
          ),

        // ── الماركرات ───────────────────────────────────────────
        MarkerLayer(
          markers: [
            // ماركر المشرف
            if (mapState.leaderLocation != null)
              Marker(
                point: mapState.leaderLocation!,
                width: 90,
                height: 80,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade800,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 4),
                        ],
                      ),
                      child: Text(
                        locale.supervisor,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.person_pin_circle,
                      color: Colors.blue.shade700,
                      size: 28,
                    ),
                  ],
                ),
              ),

            // ماركر الحاج (أنت)
            if (mapState.pilgrimLocation != null)
              Marker(
                point: mapState.pilgrimLocation!,
                width: 90,
                height: 80,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: mapState.statusColor,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 4),
                        ],
                      ),
                      child: Text(
                        locale.youAreHere,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.person_pin_circle,
                      color: mapState.statusColor,
                      size: 28,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
