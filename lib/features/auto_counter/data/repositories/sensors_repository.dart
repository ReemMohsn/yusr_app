import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math' as math;

class SensorsRepository {
  // دفق بيانات المشي مع فلترة القمم
  Stream<double> get accelerationStream {
    return userAccelerometerEvents.map((event) {
      return math.sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
    });
  }

  // دفق البوصلة (الاتجاه) مهم جداً للسعي لمعرفة الالتفاف
  Stream<double> get headingStream {
    return magnetometerEvents.map((event) {
      double heading = math.atan2(event.y, event.x) * (180 / math.pi);
      if (heading < 0) heading += 360;
      return heading;
    });
  }
}