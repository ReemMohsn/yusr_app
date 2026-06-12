import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/be_leader/providers/state/pilgrim_marker_data.dart';
import 'package:yusr/features/be_leader/providers/state/tracking_state.dart';
import 'package:yusr/features/be_leader/presentation/widgets/pilgrim_info_bottom_sheet.dart';

class LeaderMapWidget extends ConsumerWidget {
  final MapController mapController;
  final TrackingState mapState;

  const LeaderMapWidget({
    super.key,
    required this.mapController,
    required this.mapState,
  });

  // ── بناء ماركر الحاج مع دعم الضغط ──────────────────────────
  Marker _buildPilgrimMarker(
    BuildContext context,
    PilgrimMarkerData p,
    Color color,
  ) {
    return Marker(
      point: p.location,
      width: 70,
      height: 65,
      child: GestureDetector(
        onTap: () => _showPilgrimInfoSheet(context, p, color),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // فقاعة الاسم
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6.r),
                boxShadow: const [
                  BoxShadow(color: Colors.black38, blurRadius: 3),
                ],
              ),
              child: Text(
                p.name.length > 8 ? '${p.name.substring(0, 8)}..' : p.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 8.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(Icons.location_on, color: color, size: 26),
          ],
        ),
      ),
    );
  }

  // ── نافذة معلومات الحاج عند الضغط ───────────────────────────
  void _showPilgrimInfoSheet(
    BuildContext context,
    PilgrimMarkerData p,
    Color zoneColor,
  ) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => PilgrimInfoBottomSheet(
        pilgrim: p,
        zoneColor: zoneColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale;

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter:
            mapState.leaderLocation ?? const LatLng(21.422487, 39.826206),
        initialZoom: 17.0,
      ),
      children: [
        // 🛰️ طبقة الصور الجوية (قمر صناعي)
        TileLayer(
          urlTemplate:
              'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
          userAgentPackageName: 'com.yusr.app',
        ),

        // ── دوائر نطاق المشرف ────────────────────────────────
        if (mapState.leaderLocation != null)
          CircleLayer(
            circles: [
              // 🔴 دائرة الخطر (30 متر)
              CircleMarker(
                point: mapState.leaderLocation!,
                color: Colors.red.withOpacity(0.08),
                borderColor: Colors.red.withOpacity(0.6),
                borderStrokeWidth: 2,
                radius: 30,
                useRadiusInMeter: true,
              ),
              // 🟠 دائرة التحذير (20 متر)
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

        // ── ماركرات الحجاج والمشرف ──────────────────────────
        MarkerLayer(
          markers: [
            // ماركر المشرف (أنت هنا)
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
                      color: Colors.blue.shade700,
                      size: 28,
                    ),
                  ],
                ),
              ),

            // ماركرات الحجاج حسب النطاق
            ...mapState.greenPilgrims.map(
              (p) => _buildPilgrimMarker(context, p, Colors.teal),
            ),
            ...mapState.yellowPilgrims.map(
              (p) => _buildPilgrimMarker(context, p, Colors.orange),
            ),
            ...mapState.redPilgrims.map(
              (p) => _buildPilgrimMarker(context, p, Colors.red),
            ),
          ],
        ),
      ],
    );
  }
}
