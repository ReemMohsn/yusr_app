// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:yusr/core/constants/app_color.dart';

// class LeaderMapTrackingView extends ConsumerStatefulWidget {
//   const LeaderMapTrackingView({super.key});

//   @override
//   ConsumerState<LeaderMapTrackingView> createState() =>
//       _LeaderMapTrackingViewState();
// }

// class _LeaderMapTrackingViewState extends ConsumerState<LeaderMapTrackingView> {
//   final MapController _mapController = MapController();

//   @override
//   Widget build(BuildContext context) {
//     // إحداثيات وهمية للتجربة (ستأتي من Riverpod لاحقاً)
//     final LatLng leaderLocation = const LatLng(21.422487, 39.826206);
//     final List<LatLng> greenPilgrims = [const LatLng(21.422500, 39.826300)];
//     final List<LatLng> yellowPilgrims = [const LatLng(21.422800, 39.826800)];
//     final List<LatLng> redPilgrims = [const LatLng(21.423500, 39.827500)];

//     return Scaffold(
//       body: Stack(
//         children: [
//           // 1. الخريطة الأساسية
//           FlutterMap(
//             mapController: _mapController,
//             options: MapOptions(
//               initialCenter: leaderLocation,
//               initialZoom: 16.0,
//             ),
//             children: [
//               TileLayer(
//                 urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                 userAgentPackageName: 'com.yusr.app',
//               ),

//               // 2. دوائر النطاق (كما في الصورة الثالثة)
//               CircleLayer(
//                 circles: [
//                   CircleMarker(
//                     point: leaderLocation,
//                     color: Colors.blue.withOpacity(0.1),
//                     borderColor: Colors.blue.withOpacity(0.3),
//                     borderStrokeWidth: 1,
//                     radius: 150, // الدائرة الأكبر
//                     useRadiusInMeter: true,
//                   ),
//                   CircleMarker(
//                     point: leaderLocation,
//                     color: Colors.transparent,
//                     borderColor: Colors.blue.withOpacity(0.5),
//                     borderStrokeWidth: 1,
//                     radius: 75, // الدائرة الأصغر
//                     useRadiusInMeter: true,
//                   ),
//                 ],
//               ),

//               // 3. علامات الحجاج والمشرف
//               MarkerLayer(
//                 markers: [
//                   // ماركر المشرف (أنت هنا)
//                   Marker(
//                     point: leaderLocation,
//                     width: 80,
//                     height: 80,
//                     child: Column(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 8.w,
//                             vertical: 2.h,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(10.r),
//                             boxShadow: const [
//                               BoxShadow(color: Colors.black12, blurRadius: 4),
//                             ],
//                           ),
//                           child: Text(
//                             'أنت هنا',
//                             style: TextStyle(
//                               fontSize: 10.sp,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         const Icon(Icons.circle, color: Colors.blue, size: 20),
//                       ],
//                     ),
//                   ),
//                   // ماركرز الحجاج (حسب اللون)
//                   ...greenPilgrims.map(
//                     (p) => _buildPilgrimMarker(p, Colors.teal),
//                   ),
//                   ...yellowPilgrims.map(
//                     (p) => _buildPilgrimMarker(p, Colors.amber),
//                   ),
//                   ...redPilgrims.map((p) => _buildPilgrimMarker(p, Colors.red)),
//                 ],
//               ),
//             ],
//           ),

