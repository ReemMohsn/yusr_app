import 'package:latlong2/latlong.dart';

class PilgrimMarkerData {
  final String id;
  final String name;
  final LatLng location;
  final double distance; // المسافة بالأمتار عن المشرف
  final DateTime lastSeen; // آخر تحرك فعلي للحاج (lastPositionUpdate)
  final DateTime? lastHeartbeat; // آخر إشارة حياة للهاتف (lastUpdate) — null للبيانات القديمة

  PilgrimMarkerData({
    required this.id,
    required this.name,
    required this.location,
    required this.distance,
    required this.lastSeen,
    this.lastHeartbeat,
  });
}
