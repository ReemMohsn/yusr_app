import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:yusr/core/constants/app_color.dart'; // تأكدي من استيراد المكونات التي أنشأتيهاi
import 'package:yusr/features/be_leader/providers/leader_tracking_controller.dart';
import 'package:yusr/features/be_leader/providers/state/pilgrim_marker_data.dart';
import 'package:yusr/features/be_leader/providers/state/tracking_state.dart'
    hide TrackingState;
import 'package:yusr/features/return_to_compaign_location/presentation/widgets/loading_overlay_widget.dart';
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
            backgroundColor: Colors.orange, // لون تحذيري
            duration: const Duration(seconds: 4),
          ),
        );
      }
    });
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'stop_session_unique_tag', // 👈 أضف هذا السطر هنا!
        backgroundColor: Colors.red,
        icon: const Icon(Icons.stop),
        label: const Text('إنهاء الجلسة رسمياً'),
        onPressed: () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
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
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // 3. بناء الخريطة
      // 3. بناء الخريطة
      body: Stack(
        children: [
          // 🌟 الخريطة ظاهرة دائماً!
          // إذا كان موقع المشرف موجوداً نركز عليه، وإلا نركز على إحداثيات مكة الافتراضية
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter:
                  mapState.leaderLocation ??
                  const LatLng(21.422487, 39.826206), // إحداثيات مكة كبديل
              initialZoom: 17.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.yusr.app',
              ),

              // 🌟 دوائر نطاق المشرف تظهر فقط إذا كان موقعه متوفراً
              if (mapState.leaderLocation != null)
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: mapState.leaderLocation!,
                      color: Colors.blue.withOpacity(0.1),
                      borderColor: Colors.blue.withOpacity(0.3),
                      borderStrokeWidth: 1,
                      radius: 40, // الدائرة الحمراء
                      useRadiusInMeter: true,
                    ),
                    CircleMarker(
                      point: mapState.leaderLocation!,
                      color: Colors.transparent,
                      borderColor: Colors.blue.withOpacity(0.5),
                      borderStrokeWidth: 1,
                      radius: 25, // الدائرة الصفراء
                      useRadiusInMeter: true,
                    ),
                  ],
                ),

              // 🌟 علامة المشرف (أنت هنا) والحجاج
              MarkerLayer(
                markers: [
                  if (mapState.leaderLocation != null)
                    Marker(
                      point: mapState.leaderLocation!,
                      width: 80,
                      height: 80,
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
                              'أنت هنا',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.circle,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ],
                      ),
                    ),

                  // علامات الحجاج (إذا كان متوفرين)
                  ...mapState.greenPilgrims.map(
                    (p) => _buildPilgrimMarker(p, Colors.teal),
                  ),
                  ...mapState.yellowPilgrims.map(
                    (p) => _buildPilgrimMarker(p, Colors.amber),
                  ),
                  ...mapState.redPilgrims.map(
                    (p) => _buildPilgrimMarker(p, Colors.red),
                  ),
                ],
              ),
            ],
          ),

          // 🌟 البطاقة العلوية ظاهرة دائماً وتتغير حالتها
          Positioned(
            top: 55,
            left: 20,
            right: 20,
            child: _buildTopCard(
              context,
              mapState.totalPilgrims,
              // 💡 [التعديل هنا] هو متصل فقط إذا كان لديه موقع ولا يوجد تحذير GPS
              mapState.leaderLocation != null && mapState.gpsWarning == null,
            ),
          ),
          Positioned(bottom: 90, right: 20, child: _buildLegend()),

          // 🌟 زر تتبع الكاميرا
          TrackingFAB(
            isTracking: _isTracking,
            onPressed: () {
              setState(() => _isTracking = !_isTracking);
              // نتحرك لموقع المشرف فقط إذا كان موجوداً
              if (mapState.leaderLocation != null) {
                _mapController.move(mapState.leaderLocation!, 17.0);
              } else {
                // إشعار لطيف إذا حاول تتبع نفسه وهو غير متصل
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('جاري تحديد موقعك، يرجى الانتظار...'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Marker _buildPilgrimMarker(PilgrimMarkerData p, Color color) {
    return Marker(
      point: p.location,
      width: 30,
      height: 30,
      child: Icon(Icons.location_on, color: color, size: 30),
      // ملاحظة: أخفينا اسم الحاج والمسافة كما طلبتِ لمنع الزحمة
    );
  }

  Widget _buildTopCard(
    BuildContext context,
    int totalCount,
    bool isLeaderConnected,
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
                    // 🌟 تغيير اللون والدايمنكس بناءً على حالة الاتصال
                    Icon(
                      Icons.circle,
                      color: isLeaderConnected ? Colors.green : Colors.orange,
                      size: 12,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      isLeaderConnected ? 'متصل' : 'جاري البحث عن موقعك...',
                      style: TextStyle(
                        color: isLeaderConnected ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: isLeaderConnected
                            ? 14.sp
                            : 11.sp, // تصغير الخط قليلاً إذا كان النص طويلاً
                      ),
                    ),
                  ],
                ),
                Text(
                  'الحجاج: $totalCount',
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLegendItem('حاج داخل النطاق', Colors.teal),
          SizedBox(height: 8.h),
          _buildLegendItem('حاج على حدود النطاق', Colors.amber),
          SizedBox(height: 8.h),
          _buildLegendItem('حاج خارج النطاق', Colors.red),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Row(
      children: [
        Icon(Icons.location_on, color: color, size: 20),
        SizedBox(width: 8.w),
        Text(
          text,
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
