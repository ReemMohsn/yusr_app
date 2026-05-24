// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:yusr/features/return_to_compaign_location/presentation/widgets/loading_overlay_widget.dart';
// import 'package:yusr/features/return_to_compaign_location/presentation/widgets/tracking_fab_widget.dart';
// import '../widgets/map_overlay_widgets.dart';
// import '../widgets/route_map_widget.dart';
// import '../../providers/map_logic_controller.dart';
// import '../../providers/fetch_camp_location_controller.dart';

// class ReturnMeMapView extends ConsumerStatefulWidget {
//   const ReturnMeMapView({super.key});

//   @override
//   ConsumerState<ReturnMeMapView> createState() => _ReturnMeMapViewState();
// }

// class _ReturnMeMapViewState extends ConsumerState<ReturnMeMapView> {
//   final MapController _mapController = MapController();

//   @override
//   Widget build(BuildContext context) {
//     final mapState = ref.watch(mapLogicControllerProvider);
//     final campLocationAsync = ref.watch(fetchCampLocationControllerProvider);

//     ref.listen(fetchCampLocationControllerProvider, (previous, next) {
//       next.whenData((response) {
//         if (response != null && response.data != null) {
//           ref
//               .read(mapLogicControllerProvider.notifier)
//               .initializeTracking(_mapController, response.data!);
//         }
//       });
//     });

//     return Scaffold(
//       body: Stack(
//         children: [
//           // الخريطة
//           RouteMapWidget(
//             campaignLocation: mapState.targetLocation,
//             userLocation: mapState.userLocation,
//             routePoints: mapState.routePoints,
//             mapController: _mapController,
//           ),

//           // مؤشر التحميل
//           LoadingOverlay(
//             isLoading:
//                 campLocationAsync.isLoading || mapState.targetLocation == null,
//           ),

//           // زر التتبع
//           TrackingFAB(
//             isTracking: mapState.isTracking,
//             onPressed: () =>
//                 ref.read(mapLogicControllerProvider.notifier).toggleTracking(),
//           ),

//           // واجهة المعلومات والسهم
//           MapOverlayUI(
//             distance: mapState.distance.toStringAsFixed(2),
//             heading: mapState.heading,
//           ),
//         ],
//       ),
//     );
//   }
// }

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
  const ReturnMeMapView({super.key});

  @override
  ConsumerState<ReturnMeMapView> createState() => _ReturnMeMapViewState();
}

class _ReturnMeMapViewState extends ConsumerState<ReturnMeMapView> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    // initState هو المكان الصحيح — يُنفَّذ مرة واحدة فقط
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as ActiveLocationModel?;
      if (args != null) {
        ref
            .read(mapLogicControllerProvider.notifier)
            .initializeTracking(_mapController, args);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapLogicControllerProvider);

    return Scaffold(
      body: Stack(
        children: [
          // الخريطة تظهر فقط بعد وصول إحداثيات الحملة (targetLocation != null)
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

          // Loading يغطي الشاشة كاملاً حتى تصل البيانات
          LoadingOverlay(isLoading: mapState.targetLocation == null),
        ],
      ),
    );
  }
}
