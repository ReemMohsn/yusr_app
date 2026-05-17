import 'package:pedometer/pedometer.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math' as math;

/// حدث خطوة من الـ Hardware Pedometer
class StepEvent {
  final int totalSteps;
  final DateTime timestamp;
  const StepEvent({required this.totalSteps, required this.timestamp});
}

/// حالة المشي من الـ Hardware Pedometer
class WalkingStatus {
  final bool isWalking;
  const WalkingStatus({required this.isWalking});
}

/// قراءة الجيروسكوب بعد التحويل للدرجات
class GyroscopeReading {
  final double zRate;
  final DateTime timestamp;
  const GyroscopeReading({required this.zRate, required this.timestamp});
}

// ─────────────────────────────────────────────────────────────
// المستودع الرئيسي
// ─────────────────────────────────────────────────────────────

class SensorsRepository {
  // متغيرات تتبع متجه الجاذبية الأرضية (Gravity Vector)
  double _gx = 0.0;
  double _gy = 0.0;
  double _gz = 9.81;
  bool _isGravityInitialized = false;

  SensorsRepository() {
    // ── الدمج الرياضي (Sensor Fusion) ──
    // قراءة حساس التسارع العام لتحديد اتجاه "الأسفل"
    accelerometerEvents.listen((event) {
      if (!_isGravityInitialized) {
        // أخذ القراءة الأولى كمرجع فوري بدلاً من الانتظار
        _gx = event.x;
        _gy = event.y;
        _gz = event.z;
        _isGravityInitialized = true;
      } else {
        // فلتر قوي جداً (0.98) لتجاهل أرجحة اليد السريعة أثناء المشي (Arm Swing)
        // والاحتفاظ فقط بقوة الجاذبية الأرضية الثابتة
        const double alpha = 0.98;
        _gx = alpha * _gx + (1 - alpha) * event.x;
        _gy = alpha * _gy + (1 - alpha) * event.y;
        _gz = alpha * _gz + (1 - alpha) * event.z;
      }
    });
  }

  /// مجرى الخطوات من الـ Hardware Pedometer
  Stream<StepEvent> get stepStream {
    return Pedometer.stepCountStream.map(
      (event) => StepEvent(
        totalSteps: event.steps,
        timestamp: event.timeStamp ?? DateTime.now(),
      ),
    );
  }

  /// مجرى حالة المشي من الـ Hardware Pedometer
  Stream<WalkingStatus> get walkingStatusStream {
    return Pedometer.pedestrianStatusStream.map(
      (event) => WalkingStatus(isWalking: event.status == 'walking'),
    );
  }

  /// مجرى الجيروسكوب لقياس الدوران
  Stream<GyroscopeReading> get gyroscopeStream {
    return gyroscopeEvents.map((event) {
      // 1. تسوية متجه الجاذبية (Normalization)
      double norm = math.sqrt(_gx * _gx + _gy * _gy + _gz * _gz);
      double nx = norm == 0 ? 0 : _gx / norm;
      double ny = norm == 0 ? 0 : _gy / norm;
      double nz = norm == 0 ? 0 : _gz / norm;

      // 2. تطبيق الـ Dot Product لاستخلاص الدوران حول محور الأرض
      // هذا يجعل الدوران يُحسب بدقة سواء كان الهاتف أفقياً، رأسياً، أو في الجيب
      double trueZRateRad = (event.x * nx) + (event.y * ny) + (event.z * nz);

      const double radToDeg = 180.0 / math.pi;
      return GyroscopeReading(
        zRate: trueZRateRad * radToDeg,
        timestamp: DateTime.now(),
      );
    });
  }
}
