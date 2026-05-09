import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/features/be_leader/providers/leader_tracking_controller.dart';
import 'package:yusr/features/be_leader/providers/state/pilgrim_marker_data.dart';
import 'package:yusr/features/be_leader/providers/state/tracking_state.dart';
import 'package:yusr/features/return_to_compaign_location/presentation/widgets/tracking_fab_widget.dart';

class LeaderMapTrackingView extends ConsumerStatefulWidget {
  final int sessionId;
  const LeaderMapTrackingView({super.key, required this.sessionId});

  @override
  ConsumerState<LeaderMapTrackingView> createState() =>
      _LeaderMapTrackingViewState();
}

class _LeaderMapTrackingViewState extends ConsumerState<LeaderMapTrackingView> {
  final MapController _mapController = MapController();
  bool _isTracking = true;

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(leaderTrackingControllerProvider);
    ref.listen<TrackingState>(leaderTrackingControllerProvider, (
      previous,
      next,
    ) {
      if (next.gpsWarning != null && next.gpsWarning != previous?.gpsWarning) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.gpsWarning!),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 4),
          ),
        );
      }
      if (next.bleWarning != null && next.bleWarning != previous?.bleWarning) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.bluetooth_disabled, color: Colors.white),
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

    return Scaffold(
      body: Stack(
        children: [
          // ── الخريطة (قمر صناعي) ──────────────────────────────
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter:
                  mapState.leaderLocation ??
                  const LatLng(21.422487, 39.826206),
              initialZoom: 17.0,
            ),
            children: [
              // 🛰️ طبقة الصور الجوية (قمر صناعي)
              TileLayer(
                urlTemplate:
                    'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                userAgentPackageName: 'com.yusr.app',
              ),

              // ── دوائر نطاق المشرف ─────────────────────────
              if (mapState.leaderLocation != null)
                CircleLayer(
                  circles: [
                    // 🔴 دائرة الخطر (30 متر) - حمراء
                    CircleMarker(
                      point: mapState.leaderLocation!,
                      color: Colors.red.withOpacity(0.08),
                      borderColor: Colors.red.withOpacity(0.6),
                      borderStrokeWidth: 2,
                      radius: 30,
                      useRadiusInMeter: true,
                    ),
                    // 🟠 دائرة التحذير (20 متر) - برتقالية
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

              // ── ماركرات الحجاج والمشرف ─────────────────────
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
                            color: Colors.blue.shade700,
                            size: 28,
                          ),
                        ],
                      ),
                    ),

                  // ماركرات الحجاج
                  ...mapState.greenPilgrims.map(
                    (p) => _buildPilgrimMarker(p, Colors.teal),
                  ),
                  ...mapState.yellowPilgrims.map(
                    (p) => _buildPilgrimMarker(p, Colors.orange),
                  ),
                  ...mapState.redPilgrims.map(
                    (p) => _buildPilgrimMarker(p, Colors.red),
                  ),
                ],
              ),
            ],
          ),

          // ── البطاقة العلوية ───────────────────────────────────
          Positioned(
            top: 55,
            left: 20,
            right: 20,
            child: _buildTopCard(
              context,
              mapState.totalPilgrims,
              mapState.leaderLocation != null && mapState.gpsWarning == null,
              mapState,
            ),
          ),

          // ── مفتاح ديناميكي: زر الإنذار إذا كان هناك حجاج في الخطر ──
          if (mapState.redPilgrims.isNotEmpty)
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
                        .read(leaderTrackingControllerProvider.notifier)
                        .stopAlarmManual(isUserAction: true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          '🔇 تم كتم الصوت. سيعود تلقائياً عند عودة الحجاج للأمان.',
                        ),
                        backgroundColor: Colors.black87,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  },
                ),
              ),
            ),

          // ── وسيلة الإيضاح (Legend) ───────────────────────────
          Positioned(bottom: 110, right: 16, child: _buildLegend()),

          // ── زر تتبع الكاميرا ──────────────────────────────────
          TrackingFAB(
            isTracking: _isTracking,
            onPressed: () {
              setState(() => _isTracking = !_isTracking);
              if (mapState.leaderLocation != null) {
                _mapController.move(mapState.leaderLocation!, 17.0);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('جاري تحديد موقعك، يرجى الانتظار...'),
                  ),
                );
              }
            },
          ),

          // ── زر إنهاء الجلسة ──────────────────────────────────
          Positioned(
            bottom: 28,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton.extended(
                heroTag: 'stop_session_unique_tag',
                backgroundColor: Colors.red,
                icon: const Icon(Icons.stop),
                label: const Text('إنهاء الجلسة رسمياً'),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('إنهاء الجلسة'),
                          content: const Text(
                            'هل أنت متأكد من إنهاء التتبع؟ سيتم إيقاف الجلسة لجميع الحجاج.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('إلغاء'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('تأكيد الإنهاء'),
                            ),
                          ],
                        ),
                  );
                  if (confirm == true) {
                    await ref
                        .read(leaderTrackingControllerProvider.notifier)
                        .stopSessionOfficially();
                    if (context.mounted) {
                      Navigator.of(
                        context,
                      ).popUntil((route) => route.isFirst);
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── بناء ماركر الحاج مع دعم الضغط ──────────────────────────
  Marker _buildPilgrimMarker(PilgrimMarkerData p, Color color) {
    return Marker(
      point: p.location,
      width: 40,
      height: 50,
      child: GestureDetector(
        onTap: () => _showPilgrimInfoSheet(p, color),
        child: Column(
          children: [
            // فقاعة الاسم
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6.r),
                boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 3)],
              ),
              child: Text(
                p.name.length > 8 ? '${p.name.substring(0, 8)}..' : p.name,
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
  void _showPilgrimInfoSheet(PilgrimMarkerData p, Color zoneColor) {
    // دالة مساعدة لتنسيق الوقت
    String _fmt(DateTime dt) {
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      final s = dt.second.toString().padLeft(2, '0');
      return '$h:$m:$s';
    }

    final lastMovedText = _fmt(p.lastSeen);
    final lastHeartbeatText =
        p.lastHeartbeat != null ? _fmt(p.lastHeartbeat!) : '--:--:--';

    // هل الهاتف لا يزال يُرسل نبضات؟ (أقل من دقيقتين)
    final isPhoneOnline = p.lastHeartbeat != null &&
        DateTime.now().difference(p.lastHeartbeat!).inSeconds < 120;

    final distanceText = p.distance < 1000
        ? '${p.distance.toStringAsFixed(1)} متر'
        : '${(p.distance / 1000).toStringAsFixed(2)} كم';

    String zoneLabel;
    IconData zoneIcon;
    if (zoneColor == Colors.teal) {
      zoneLabel = 'داخل النطاق الآمن 🟢';
      zoneIcon = Icons.check_circle;
    } else if (zoneColor == Colors.orange) {
      zoneLabel = 'على حدود النطاق 🟠';
      zoneIcon = Icons.warning_amber_rounded;
    } else {
      zoneLabel = 'خارج النطاق ⚠️ خطر';
      zoneIcon = Icons.dangerous;
    }

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // مقبض
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 16.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),

            // اسم الحاج
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: zoneColor.withOpacity(0.15),
                  radius: 24.r,
                  child: Icon(Icons.person, color: zoneColor, size: 26.r),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(zoneIcon, size: 14.sp, color: zoneColor),
                          SizedBox(width: 4.w),
                          Text(
                            zoneLabel,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: zoneColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // مؤشر اتصال الهاتف
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isPhoneOnline
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isPhoneOnline ? Colors.green : Colors.red,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPhoneOnline ? Icons.wifi : Icons.wifi_off,
                        size: 12.sp,
                        color: isPhoneOnline ? Colors.green : Colors.red,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        isPhoneOnline ? 'متصل' : 'منقطع',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: isPhoneOnline ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.h),
            const Divider(),
            SizedBox(height: 12.h),

            // تفاصيل
            _infoRow(
              Icons.social_distance,
              'المسافة عن المشرف',
              distanceText,
              Colors.blue,
            ),
            SizedBox(height: 12.h),
            _infoRow(
              Icons.directions_walk,
              'آخر تحرك فعلي',
              lastMovedText,
              Colors.teal,
            ),
            SizedBox(height: 12.h),
            _infoRow(
              Icons.phonelink_ring,
              'آخر إشارة هاتف',
              lastHeartbeatText,
              isPhoneOnline ? Colors.green : Colors.red,
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, size: 20.sp, color: color),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 11.sp, color: Colors.grey),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  // ── البطاقة العلوية ───────────────────────────────────────────
  Widget _buildTopCard(
    BuildContext context,
    int totalCount,
    bool isLeaderConnected,
    TrackingState state,
  ) {
    return Row(
      children: [
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
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: isLeaderConnected ? Colors.green : Colors.orange,
                      size: 12,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      isLeaderConnected ? 'متصل' : 'جاري البحث عن موقعك...',
                      style: TextStyle(
                        color:
                            isLeaderConnected ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: isLeaderConnected ? 14.sp : 11.sp,
                      ),
                    ),
                  ],
                ),
                // عداد الحجاج مع ألوان
                Row(
                  children: [
                    if (state.greenPilgrims.isNotEmpty)
                      _pilgrimCount(
                        state.greenPilgrims.length,
                        Colors.teal,
                      ),
                    if (state.yellowPilgrims.isNotEmpty)
                      _pilgrimCount(
                        state.yellowPilgrims.length,
                        Colors.orange,
                      ),
                    if (state.redPilgrims.isNotEmpty)
                      _pilgrimCount(state.redPilgrims.length, Colors.red),
                    if (state.totalPilgrims == 0)
                      Text(
                        'لا يوجد حجاج',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.sp,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _pilgrimCount(int count, Color color) {
    return Container(
      margin: EdgeInsets.only(right: 4.w),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        '$count',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12.sp,
        ),
      ),
    );
  }

  // ── وسيلة الإيضاح ─────────────────────────────────────────────
  Widget _buildLegend() {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLegendItem('داخل النطاق', Colors.teal),
          SizedBox(height: 6.h),
          _buildLegendItem('على الحدود', Colors.orange),
          SizedBox(height: 6.h),
          _buildLegendItem('خارج النطاق', Colors.red),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Row(
      children: [
        Icon(Icons.location_on, color: color, size: 18),
        SizedBox(width: 6.w),
        Text(
          text,
          style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
