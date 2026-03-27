import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/services/location_service.dart';

part 'location_service.g.dart';

@riverpod
LocationService locationService(Ref ref) {
  return LocationService();
}
