import 'package:latlong2/latlong.dart';
import 'package:yusr/features/be_leader/providers/state/alert_event.dart';
import 'package:yusr/features/be_leader/providers/state/pilgrim_marker_data.dart';

class LeaderMapState {
  final LatLng? leaderLocation;
  final List<PilgrimMarkerData> greenPilgrims; // أقل من 75 متر
  final List<PilgrimMarkerData> yellowPilgrims; // بين 75 و 150 متر
  final List<PilgrimMarkerData> redPilgrims; // أكثر من 150 متر
  final bool isLoading;
  final AlertEvent? currentAlert;

  LeaderMapState({
    this.leaderLocation,
    this.greenPilgrims = const [],
    this.yellowPilgrims = const [],
    this.redPilgrims = const [],
    this.isLoading = true,
    this.currentAlert,
  });

  int get totalPilgrims =>
      greenPilgrims.length + yellowPilgrims.length + redPilgrims.length;
}
