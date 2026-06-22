import 'package:latlong2/latlong.dart';
import 'package:yusr/features/be_leader/providers/state/pilgrim_marker_data.dart';

class TrackingState {
  final LatLng? leaderLocation;
  final List<PilgrimMarkerData> greenPilgrims;
  final List<PilgrimMarkerData> yellowPilgrims;
  final List<PilgrimMarkerData> redPilgrims;
  final bool isLoading;
  final String? gpsWarning;
  final String? bleWarning;
  final bool isNetworkConnected;

  TrackingState({
    this.leaderLocation,
    this.greenPilgrims = const [],
    this.yellowPilgrims = const [],
    this.redPilgrims = const [],
    this.isLoading = true,
    this.gpsWarning,
    this.bleWarning,
    this.isNetworkConnected = true,
  });

  int get totalPilgrims =>
      greenPilgrims.length + yellowPilgrims.length + redPilgrims.length;

  /// نسخة محدَّثة من الحالة مع تغيير حقول بعينها فقط.
  /// يستخدم sentinel pattern لتمييز null المقصودة من الحقل غير الممرَّر.
  TrackingState copyWith({
    LatLng? leaderLocation,
    List<PilgrimMarkerData>? greenPilgrims,
    List<PilgrimMarkerData>? yellowPilgrims,
    List<PilgrimMarkerData>? redPilgrims,
    bool? isLoading,
    Object? gpsWarning = _sentinel,
    Object? bleWarning = _sentinel,
    bool? isNetworkConnected,
  }) {
    return TrackingState(
      leaderLocation: leaderLocation ?? this.leaderLocation,
      greenPilgrims: greenPilgrims ?? this.greenPilgrims,
      yellowPilgrims: yellowPilgrims ?? this.yellowPilgrims,
      redPilgrims: redPilgrims ?? this.redPilgrims,
      isLoading: isLoading ?? this.isLoading,
      gpsWarning: gpsWarning == _sentinel ? this.gpsWarning : gpsWarning as String?,
      bleWarning: bleWarning == _sentinel ? this.bleWarning : bleWarning as String?,
      isNetworkConnected: isNetworkConnected ?? this.isNetworkConnected,
    );
  }
}

// ثابت داخلي للـ sentinel pattern في copyWith
const Object _sentinel = Object();
