import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:yusr/features/return_to_compaign_location/data/models/active_location_model.dart';
import 'package:yusr/features/return_to_compaign_location/presentation/widgets/loading_overlay_widget.dart';
import 'package:yusr/features/return_to_compaign_location/presentation/widgets/tracking_fab_widget.dart';
import '../widgets/map_overlay_widgets.dart';
import '../widgets/route_map_widget.dart';
import '../../providers/map_logic_controller.dart';

class ReturnMeMapView extends ConsumerStatefulWidget {
  final ActiveLocationModel location;
  const ReturnMeMapView({super.key, required this.location});

  @override
  ConsumerState<ReturnMeMapView> createState() => _ReturnMeMapViewState();
}

class _ReturnMeMapViewState extends ConsumerState<ReturnMeMapView> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(mapLogicControllerProvider.notifier)
          .initializeTracking(_mapController, widget.location);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapLogicControllerProvider);

    return Scaffold(
      body: Stack(
        children: [
          if (mapState.targetLocation != null) ...[
            RouteMapWidget(
              campaignLocation: mapState.targetLocation!,
              userLocation: mapState.userLocation,
              routePoints: mapState.routePoints,
              mapController: _mapController,
            ),
            TrackingFAB(
              isTracking: mapState.isTracking,
              onPressed: () => ref
                  .read(mapLogicControllerProvider.notifier)
                  .toggleTracking(),
            ),
            MapOverlayUI(
              distance: mapState.distance.toStringAsFixed(2),
              heading: mapState.heading,
            ),
          ],
          LoadingOverlay(isLoading: mapState.isLoading),
        ],
      ),
    );
  }
}
