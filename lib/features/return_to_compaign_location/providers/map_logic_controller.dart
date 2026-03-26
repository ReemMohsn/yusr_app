import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../../core/common/providers/location_service.dart';
import 'state/map_state.dart';
import 'return_to_campaign_repository_provider.dart';
import 'package:yusr/features/return_to_compaign_location/data/models/active_location_model.dart';

part 'map_logic_controller.g.dart';

@riverpod
class MapLogicController extends _$MapLogicController {
  StreamSubscription? _gpsSub;
  StreamSubscription? _compassSub;

  @override
  MapState build() {
    ref.onDispose(() {
      _gpsSub?.cancel();
      _compassSub?.cancel();
    });
    return const MapState();
  }

  void initializeTracking(MapController controller, ActiveLocationModel data) {
    final target = LatLng(
      double.parse(data.latitude.toString()),
      double.parse(data.longitude.toString()),
    );

    state = state.copyWith(targetLocation: target, isTracking: true);
    controller.move(target, 15.0);
    _startListeners(controller);
  }

  void _startListeners(MapController controller) async {
    final service = ref.read(locationServiceProvider);

    final permission = await service.requestPermission();

    if (!ref.mounted) return;

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      //  الاستماع للبوصلة (اتجاه الهاتف)
      _compassSub = service.compassStream?.listen((event) {
        if (!ref.mounted) return;

        if (state.isTracking) {
          state = state.copyWith(heading: event.heading ?? 0.0);
          // تدوير الخريطة لتناسب اتجاه نظر المستخدم
          controller.rotate(-(event.heading ?? 0.0));
        }
      });

      //  الاستماع للموقع (GPS)
      _gpsSub = service.positionStream.listen((position) {
        if (!ref.mounted) return;

        if (state.isTracking && state.targetLocation != null) {
          final userPos = LatLng(position.latitude, position.longitude);
          _updateProgress(userPos);
        }
      });
    }
  }

  void _updateProgress(LatLng userPos) {
    final dist = Geolocator.distanceBetween(
      userPos.latitude,
      userPos.longitude,
      state.targetLocation!.latitude,
      state.targetLocation!.longitude,
    );

    // تحديث الموقع الحالي والمسافة المتبقية بالكيلومتر
    state = state.copyWith(userLocation: userPos, distance: dist / 1000);

    // تحديث رسم المسار على الخريطة
    updateRoute(userPos: userPos, targetPos: state.targetLocation);
  }

  Future<void> updateRoute({
    required LatLng userPos,
    required LatLng? targetPos,
  }) async {
    if (targetPos == null) return;
    final repo = ref.read(returnToCampaignRepositoryProvider);
    final routeData = await repo.getRoute(start: userPos, target: targetPos);

    if (!ref.mounted) return;

    if (routeData != null && routeData['features'] != null) {
      final List<dynamic> coords =
          routeData['features'][0]['geometry']['coordinates'];
      final apiPoints = coords
          .map((c) => LatLng(c[1] as double, c[0] as double))
          .toList();

      state = state.copyWith(
        routePoints: [userPos, ...apiPoints, targetPos],
        isLoading: false,
      );
    }
  }

  void toggleTracking() {
    if (!ref.mounted) return;
    state = state.copyWith(isTracking: !state.isTracking);
  }
}
