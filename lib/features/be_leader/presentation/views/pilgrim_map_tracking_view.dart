import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/be_leader/presentation/widgets/pilgrim_map_legend.dart';
import 'package:yusr/features/be_leader/presentation/widgets/pilgrim_map_top_card.dart';
import 'package:yusr/features/be_leader/presentation/widgets/pilgrim_map_widget.dart';
import 'package:yusr/features/be_leader/presentation/widgets/pilgrim_mute_alarm_button.dart';
import 'package:yusr/features/be_leader/presentation/widgets/pilgrim_stop_tracking_fab.dart';
import 'package:yusr/features/be_leader/providers/pilgrim_tracking_controller.dart';
import 'package:yusr/features/be_leader/providers/state/pilgrim_tracking_state.dart';
import 'package:yusr/features/return_to_compaign_location/presentation/widgets/tracking_fab_widget.dart';

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
  bool _isTracking = true;

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    final mapState = ref.watch(pilgrimTrackingControllerProvider);

    // ── SnackBar للتحذيرات ────────────────────────────────────
    ref.listen<PilgrimTrackingState>(pilgrimTrackingControllerProvider, (
      previous,
      next,
    ) {
      if (next.gpsWarning != null &&
          next.gpsWarning != previous?.gpsWarning) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.gpsWarning!),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 4),
          ),
        );
      }
      if (next.bleWarning != null &&
          next.bleWarning != previous?.bleWarning) {
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

    if (mapState.errorMessage != null) {
      return Scaffold(
        body: Center(child: Text(mapState.errorMessage!)),
      );
    }

    final bool isConnected = mapState.pilgrimLocation != null;
    final bool isAlarmZone = mapState.distance > 30;

    return Scaffold(
      body: Stack(
        children: [
          // ── الخريطة ───────────────────────────────────────────
          PilgrimMapWidget(
            mapController: _mapController,
            mapState: mapState,
          ),

          // ── الشريط العلوي ─────────────────────────────────────
          Positioned(
            top: 55,
            left: 20,
            right: 20,
            child: PilgrimMapTopCard(
              state: mapState,
              isConnected: isConnected,
            ),
          ),

          // ── زر كتم الإنذار (عند الخطر فقط) ──────────────────
          if (isAlarmZone)
            const Positioned(
              bottom: 160,
              left: 0,
              right: 0,
              child: Center(child: PilgrimMuteAlarmButton()),
            ),

          // ── وسيلة الإيضاح ─────────────────────────────────────
          const Positioned(
            bottom: 110,
            right: 16,
            child: PilgrimMapLegend(),
          ),

          // ── زر تتبع الكاميرا ──────────────────────────────────
          TrackingFAB(
            isTracking: _isTracking,
            onPressed: () {
              setState(() => _isTracking = !_isTracking);
              if (mapState.pilgrimLocation != null) {
                _mapController.move(mapState.pilgrimLocation!, 17.0);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(locale.locatingPleaseWait)),
                );
              }
            },
          ),

          // ── زر إيقاف التتبع ────────────────────────────────────
          Positioned(
            bottom: 28,
            left: 0,
            right: 0,
            child: Center(
              child: PilgrimStopTrackingFab(sessionId: widget.sessionId),
            ),
          ),
        ],
      ),
    );
  }
}
