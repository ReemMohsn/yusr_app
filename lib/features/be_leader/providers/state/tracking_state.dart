import 'package:latlong2/latlong.dart';
import 'package:yusr/features/be_leader/providers/state/pilgrim_marker_data.dart';

class TrackingState {
  final LatLng? leaderLocation;
  final List<PilgrimMarkerData> greenPilgrims;
  final List<PilgrimMarkerData> yellowPilgrims;
  final List<PilgrimMarkerData> redPilgrims;
  final bool isLoading;
  final String? gpsWarning;
  final String? bleWarning; // 🌟 إضافة لتنبيهات البلوتوث

  TrackingState({
    this.leaderLocation,
    this.greenPilgrims = const [],
    this.yellowPilgrims = const [],
    this.redPilgrims = const [],
    this.isLoading = true,
    this.gpsWarning,
    this.bleWarning,
  });

  int get totalPilgrims =>
      greenPilgrims.length + yellowPilgrims.length + redPilgrims.length;
}
