import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/features/be_leader/presentation/services/ble_radar_service.dart';

part 'ble_radar_service_provider.g.dart';

@riverpod
BleRadarService bleRadarService(Ref ref) {
  return BleRadarService();
}
