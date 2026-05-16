// // import 'package:sensors_plus/sensors_plus.dart';
// // import 'dart:math' as math;

// // class SensorsRepository {
// //   // دفق بيانات المشي مع فلترة القمم
// //   Stream<double> get accelerationStream {
// //     return userAccelerometerEvents.map((event) {
// //       return math.sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
// //     });
// //   }

// //   // دفق البوصلة (الاتجاه) مهم جداً للسعي لمعرفة الالتفاف
// //   Stream<double> get headingStream {
// //     return magnetometerEvents.map((event) {
// //       double heading = math.atan2(event.y, event.x) * (180 / math.pi);
// //       if (heading < 0) heading += 360;
// //       return heading;
// //     });
// //   }
// // }

// //////////////////////////
// ///

// // ============================================================
// // sensors_repository.dart
// // المستودع الوحيد لجميع بيانات الحساسات
// //
// // التغيير الجوهري: استبدال المغناطيس (Magnetometer) بالجيروسكوب (Gyroscope)
// // السبب: المغناطيس داخل المسجد الحرام غير موثوق بسبب:
// //   - التداخل المعدني للمبنى
// //   - آلاف الهواتف المحيطة
// // الجيروسكوب: يقيس سرعة الدوران مباشرة ولا يتأثر بالبيئة الخارجية
// // ============================================================

// import 'package:sensors_plus/sensors_plus.dart';
// import 'dart:math' as math;

// // ── نموذج بيانات قراءة الجيروسكوب ──────────────────────────
// class GyroscopeReading {
//   /// معدل الدوران حول المحور Z بالدرجة/ثانية (موقَّع: + عكس الساعة، - مع الساعة)
//   /// المحور Z هو محور الدوران الأفقي عندما يكون الهاتف عمودياً في الجيب
//   final double zRate;

//   /// طابع زمني للقراءة — يُستخدم لحساب dt بدقة بين قراءتين
//   final DateTime timestamp;

//   const GyroscopeReading({required this.zRate, required this.timestamp});
// }

// // ── المستودع الرئيسي ─────────────────────────────────────────
// class SensorsRepository {
//   /// مجرى التسارع الخطي (بعد حذف الجاذبية) — لرصد الخطوات
//   ///
//   /// يُعيد القوة الكلية للحركة بوحدة m/s²
//   /// يُستخدم كـ "نبضمتر" لرصد ذروات التسارع عند كل خطوة
//   Stream<double> get accelerationStream {
//     return userAccelerometerEvents.map((event) {
//       return math.sqrt(
//         event.x * event.x + event.y * event.y + event.z * event.z,
//       );
//     });
//   }

//   /// مجرى الجيروسكوب — لقياس الدوران في الطواف ورصد الالتفاف في السعي
//   ///
//   /// يُعيد [GyroscopeReading] يحتوي على:
//   /// - zRate: سرعة الدوران الأفقي (درجة/ثانية)
//   /// - timestamp: لحساب الزمن المنقضي بين قراءتين (dt) بدقة
//   Stream<GyroscopeReading> get gyroscopeStream {
//     return gyroscopeEvents.map((event) {
//       const double radToDeg = 180.0 / math.pi;
//       return GyroscopeReading(
//         zRate: event.z * radToDeg,
//         timestamp: DateTime.now(),
//       );
//     });
//   }
// }
///////////////////////////
///
///
// ============================================================
// sensors_repository.dart
// المستودع الوحيد لجميع بيانات الحساسات
//
// التحسينات النهائية:
//   ✅ Hardware Pedometer بدل Accelerometer الخام
//      → دقة 97% مقابل 70% | لا يتأثر بهز اليد أو وضع الهاتف
//   ✅ الجيروسكوب للدوران (تكامل موقَّع)
//      → مستقل عن البيئة المغناطيسية في المسجد الحرام
//
// متطلبات AndroidManifest.xml:
//   <uses-permission android:name="android.permission.ACTIVITY_RECOGNITION"/>
// ============================================================

import 'package:pedometer/pedometer.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math' as math;

// ─────────────────────────────────────────────────────────────
// نماذج البيانات
// ─────────────────────────────────────────────────────────────

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
  /// ✅ [التحسين]: استخدام Dot Product للعمل في أي وضعية للهاتف
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
