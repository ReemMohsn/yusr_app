import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:yusr/features/return_to_compaign_location/presentation/widgets/loading_overlay_widget.dart';
import 'package:yusr/features/return_to_compaign_location/presentation/widgets/tracking_fab_widget.dart';
import '../widgets/map_overlay_widgets.dart';
import '../widgets/route_map_widget.dart';
import '../../providers/map_logic_controller.dart';
import '../../providers/fetch_camp_location_controller.dart';

class ReturnMeMapView extends ConsumerStatefulWidget {
  const ReturnMeMapView({super.key});

  @override
  ConsumerState<ReturnMeMapView> createState() => _ReturnMeMapViewState();
}

class _ReturnMeMapViewState extends ConsumerState<ReturnMeMapView> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapLogicControllerProvider);
    final campLocationAsync = ref.watch(fetchCampLocationControllerProvider);

    ref.listen(fetchCampLocationControllerProvider, (previous, next) {
      next.whenData((response) {
        if (response.data != null) {
          ref
              .read(mapLogicControllerProvider.notifier)
              .initializeTracking(_mapController, response.data!);
        }
      });
    });

    return Scaffold(
      body: Stack(
        children: [
          // الخريطة
          RouteMapWidget(
            campaignLocation: mapState.targetLocation,
            userLocation: mapState.userLocation,
            routePoints: mapState.routePoints,
            mapController: _mapController,
          ),

          // مؤشر التحميل
          LoadingOverlay(
            isLoading:
                campLocationAsync.isLoading,
          ),

          // زر التتبع
          TrackingFAB(
            isTracking: mapState.isTracking,
            onPressed: () =>
                ref.read(mapLogicControllerProvider.notifier).toggleTracking(),
          ),

          // واجهة المعلومات والسهم
          MapOverlayUI(
            distance: mapState.distance.toStringAsFixed(2),
            heading: mapState.heading,
          ),
        ],
      ),
    );
  }
}
