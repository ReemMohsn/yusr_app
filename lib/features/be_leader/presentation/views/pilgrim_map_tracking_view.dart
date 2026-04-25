// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:yusr/features/be_leader/providers/pilgrim_tracking_controller.dart';
// import 'package:yusr/features/be_leader/providers/state/pilgrim_tracking_state.dart';

// class PilgrimMapTrackingView extends ConsumerStatefulWidget {
//   final int sessionId;
//   const PilgrimMapTrackingView({super.key, required this.sessionId});

//   @override
//   ConsumerState<PilgrimMapTrackingView> createState() =>
//       _PilgrimMapTrackingViewState();
// }

// class _PilgrimMapTrackingViewState
//     extends ConsumerState<PilgrimMapTrackingView> {
//   final MapController _mapController = MapController();
//   bool _isTracking = true;

//   @override
//   Widget build(BuildContext context) {
//     final mapState = ref.watch(pilgrimTrackingControllerProvider);

//     // إذا كان هناك خطأ، يمكنك عرض رسالة
//     if (mapState.errorMessage != null) {
//       return Scaffold(body: Center(child: Text(mapState.errorMessage!)));
//     }

//     return Scaffold(
//       floatingActionButton: FloatingActionButton.extended(
//         backgroundColor: Colors.grey,
//         icon: const Icon(Icons.exit_to_app),
//         label: const Text('إيقاف التتبع'),
//         onPressed: () async {
//           // يمكنك هنا إضافة منبه تأكيد قبل إيقاف التتبع محلياً
//           ref.read(pilgrimTrackingControllerProvider.notifier).stopTracking();
//           Navigator.pop(context);
//         },
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       body: Stack(
//         children: [
//           // تأكد من وجود موقع الحاج كحد أدنى لعرض الخريطة
//           if (mapState.pilgrimLocation != null)
//             FlutterMap(
//               mapController: _mapController,
//               options: MapOptions(
//                 // يمكنك جعل الخريطة تتمركز على المشرف إذا كان موجوداً، أو الحاج
//                 initialCenter:
//                     mapState.leaderLocation ?? mapState.pilgrimLocation!,
//                 initialZoom: 17.0,
//               ),
//               children: [
//                 TileLayer(
//                   urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                   userAgentPackageName: 'com.yusr.app',
//                 ),

//                 // رسم دوائر النطاق حول موقع "المشرف" (إذا كان موقعه معروفاً)
//                 if (mapState.leaderLocation != null)
//                   CircleLayer(
//                     circles: [
//                       CircleMarker(
//                         point: mapState.leaderLocation!,
//                         color: Colors.blue.withOpacity(0.1),
//                         borderColor: Colors.blue.withOpacity(0.3),
//                         borderStrokeWidth: 1,
//                         radius: 150, // الدائرة الحمراء (خارج هذا النطاق)
//                         useRadiusInMeter: true,
//                       ),
//                       CircleMarker(
//                         point: mapState.leaderLocation!,
//                         color: Colors.transparent,
//                         borderColor: Colors.blue.withOpacity(0.5),
//                         borderStrokeWidth: 1,
//                         radius: 75, // الدائرة الصفراء
//                         useRadiusInMeter: true,
//                       ),
//                     ],
//                   ),

//                 MarkerLayer(
//                   markers: [
//                     // علامة المشرف
//                     if (mapState.leaderLocation != null)
//                       Marker(
//                         point: mapState.leaderLocation!,
//                         width: 80,
//                         height: 80,
//                         child: const Column(
//                           children: [
//                             Icon(Icons.flag, color: Colors.blue, size: 35),
//                             Text(
//                               'المشرف',
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                       ),

//                     // علامة الحاج (موقعك)
//                     Marker(
//                       point: mapState.pilgrimLocation!,
//                       width: 60,
//                       height: 60,
//                       child: Icon(
//                         Icons.person_pin_circle,
//                         color: mapState.statusColor, // يتغير اللون حسب بعدك
//                         size: 40,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),

//           if (!mapState.isLoading)
//             Positioned(
//               top: 55,
//               left: 20,
//               right: 20,
//               child: _buildDistanceCard(context, mapState),
//             ),