//           // 4. كرت الاتصال العائم أعلى الخريطة (الذي طلبته)
//           Positioned(
//             top: 55.h,
//             left: 20.w,
//             right: 20.w,
//             child: Row(
//               children: [
//                 // زر الرجوع
//                 GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child: Container(
//                     height: 45.h,
//                     width: 45.h,
//                     decoration: const BoxDecoration(
//                       color: Colors.white,
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Icons.arrow_back_ios_new,
//                       color: AppColor.golden,
//                       size: 18,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 10.w),
//                 // كرت الحالة
//                 Expanded(
//                   child: Container(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 16.w,
//                       vertical: 12.h,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(30.r),
//                       boxShadow: const [
//                         BoxShadow(color: Colors.black12, blurRadius: 5),
//                       ],
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             const Icon(
//                               Icons.circle,
//                               color: Colors.green,
//                               size: 12,
//                             ),
//                             SizedBox(width: 6.w),
//                             Text(
//                               'متصل',
//                               style: TextStyle(
//                                 color: Colors.green,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 14.sp,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Text(
//                           'عدد المتصلين: 18',
//                           style: TextStyle(
//                             color: Colors.blue[800],
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14.sp,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // 5. مفتاح الخريطة (Legend) أسفل اليمين كما في الصورة
//           Positioned(
//             bottom: 30.h,
//             right: 20.w,
//             child: Container(
//               padding: EdgeInsets.all(10.w),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12.r),
//                 boxShadow: const [
//                   BoxShadow(color: Colors.black12, blurRadius: 5),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildLegendItem('حاج داخل النطاق', Colors.teal),
//                   SizedBox(height: 8.h),
//                   _buildLegendItem('حاج على حدود النطاق', Colors.amber),
//                   SizedBox(height: 8.h),
//                   _buildLegendItem('حاج خارج النطاق', Colors.red),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // دالة مساعدة لرسم ماركر الحاج
//   Marker _buildPilgrimMarker(LatLng point, Color color) {
//     return Marker(
//       point: point,
//       width: 30,
//       height: 30,
//       child: Icon(Icons.location_on, color: color, size: 30),
//     );
//   }

//   // دالة مساعدة لرسم مفتاح الخريطة
//   Widget _buildLegendItem(String text, Color color) {
//     return Row(
//       children: [
//         Icon(Icons.location_on, color: color, size: 20),
//         SizedBox(width: 8.w),
//         Text(
//           text,
//           style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
//         ),
//       ],
//     );
//   }
// }

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart'; // تأكدي من استيراد المكونات التي أنشأتيهاi
import 'package:yusr/features/be_leader/providers/leader_map_controller.dart';
import 'package:yusr/features/be_leader/providers/state/leader_map_state.dart';
import 'package:yusr/features/be_leader/providers/state/pilgrim_marker_data.dart';
import 'package:yusr/features/return_to_compaign_location/presentation/widgets/loading_overlay_widget.dart';
import 'package:yusr/features/return_to_compaign_location/presentation/widgets/tracking_fab_widget.dart';
import 'package:vibration/vibration.dart';

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
  // 1. تعريف مشغل الصوت
  final AudioPlayer _audioPlayer = AudioPlayer();
  @override
  void dispose() {
    _audioPlayer.dispose(); // مهم لتنظيف الذاكرة
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 3. الاستماع السحري للأحداث الطارئة (بدون إعادة بناء الشاشة)
    ref.listen<LeaderMapState>(leaderMapControllerProvider(widget.sessionId), (
      previous,
      next,
    ) {
      // إذا كان هناك حدث جديد، ومختلف عن السابق
      if (next.currentAlert != null &&
          next.currentAlert != previous?.currentAlert) {
        if (next.currentAlert!.alertType == 'red') {
          _triggerEmergency(next.currentAlert!.pilgrimName);
        } else if (next.currentAlert!.alertType == 'yellow') {
          // للون الأصفر نكتفي بـ SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '⚠️ تحذير: الحاج ${next.currentAlert!.pilgrimName} يقترب من الحدود!',
              ),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    });
    // 1. مراقبة حالة الخريطة من الكنترولر
    final mapState = ref.watch(leaderMapControllerProvider(widget.sessionId));

    return Scaffold(
      body: Stack(
        children: [
          // 2. الخريطة (لا تظهر إلا إذا كان هناك موقع للمشرف)
          if (mapState.leaderLocation != null)
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: mapState.leaderLocation!,
                initialZoom: 17.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.yusr.app',
                ),

                // دوائر النطاق
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: mapState.leaderLocation!,
                      color: Colors.blue.withOpacity(0.1),
                      borderColor: Colors.blue.withOpacity(0.3),
                      borderStrokeWidth: 1,
                      radius: 150, // الدائرة الأكبر (حدود الإنذار)
                      useRadiusInMeter: true,
                    ),
                    CircleMarker(
                      point: mapState.leaderLocation!,
                      color: Colors.transparent,
                      borderColor: Colors.blue.withOpacity(0.5),
                      borderStrokeWidth: 1,
                      radius: 75, // الدائرة الأصغر (حدود التحذير)
                      useRadiusInMeter: true,
                    ),
                  ],
                ),

                // علامات الحجاج والمشرف
                MarkerLayer(
                  markers: [
                    // ماركر المشرف
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
                    // رسم الحجاج حسب ألوانهم من الكنترولر
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

          // 3. كرت الاتصال أعلى الشاشة
          if (!mapState.isLoading)
            Positioned(
              top: 55.h,
              left: 20.w,
              right: 20.w,
              child: _buildTopCard(context, mapState.totalPilgrims),
            ),

          // 4. مفتاح الخريطة أسفل اليمين
          if (!mapState.isLoading)
            Positioned(bottom: 30.h, right: 20.w, child: _buildLegend()),

          // 5. زر إعادة التوجيه (من مكوناتك الجاهزة)
          if (!mapState.isLoading)
            TrackingFAB(
              isTracking: _isTracking,
              onPressed: () {
                setState(() => _isTracking = !_isTracking);
                if (mapState.leaderLocation != null) {
                  _mapController.move(mapState.leaderLocation!, 17.0);
                }
              },
            ),

          // 6. واجهة التحميل (من مكوناتك الجاهزة)
          LoadingOverlay(isLoading: mapState.isLoading),
        ],
      ),
    );
  }

  // 2. دالة إظهار الإنذار الإجباري (Persistent Dialog)
  Future<void> _triggerEmergency(String pilgrimName) async {
    // أ. تشغيل الاهتزاز (إذا كان الجهاز يدعمه)
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(
        pattern: [500, 1000, 500, 1000, 500, 1000],
        repeat: 1,
      ); // اهتزاز مستمر
    }

    // ب. تشغيل صوت الإنذار بشكل متكرر (Loop)
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('sounds/alarm.mp3'));

    // ج. إرسال إشعار محلي (إذا كان التطبيق في الخلفية)
    _showLocalNotification(pilgrimName);

    // د. إظهار النافذة الإجبارية
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false, // 🚨 يمنع الإغلاق بالضغط خارج النافذة
      builder: (context) {
        return PopScope(
          canPop: false, // 🚨 يمنع الإغلاق باستخدام زر الرجوع في الأندرويد
          child: AlertDialog(
            backgroundColor: Colors.red.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(color: Colors.red, width: 2),
            ),
            title: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red, size: 40),
                SizedBox(width: 10),
                Text(
                  'إنذار طوارئ!',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Text(
              'الحاج "$pilgrimName" خرج عن النطاق الآمن المسموح به! الرجاء اتخاذ إجراء فوراً.',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  // إيقاف الإنذار والاهتزاز
                  _audioPlayer.stop();
                  Vibration.cancel();
                  Navigator.of(context).pop(); // إغلاق النافذة

                  // TODO: يمكن هنا توجيه الكاميرا لموقع الحاج المفقود
                },
                child: const Text(
                  'علمت بذلك (إيقاف الإنذار)',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // دالة الإشعار المحلي (تعمل حتى لو التطبيق في الخلفية)
  void _showLocalNotification(String pilgrimName) {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'emergency_channel',
          'طوارئ الحجاج',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    flutterLocalNotificationsPlugin.show(
      0,
      '🚨 إنذار خطر!',
      'الحاج $pilgrimName خرج عن النطاق المسموح!',
      platformChannelSpecifics,
    );
  }
  // --- دوال مساعدة لرسم الـ UI ---

  Marker _buildPilgrimMarker(PilgrimMarkerData p, Color color) {
    return Marker(
      point: p.location,
      width: 30,
      height: 30,
      child: Icon(Icons.location_on, color: color, size: 30),
      // ملاحظة: أخفينا اسم الحاج والمسافة كما طلبتِ لمنع الزحمة
    );
  }

  Widget _buildTopCard(BuildContext context, int totalCount) {
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
                    const Icon(Icons.circle, color: Colors.green, size: 12),
                    SizedBox(width: 6.w),
                    Text(
                      'متصل',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
                Text(
                  'عدد المتصلين: $totalCount',
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
