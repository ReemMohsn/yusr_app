import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/be_leader/presentation/widgets/leader_end_session_fab.dart';
import 'package:yusr/features/be_leader/presentation/widgets/leader_map_legend.dart';
import 'package:yusr/features/be_leader/presentation/widgets/leader_map_top_card.dart';
import 'package:yusr/features/be_leader/presentation/widgets/leader_map_widget.dart';
import 'package:yusr/features/be_leader/presentation/widgets/leader_mute_alarm_button.dart';
import 'package:yusr/features/be_leader/providers/leader_tracking_controller.dart';
import 'package:yusr/features/be_leader/providers/state/tracking_state.dart';
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
    final locale = context.locale;
    final mapState = ref.watch(leaderTrackingControllerProvider);

    // ── SnackBar للتحذيرات ────────────────────────────────────
    ref.listen<TrackingState>(leaderTrackingControllerProvider, (
      previous,
      next,
    ) {
      if (next.gpsWarning != null && next.gpsWarning != previous?.gpsWarning) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.gpsWarning!),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 4),
          ),
        );
      }
      if (next.bleWarning != null && next.bleWarning != previous?.bleWarning) {
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

    // ── Listener لحالة إنهاء الجلسة ──────────────────────────
    ref.listen(stopLeaderSessionControllerProvider, (_, state) {
      if (state.isLoading) {
        context.showLoadingDialog();
      } else if (state.hasError) {
        context.closeLoadingDialog();
        context.showErrorSnackBar(
          state.error.toString().replaceAll('Exception: ', ''),
        );
      } else if (!state.isLoading && !state.hasError) {
        context.closeLoadingDialog();
        context.showSuccessSnackBar(locale.sessionEndedSuccessfully);
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          // ── الخريطة ───────────────────────────────────────────
          LeaderMapWidget(
            mapController: _mapController,
            mapState: mapState,
          ),

          // ── البطاقة العلوية ───────────────────────────────────
          Positioned(
            top: 55,
            left: 20,
            right: 20,
            child: LeaderMapTopCard(
              state: mapState,
              isLeaderConnected:
                  mapState.leaderLocation != null &&
                  mapState.gpsWarning == null,
            ),
          ),

          // ── زر كتم الإنذار (عند وجود حجاج في الخطر) ─────────
          if (mapState.redPilgrims.isNotEmpty)
            const Positioned(
              bottom: 160,
              left: 0,
              right: 0,
              child: Center(child: LeaderMuteAlarmButton()),
            ),

          // ── وسيلة الإيضاح ─────────────────────────────────────
          const Positioned(
            bottom: 110,
            right: 16,
            child: LeaderMapLegend(),
          ),

          // ── زر تتبع الكاميرا ──────────────────────────────────
          TrackingFAB(
            isTracking: _isTracking,
            onPressed: () {
              setState(() => _isTracking = !_isTracking);
              if (mapState.leaderLocation != null) {
                _mapController.move(mapState.leaderLocation!, 17.0);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(locale.locatingPleaseWait)),
                );
              }
            },
          ),

          // ── زر إنهاء الجلسة ──────────────────────────────────
          const Positioned(
            bottom: 28,
            left: 0,
            right: 0,
            child: Center(child: LeaderEndSessionFab()),
          ),
        ],
      ),
    );
  }
}