//           // Loading Overlay إذا كانت الحالة جاري التحميل (مثل جلب الموقع الأولي)
//           // LoadingOverlay(isLoading: mapState.isLoading),
//         ],
//       ),
//     );
//   }

//   Widget _buildDistanceCard(BuildContext context, PilgrimTrackingState state) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(30.r),
//         boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.circle, color: state.statusColor, size: 12),
//               SizedBox(width: 6.w),
//               Text(
//                 state.statusText,
//                 style: TextStyle(
//                   color: state.statusColor,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 14.sp,
//                 ),
//               ),
//             ],
//           ),
//           Text(
//             'البعد: ${state.distance.toStringAsFixed(1)} متر',
//             style: TextStyle(
//               color: Colors.black87,
//               fontWeight: FontWeight.bold,
//               fontSize: 14.sp,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:yusr/core/common/providers/shared_preferences_service_provider.dart';
import 'package:yusr/core/constants/app_color.dart'; // تأكد من المسار
import 'package:yusr/core/services/shared_preferences_service.dart'; // لجلب بيانات البروفايل
import 'package:yusr/features/be_leader/providers/pilgrim_tracking_controller.dart';
import 'package:yusr/features/be_leader/providers/state/pilgrim_tracking_state.dart';

// class PilgrimMapTrackingView extends ConsumerStatefulWidget {
//   final int sessionId;
//   const PilgrimMapTrackingView({super.key, required this.sessionId});

//   @override
//   ConsumerState<PilgrimMapTrackingView> createState() =>
//       _PilgrimMapTrackingViewState();
// }

// class _PilgrimMapTrackingViewState
//     extends ConsumerState<PilgrimMapTrackingView> {
//   final MapController _mapController = MapController();

