import 'package:latlong2/latlong.dart';

class MapState {
  final LatLng userLocation;
  final LatLng? targetLocation;
  final List<LatLng> routePoints;
  final double distance;
  final double heading;
  final bool isTracking;
  final bool isLoading;

  const MapState({
    this.userLocation = const LatLng(0, 0),
    this.targetLocation = null,
    this.routePoints = const [],
    this.distance = 0.0,
    this.heading = 0.0,
    this.isTracking = false,
    this.isLoading = false,
  });

  MapState copyWith({
    LatLng? userLocation,
    LatLng? targetLocation,
    List<LatLng>? routePoints,
    double? distance,
    double? heading,
    bool? isTracking,
    bool? isLoading,
  }) {
    return MapState(
      userLocation: userLocation ?? this.userLocation,
      targetLocation: targetLocation ?? this.targetLocation,
      routePoints: routePoints ?? this.routePoints,
      distance: distance ?? this.distance,
      heading: heading ?? this.heading,
      isTracking: isTracking ?? this.isTracking,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
