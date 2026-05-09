import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:yusr/core/common/providers/shared_preferences_service_provider.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/features/be_leader/providers/pilgrim_tracking_controller.dart';
import 'package:yusr/features/be_leader/providers/state/pilgrim_tracking_state.dart';
import 'package:yusr/features/return_to_compaign_location/presentation/widgets/tracking_fab_widget.dart';

class PilgrimMapTrackingView extends ConsumerStatefulWidget {
  final int sessionId;
  const PilgrimMapTrackingView({super.key, required this.sessionId});

  @override
  ConsumerState<PilgrimMapTrackingView> createState() =>
      _PilgrimMapTrackingViewState();
}

class _PilgrimMapTrackingViewState
    extends ConsumerState<PilgrimMapTrackingView> {
  final MapController _mapController = MapController();
  bool _isTracking = true;

  // ── دايالوج تأكيد إيقاف التتبع ──────────────────────────────
  Future<void> _showStopTrackingDialog(
    BuildContext context,
    String pilgrimId,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            title: const Text(
              'إيقاف التتبع',
              style: TextStyle(color: Colors.red),
            ),
            content: const Text(
              'هل أنت متأكد أنك تريد إيقاف التتبع والخروج من الجلسة؟ سيتم إشعار المشرف بذلك.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text(
                  'تراجع',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text(
                  'نعم، إيقاف',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );

    if (confirm == true && context.mounted) {
      await ref
          .read(pilgrimTrackingControllerProvider.notifier)
          .leaveAndStopTracking(
            sessionId: widget.sessionId,
            pilgrimId: pilgrimId,
          );
      if (context.mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(pilgrimTrackingControllerProvider);

    // ── SnackBar للتحذيرات ────────────────────────────────────
    ref.listen<PilgrimTrackingState>(pilgrimTrackingControllerProvider, (
      previous,
      next,
    ) {
      if (next.gpsWarning != null &&
          next.gpsWarning != previous?.gpsWarning) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.gpsWarning!),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 4),
          ),
        );
      }
      if (next.bleWarning != null &&
          next.bleWarning != previous?.bleWarning) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(
                  Icons.bluetooth_disabled,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(next.bleWarning!)),
              ],
            ),
            backgroundColor: Colors.blueGrey,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    });

    if (mapState.errorMessage != null) {
      return Scaffold(
        body: Center(child: Text(mapState.errorMessage!)),
      );
    }

    final bool isConnected = mapState.pilgrimLocation != null;
    // الإنذار نشط إذا تجاوزت المسافة 30م (الحد الأحمر)
    final bool isAlarmZone = mapState.distance > 30;

    return Scaffold(
      body: Stack(
        children: [
          // ── الخريطة (قمر صناعي) ─────────────────────────────
          FlutterMap(
            mapController: _mapController,
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

              // ── دوائر نطاق المشرف ──────────────────────────
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

              // ── الماركرات ───────────────────────────────────
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
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Text(
                              'المشرف',
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
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Text(
                              'أنت هنا',
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
          ),

          // ── الشريط العلوي ─────────────────────────────────────
          Positioned(
            top: 55,
            left: 20,
            right: 20,
            child: _buildTopCard(context, mapState, isConnected),
          ),

          // ── زر كتم الإنذار (عند الخطر) ───────────────────────
          if (isAlarmZone)
            Positioned(
              bottom: 160,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade800,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    elevation: 6,
                  ),
                  icon: const Icon(Icons.volume_off),
                  label: Text(
                    'كتم الإنذار مؤقتاً',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  onPressed: () {
                    ref
                        .read(pilgrimTrackingControllerProvider.notifier)
                        .stopAlarmManual(isUserAction: true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          '🔇 تم كتم الصوت. سيعود تلقائياً عند عودتك للأمان.',
                        ),
                        backgroundColor: Colors.black87,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  },
                ),
              ),
            ),

          // ── وسيلة الإيضاح ─────────────────────────────────────
          Positioned(bottom: 110, right: 16, child: _buildLegend()),

          // ── زر تتبع الكاميرا ──────────────────────────────────
          TrackingFAB(
            isTracking: _isTracking,
            onPressed: () {
              setState(() => _isTracking = !_isTracking);
              if (mapState.pilgrimLocation != null) {
                _mapController.move(mapState.pilgrimLocation!, 17.0);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('جاري تحديد موقعك، يرجى الانتظار...'),
                  ),
                );
              }
            },
          ),

          // ── زر إيقاف التتبع ────────────────────────────────────
          Positioned(
            bottom: 28,
            left: 0,
            right: 0,
            child: Center(
              child: FutureBuilder(
                future: ref
                    .read(sharedPreferencesServiceProvider)
                    .getProfile(),
                builder: (context, snapshot) {
                  final profile = snapshot.data;
                  return FloatingActionButton.extended(
                    heroTag: 'stop_tracking_pilgrim',
                    backgroundColor: Colors.red,
                    icon: const Icon(Icons.stop),
                    label: const Text('إيقاف التتبع'),
                    onPressed: () {
                      if (profile?.userId != null) {
                        _showStopTrackingDialog(
                          context,
                          profile!.userId.toString(),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── الشريط العلوي (حالة الاتصال + المسافة) ──────────────────
  Widget _buildTopCard(
    BuildContext context,
    PilgrimTrackingState state,
    bool isConnected,
  ) {
    final distanceText = state.distance < 1000
        ? '${state.distance.toStringAsFixed(0)} م'
        : '${(state.distance / 1000).toStringAsFixed(2)} كم';

    return Row(
      children: [
        // زر الرجوع
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            height: 45.h,
            width: 45.h,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColor.golden,
              size: 18,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.r),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 5),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // حالة الاتصال
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: isConnected ? Colors.green : Colors.orange,
                      size: 12,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      isConnected ? 'متصل' : 'جاري جلب الموقع...',
                      style: TextStyle(
                        color: isConnected
                            ? Colors.green
                            : Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: isConnected ? 13.sp : 11.sp,
                      ),
                    ),
                  ],
                ),
                // المسافة + الحالة
                if (isConnected)
                  Row(
                    children: [
                      Icon(
                        Icons.social_distance,
                        size: 14.sp,
                        color: state.statusColor,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        distanceText,
                        style: TextStyle(
                          color: state.statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: state.statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: state.statusColor.withOpacity(0.4),
                          ),
                        ),
                        child: Text(
                          state.statusText,
                          style: TextStyle(
                            color: state.statusColor,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (!isConnected)
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.orange,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── وسيلة الإيضاح ─────────────────────────────────────────────
  Widget _buildLegend() {
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
          _legendItem(Icons.person_pin_circle, 'أنت', Colors.teal),
          SizedBox(height: 6.h),
          _legendItem(
            Icons.person_pin_circle,
            'المشرف',
            Colors.blue.shade700,
          ),
          SizedBox(height: 6.h),
          _legendItem(Icons.circle, 'نطاق التحذير (20م)', Colors.orange),
          SizedBox(height: 6.h),
          _legendItem(Icons.circle, 'نطاق الخطر (30م)', Colors.red),
        ],
      ),
    );
  }

  Widget _legendItem(IconData icon, String text, Color color) {
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
