import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/features/return_to_compaign_location/presentation/widgets/map_overlay_widgets.dart';
import '../widgets/route_map_widget.dart';
import '../../providers/camp_location_provider.dart';
import '../../providers/map_logic_provider.dart';

class ReturnMeMapView extends ConsumerStatefulWidget {
  const ReturnMeMapView({super.key});

  @override
  ConsumerState<ReturnMeMapView> createState() => _ReturnMeMapViewState();
}

class _ReturnMeMapViewState extends ConsumerState<ReturnMeMapView> {
  final MapController _mapController = MapController();
  bool _isInitialized = false;

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapLogicProvider);
    final campLocationAsync = ref.watch(fetchCampLocationProvider);

    return Scaffold(
      body: campLocationAsync.when(
        data: (campData) {
          // الإحداثيات المطلوبة من الصورة التي أرفقتها
          final target = campData != null 
              ? LatLng(campData.latitude, campData.longitude) 
              : const LatLng(14.505827, 49.059875); 

          // بدء التتبع لمرة واحدة عند توفر البيانات
          if (!_isInitialized) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(mapLogicProvider.notifier).startLocationTracking(_mapController, target);
            });
            _isInitialized = true;
          }

          return Stack(
            children: [
              RouteMapWidget(
                campaignLocation: target,
                userLocation: mapState.userLocation,
                routePoints: mapState.routePoints,
                mapController: _mapController,
              ),

              Positioned(
                bottom: 110.h,
                right: 20.w,
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: AppColor.withe,
                  onPressed: () => ref.read(mapLogicProvider.notifier).toggleTracking(),
                  child: Icon(
                    mapState.isTracking ? Icons.explore : Icons.explore_off,
                    color: AppColor.golden,
                  ),
                ),
              ),

              MapOverlayUI(distance: mapState.distance, heading: mapState.heading),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),
    );
  }
}