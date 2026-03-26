import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';

class LeaderMapTrackingView extends ConsumerStatefulWidget {
  const LeaderMapTrackingView({super.key});

  @override
  ConsumerState<LeaderMapTrackingView> createState() =>
      _LeaderMapTrackingViewState();
}

class _LeaderMapTrackingViewState extends ConsumerState<LeaderMapTrackingView> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    // إحداثيات وهمية للتجربة (ستأتي من Riverpod لاحقاً)
    final LatLng leaderLocation = const LatLng(21.422487, 39.826206);
    final List<LatLng> greenPilgrims = [const LatLng(21.422500, 39.826300)];
    final List<LatLng> yellowPilgrims = [const LatLng(21.422800, 39.826800)];
    final List<LatLng> redPilgrims = [const LatLng(21.423500, 39.827500)];

    return Scaffold(
      body: Stack(
        children: [
          // 1. الخريطة الأساسية
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: leaderLocation,
              initialZoom: 16.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.yusr.app',
              ),

              // 2. دوائر النطاق (كما في الصورة الثالثة)
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: leaderLocation,
                    color: Colors.blue.withOpacity(0.1),
                    borderColor: Colors.blue.withOpacity(0.3),
                    borderStrokeWidth: 1,
                    radius: 150, // الدائرة الأكبر
                    useRadiusInMeter: true,
                  ),
                  CircleMarker(
                    point: leaderLocation,
                    color: Colors.transparent,
                    borderColor: Colors.blue.withOpacity(0.5),
                    borderStrokeWidth: 1,
                    radius: 75, // الدائرة الأصغر
                    useRadiusInMeter: true,
                  ),
                ],
              ),

              // 3. علامات الحجاج والمشرف
              MarkerLayer(
                markers: [
                  // ماركر المشرف (أنت هنا)
                  Marker(
                    point: leaderLocation,
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
                        const Icon(Icons.circle, color: Colors.blue, size: 20),
                      ],
                    ),
                  ),
                  // ماركرز الحجاج (حسب اللون)
                  ...greenPilgrims.map(
                    (p) => _buildPilgrimMarker(p, Colors.teal),
                  ),
                  ...yellowPilgrims.map(
                    (p) => _buildPilgrimMarker(p, Colors.amber),
                  ),
                  ...redPilgrims.map((p) => _buildPilgrimMarker(p, Colors.red)),
                ],
              ),
            ],
          ),

          // 4. كرت الاتصال العائم أعلى الخريطة (الذي طلبته)
          Positioned(
            top: 55.h,
            left: 20.w,
            right: 20.w,
            child: Row(
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
                // كرت الحالة
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
                        Row(
                          children: [
                            const Icon(
                              Icons.circle,
                              color: Colors.green,
                              size: 12,
                            ),
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
                          'عدد المتصلين: 18',
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
            ),
          ),

          // 5. مفتاح الخريطة (Legend) أسفل اليمين كما في الصورة
          Positioned(
            bottom: 30.h,
            right: 20.w,
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 5),
                ],
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
            ),
          ),
        ],
      ),
    );
  }

  // دالة مساعدة لرسم ماركر الحاج
  Marker _buildPilgrimMarker(LatLng point, Color color) {
    return Marker(
      point: point,
      width: 30,
      height: 30,
      child: Icon(Icons.location_on, color: color, size: 30),
    );
  }

  // دالة مساعدة لرسم مفتاح الخريطة
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
