import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/features/be_leader/presentation/services/ble_radar_service.dart';

// تم استخدام مزود تقليدي لضمان بقائه في الذاكرة وعدم تدميره تلقائياً
final bleRadarServiceProvider = Provider<BleRadarService>((ref) {
  return BleRadarService();
});