// تأكد من بقاء الاستيرادات الخاصة بمشروعك هنا مثل AppColor وغيرها

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

  // دالة لإظهار دايالوج التأكيد
  Future<void> _showStopTrackingDialog(
    BuildContext context,
    String pilgrimId,
  ) async {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
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
              onPressed: () => Navigator.pop(dialogContext), // إغلاق الدايالوج
              child: const Text('تراجع', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                // إغلاق الدايالوج أولاً
                Navigator.pop(dialogContext);

                // استدعاء دالة الإيقاف الشاملة
                await ref
                    .read(pilgrimTrackingControllerProvider.notifier)
                    .leaveAndStopTracking(
                      sessionId: widget.sessionId,
                      pilgrimId: pilgrimId,
                    );

                // العودة للواجهة الرئيسية
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text(
                'نعم، إيقاف',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(pilgrimTrackingControllerProvider);

    // 👈 1. الاستماع للتحذيرات وعرض السناك بار باللون الأحمر ليكون واضحاً كخطأ أو تنبيه
    ref.listen<PilgrimTrackingState>(pilgrimTrackingControllerProvider, (
      previous,
      next,
    ) {
      if (next.gpsWarning != null && next.gpsWarning != previous?.gpsWarning) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.gpsWarning!),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    });

    if (mapState.errorMessage != null) {
      return Scaffold(body: Center(child: Text(mapState.errorMessage!)));
    }

    // تحديد لون ونص الشريط العلوي بناءً على وجود الموقع
    // (إذا الـ GPS مغلق أو انقطع سيصبح pilgrimLocation يساوي null تلقائياً)
    final bool isConnected = mapState.pilgrimLocation != null;
    final Color topBarColor = isConnected ? Colors.green : Colors.orange;
    final String topBarText = isConnected ? 'متصل' : 'جاري جلب الموقع...';

    return Scaffold(
      body: Stack(
        children: [
          // 👈 2. الخريطة تظهر دائماً حتى أثناء جلب الموقع
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              // إذا لم يتوفر موقع المشرف ولا الحاج، نعرض إحداثيات مكة الافتراضية
              initialCenter:
                  mapState.leaderLocation ??
                  mapState.pilgrimLocation ??
                  const LatLng(21.422487, 39.826206),
              initialZoom: 17.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                userAgentPackageName: 'com.yusr.app',
              ),
              if (mapState.leaderLocation != null)
                CircleLayer(
                  circles: [
                    // 👈 3. النطاق التحذيري (البرتقالي) والنطاق الخطر (الأحمر) حول المشرف
                    CircleMarker(
                      point: mapState.leaderLocation!,
                      color: Colors.orange.withOpacity(0.2),
                      borderColor: Colors.orange,
                      borderStrokeWidth: 2,
                      radius: 40, // نطاق التحذير (الأبعد)
                      useRadiusInMeter: true,
                    ),
                    CircleMarker(
                      point: mapState.leaderLocation!,
                      color: Colors.red.withOpacity(0.15),
                      borderColor: Colors.red,
                      borderStrokeWidth: 2,
                      radius: 25, // نطاق الخطر (الأقرب)
                      useRadiusInMeter: true,
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  if (mapState.leaderLocation != null)
                    Marker(
                      point: mapState.leaderLocation!,
                      width: 80,
                      height: 80,
                      child: const Column(
                        children: [
                          Icon(Icons.flag, color: Colors.blue, size: 35),
                          Text(
                            'المشرف',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(blurRadius: 2, color: Colors.black),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  // 👈 إظهار ماركر الحاج فقط إذا كان موقعه معروفاً
                  if (mapState.pilgrimLocation != null)
                    Marker(
                      point: mapState.pilgrimLocation!,
                      width: 60,
                      height: 60,
                      child: Icon(
                        Icons.person_pin_circle,
                        color: mapState.statusColor,
                        size: 40,
                      ),
                    ),
                ],
              ),
            ],
          ),

          // 👈 4. الشريط العلوي (يتغير بين: جاري جلب الموقع / متصل)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: topBarColor,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 5, // احترام النوتش
                bottom: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isConnected)
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  Text(
                    topBarText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // زر العودة
          Positioned.directional(
            textDirection: Directionality.of(context),
            top: 65.h,
            start: 20.w,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 45.h,
                width: 45.h,
                decoration: const BoxDecoration(
                  color: Colors.white, // تم تغييرها للأبيض (أو AppColor.withe)
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.amber, // تم تغييرها للذهبي (أو AppColor.golden)
                  size: 18,
                ),
              ),
            ),
          ),

          // بطاقة المسافة والحالة (تظهر فقط عند الاتصال)
          if (!mapState.isLoading && mapState.pilgrimLocation != null)
            Positioned(
              top: 55.h,
              left: 80.w, // إزاحة لتجنب التداخل مع زر العودة
              right: 20.w,
              child: _buildDistanceCard(context, mapState),
            ),

          // 👈 5. زر تحديد الموقع (التركيز على موقع الحاج)
          Positioned(
            bottom: 100.h, // تم رفعه قليلاً ليكون فوق زر الإيقاف
            right: 20.w,
            child: FloatingActionButton(
              heroTag: 'locate_pilgrim_btn',
              backgroundColor: Colors.white,
              onPressed: () {
                if (mapState.pilgrimLocation != null) {
                  _mapController.move(mapState.pilgrimLocation!, 17.0);
                } else {
                  // تنبيه في حال تم الضغط ولم يتم جلب الموقع بعد
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("جاري جلب موقعك، يرجى الانتظار..."),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
              child: const Icon(Icons.my_location, color: Colors.blue),
            ),
          ),

          // 6. زر إيقاف التتبع (في الأسفل)
          Positioned(
            bottom: 40.h,
            left: 30.w,
            right: 30.w,
            child: FutureBuilder(
              future: ref.read(sharedPreferencesServiceProvider).getProfile(),
              builder: (context, snapshot) {
                final profile = snapshot.data;
                return ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                      side: const BorderSide(color: Colors.red, width: 1.5),
                    ),
                    elevation: 5,
                  ),
                  icon: const Icon(Icons.power_settings_new),
                  label: Text(
                    'إيقاف التتبع',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
        ],
      ),
    );
  }

  Widget _buildDistanceCard(BuildContext context, PilgrimTrackingState state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.circle, color: state.statusColor, size: 12),
              SizedBox(width: 6.w),
              Text(
                state.statusText,
                style: TextStyle(
                  color: state.statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          Text(
            'البعد: ${state.distance.toStringAsFixed(0)} م',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
// class PilgrimMapTrackingView extends ConsumerStatefulWidget {
//   final int sessionId;
//   const PilgrimMapTrackingView({super.key, required this.sessionId});
//   @override
//   ConsumerState<PilgrimMapTrackingView> createState() =>
//       _PilgrimMapTrackingViewState();
// }

// class _PilgrimMapTrackingViewState
//     extends ConsumerState<PilgrimMapTrackingView> {
//   final MapController _mapController = MapController();

//   // دالة لإظهار دايالوج التأكيد
//   Future<void> _showStopTrackingDialog(
//     BuildContext context,
//     String pilgrimId,
//   ) async {
//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15.r),
//           ),
//           title: const Text(
//             'إيقاف التتبع',
//             style: TextStyle(color: Colors.red),
//           ),
//           content: const Text(
//             'هل أنت متأكد أنك تريد إيقاف التتبع والخروج من الجلسة؟ سيتم إشعار المشرف بذلك.',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(dialogContext), // إغلاق الدايالوج
//               child: const Text('تراجع', style: TextStyle(color: Colors.grey)),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//               onPressed: () async {
//                 // إغلاق الدايالوج أولاً
//                 Navigator.pop(dialogContext);

//                 // استدعاء دالة الإيقاف الشاملة
//                 await ref
//                     .read(pilgrimTrackingControllerProvider.notifier)
//                     .leaveAndStopTracking(
//                       sessionId: widget.sessionId,
//                       pilgrimId: pilgrimId,
//                     );

//                 // العودة للواجهة الرئيسية
//                 if (context.mounted) {
//                   Navigator.pop(context);
//                 }
//               },
//               child: const Text(
//                 'نعم، إيقاف',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final mapState = ref.watch(pilgrimTrackingControllerProvider);

//     // 👈 1. الاستماع للتحذيرات وعرض السناك بار
//     ref.listen<PilgrimTrackingState>(pilgrimTrackingControllerProvider, (
//       previous,
//       next,
//     ) {
//       if (next.gpsWarning != null && next.gpsWarning != previous?.gpsWarning) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(next.gpsWarning!),
//             backgroundColor: Colors.orange,
//             duration: const Duration(seconds: 4),
//           ),
//         );
//       }
//     });

//     if (mapState.errorMessage != null) {
//       return Scaffold(body: Center(child: Text(mapState.errorMessage!)));
//     }

//     // تحديد لون ونص الشريط العلوي
//     final bool isConnected = mapState.pilgrimLocation != null;
//     final Color topBarColor = isConnected ? Colors.green : Colors.orange;
//     final String topBarText = isConnected ? 'متصل' : 'جاري جلب الموقع...';

//     return Scaffold(
//       body: Stack(
//         children: [
//           // 👈 2. الخريطة تظهر دائماً (أزلنا شرط if (mapState.pilgrimLocation != null))
//           FlutterMap(
//             mapController: _mapController,
//             options: MapOptions(
//               // إذا لم يتوفر موقع المشرف ولا الحاج، نعرض إحداثيات مكة الافتراضية
//               initialCenter:
//                   mapState.leaderLocation ??
//                   mapState.pilgrimLocation ??
//                   const LatLng(21.422487, 39.826206),
//               initialZoom: 17.0,
//             ),
//             children: [
//               TileLayer(
//                 urlTemplate:
//                     'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
//                 userAgentPackageName: 'com.yusr.app',
//               ),
//               if (mapState.leaderLocation != null)
//                 CircleLayer(
//                   circles: [
//                     CircleMarker(
//                       point: mapState.leaderLocation!,
//                       color: Colors.blue.withOpacity(0.1),
//                       borderColor: Colors.blue.withOpacity(0.3),
//                       borderStrokeWidth: 1,
//                       radius: 150,
//                       useRadiusInMeter: true,
//                     ),
//                     CircleMarker(
//                       point: mapState.leaderLocation!,
//                       color: Colors.transparent,
//                       borderColor: Colors.blue.withOpacity(0.5),
//                       borderStrokeWidth: 1,
//                       radius: 75,
//                       useRadiusInMeter: true,
//                     ),
//                   ],
//                 ),
//               MarkerLayer(
//                 markers: [
//                   if (mapState.leaderLocation != null)
//                     Marker(
//                       point: mapState.leaderLocation!,
//                       width: 80,
//                       height: 80,
//                       child: const Column(
//                         children: [
//                           Icon(Icons.flag, color: Colors.blue, size: 35),
//                           Text(
//                             'المشرف',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                               shadows: [
//                                 Shadow(blurRadius: 2, color: Colors.black),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   // 👈 إظهار ماركر الحاج فقط إذا كان موقعه معروفاً
//                   if (mapState.pilgrimLocation != null)
//                     Marker(
//                       point: mapState.pilgrimLocation!,
//                       width: 60,
//                       height: 60,
//                       child: Icon(
//                         Icons.person_pin_circle,
//                         color: mapState.statusColor,
//                         size: 40,
//                       ),
//                     ),
//                 ],
//               ),
//             ],
//           ),

//           // 👈 3. الشريط العلوي (جاري جلب الموقع / متصل)
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               color: topBarColor,
//               padding: EdgeInsets.only(
//                 top: MediaQuery.of(context).padding.top + 5, // احترام النوتش
//                 bottom: 10,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   if (!isConnected)
//                     const Padding(
//                       padding: EdgeInsets.only(left: 8.0),
//                       child: SizedBox(
//                         width: 15,
//                         height: 15,
//                         child: CircularProgressIndicator(
//                           color: Colors.white,
//                           strokeWidth: 2,
//                         ),
//                       ),
//                     ),
//                   Text(
//                     topBarText,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // زر العودة
//           Positioned.directional(
//             textDirection: Directionality.of(context),
//             top: 65.h, // نزلناه قليلاً لكي لا يتداخل مع الشريط العلوي
//             start: 20.w,
//             child: GestureDetector(
//               onTap: () => Navigator.pop(context),
//               child: Container(
//                 height: 45.h,
//                 width: 45.h,
//                 decoration: const BoxDecoration(
//                   color: AppColor.withe,
//                   shape: BoxShape.circle,
//                   boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
//                 ),
//                 child: const Icon(
//                   Icons.arrow_back_ios_new,
//                   color: AppColor.golden,
//                   size: 18,
//                 ),
//               ),
//             ),
//           ),
//           // @override
//           // Widget build(BuildContext context) {
//           //   final mapState = ref.watch(pilgrimTrackingControllerProvider);

//           //   if (mapState.errorMessage != null) {
//           //     return Scaffold(body: Center(child: Text(mapState.errorMessage!)));
//           //   }

//           //   return Scaffold(
//           //     body: Stack(
//           //       children: [
//           //         // 1. الخريطة بملء الشاشة
//           //         if (mapState.pilgrimLocation != null)
//           //           FlutterMap(
//           //             mapController: _mapController,
//           //             options: MapOptions(
//           //               initialCenter:
//           //                   mapState.leaderLocation ?? mapState.pilgrimLocation!,
//           //               initialZoom: 17.0,
//           //             ),
//           //             children: [
//           //               TileLayer(
//           //                 urlTemplate:
//           //                     'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}', // استخدمت خريطة الـ Satellite كما في الكود الآخر
//           //                 userAgentPackageName: 'com.yusr.app',
//           //               ),
//           //               if (mapState.leaderLocation != null)
//           //                 CircleLayer(
//           //                   circles: [
//           //                     CircleMarker(
//           //                       point: mapState.leaderLocation!,
//           //                       color: Colors.blue.withOpacity(0.1),
//           //                       borderColor: Colors.blue.withOpacity(0.3),
//           //                       borderStrokeWidth: 1,
//           //                       radius: 150,
//           //                       useRadiusInMeter: true,
//           //                     ),
//           //                     CircleMarker(
//           //                       point: mapState.leaderLocation!,
//           //                       color: Colors.transparent,
//           //                       borderColor: Colors.blue.withOpacity(0.5),
//           //                       borderStrokeWidth: 1,
//           //                       radius: 75,
//           //                       useRadiusInMeter: true,
//           //                     ),
//           //                   ],
//           //                 ),
//           //               MarkerLayer(
//           //                 markers: [
//           //                   if (mapState.leaderLocation != null)
//           //                     Marker(
//           //                       point: mapState.leaderLocation!,
//           //                       width: 80,
//           //                       height: 80,
//           //                       child: const Column(
//           //                         children: [
//           //                           Icon(Icons.flag, color: Colors.blue, size: 35),
//           //                           Text(
//           //                             'المشرف',
//           //                             style: TextStyle(
//           //                               fontWeight: FontWeight.bold,
//           //                               color: Colors.white,
//           //                               shadows: [
//           //                                 Shadow(blurRadius: 2, color: Colors.black),
//           //                               ],
//           //                             ),
//           //                           ),
//           //                         ],
//           //                       ),
//           //                     ),
//           //                   Marker(
//           //                     point: mapState.pilgrimLocation!,
//           //                     width: 60,
//           //                     height: 60,
//           //                     child: Icon(
//           //                       Icons.person_pin_circle,
//           //                       color: mapState.statusColor,
//           //                       size: 40,
//           //                     ),
//           //                   ),
//           //                 ],
//           //               ),
//           //             ],
//           //           ),

//           //         // 2. زر العودة المخصص (في الأعلى)
//           //         Positioned.directional(
//           //           textDirection: Directionality.of(context),
//           //           top: 55.h,
//           //           start: 20.w,
//           //           child: GestureDetector(
//           //             onTap: () =>
//           //                 Navigator.pop(context), // يعود للخلف دون إيقاف التتبع
//           //             child: Container(
//           //               height: 45.h,
//           //               width: 45.h,
//           //               decoration: const BoxDecoration(
//           //                 color: AppColor.withe,
//           //                 shape: BoxShape.circle,
//           //                 boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
//           //               ),
//           //               child: const Icon(
//           //                 Icons.arrow_back_ios_new,
//           //                 color: AppColor.golden,
//           //                 size: 18,
//           //               ),
//           //             ),
//           //           ),
//           //         ),

//           // 3. بطاقة المسافة والحالة (في الأعلى بالمنتصف)
//           if (!mapState.isLoading && mapState.pilgrimLocation != null)
//             Positioned(
//               top: 55.h,
//               left: 80.w, // إزاحة لتجنب زر العودة
//               right: 20.w,
//               child: _buildDistanceCard(context, mapState),
//             ),

//           // 4. زر إيقاف التتبع (في الأسفل)
//           Positioned(
//             bottom: 40.h,
//             left: 30.w,
//             right: 30.w,
//             child: FutureBuilder(
//               // نجلب بيانات الحاج (Pilgrim Id) لكي نرسلها في دالة الحذف
//               future: ref.read(sharedPreferencesServiceProvider).getProfile(),
//               builder: (context, snapshot) {
//                 final profile = snapshot.data;
//                 return ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     foregroundColor: Colors.red,
//                     padding: EdgeInsets.symmetric(vertical: 14.h),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30.r),
//                       side: const BorderSide(color: Colors.red, width: 1.5),
//                     ),
//                     elevation: 5,
//                   ),
//                   icon: const Icon(Icons.power_settings_new),
//                   label: Text(
//                     'إيقاف التتبع',
//                     style: TextStyle(
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   onPressed: () {
//                     if (profile?.userId != null) {
//                       _showStopTrackingDialog(
//                         context,
//                         profile!.userId.toString(),
//                       );
//                     }
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDistanceCard(BuildContext context, PilgrimTrackingState state) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.9),
//         borderRadius: BorderRadius.circular(30.r),
//         boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.circle, color: state.statusColor, size: 12),
//               SizedBox(width: 6.w),
//               Text(
//                 state.statusText,
//                 style: TextStyle(
//                   color: state.statusColor,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 12.sp,
//                 ),
//               ),
//             ],
//           ),
//           Text(
//             'البعد: ${state.distance.toStringAsFixed(0)} م',
//             style: TextStyle(
//               color: Colors.black87,
//               fontWeight: FontWeight.bold,
//               fontSize: 12.sp,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
