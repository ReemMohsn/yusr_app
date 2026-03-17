import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

class MapRepository {
  final Dio _dio = Dio();
  final String _orsApiKey = 'eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6ImExNzU1NTJjOTM5ZDQwMzliNDg4MTAyMWMwNjljYjJmIiwiaCI6Im11cm11cjY0In0=';

  Future<Map<String, dynamic>?> getRoute({required LatLng start, required LatLng target}) async {
    const url = 'https://api.openrouteservice.org/v2/directions/driving-car';
    try {
      final response = await _dio.get(url, queryParameters: {
        'api_key': _orsApiKey,
        'start': '${start.longitude},${start.latitude}',
        'end': '${target.longitude},${target.latitude}',
      });

      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print("Repository Error: $e");
    }
    return null;
  }
}