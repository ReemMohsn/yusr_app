import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// خدمة مشتركة لعدّ الخطوات الذكي والتحقق من صحة حركة الـ GPS.
/// تُستخدم في كلٍّ من [LeaderTrackingController] و [PilgrimTrackingController]
/// لتجنب تكرار الكود — كل كونترولر يحتفظ بنسخته الخاصة من هذه الخدمة.
class SmartLocationFilterService {
  StreamSubscription<AccelerometerEvent>? _accelSub;

  DateTime _lastStepTime = DateTime.now();
  int _consecutiveSteps = 0;
  double _lastAcc = 0.0;
  int _trustedTotalSteps = 0;
  int _stepsAtLastGpsUpdate = 0;

  /// تشغيل عدّاد الخطوات الذكي بالمسرِّع (Accelerometer).
  /// [tag] — وسم يُضاف لسجلات الـ Debug لتمييز المشرف عن الحاج.
  void startSmartStepCounting({String tag = ''}) {
    _accelSub?.cancel();
    _accelSub = accelerometerEventStream().listen(
      (AccelerometerEvent event) {
        double acc = math.sqrt(
          event.x * event.x + event.y * event.y + event.z * event.z,
        );

        if (_lastAcc > 2.5 && acc < _lastAcc) {
          final now = DateTime.now();
          int msDiff = now.difference(_lastStepTime).inMilliseconds;

          if (msDiff > 350 && msDiff < 1200) {
            _consecutiveSteps++;
            _lastStepTime = now;

            debugPrint(
              '👟 [عداد الخطوات$tag] خطوة محتملة! المتتالية الآن: $_consecutiveSteps | الفرق: $msDiff م.ث',
            );

            if (_consecutiveSteps >= 3) {
              int stepIncrement = (_consecutiveSteps == 3) ? 3 : 1;
              _trustedTotalSteps += stepIncrement;

              debugPrint(
                '✅ [عداد الخطوات$tag] تم اعتماد $stepIncrement خطوة. الإجمالي الموثوق: $_trustedTotalSteps',
              );
            }
          } else if (msDiff > 1200) {
            if (_consecutiveSteps > 0) {
              debugPrint(
                '🛑 [عداد الخطوات$tag] توقف عن المشي (مر $msDiff م.ث). تصفير العداد المتتالي.',
              );
            }
            _consecutiveSteps = 0;
          }
        }
        _lastAcc = acc;
      },
      onError: (error) {
        debugPrint('❌ خطأ في مستشعر الحركة$tag: $error');
      },
    );
  }

  /// يتحقق إن كانت قفزة الـ GPS منطقية بالمقارنة مع الخطوات الفعلية.
  /// [tag] — وسم للتمييز في سجلات الـ Debug.
  bool isMovementReal(double distanceMeters, {String tag = ''}) {
    if (distanceMeters < 5) return true; // مسافات صغيرة جداً تُقبل دائماً

    int stepsTaken = _trustedTotalSteps - _stepsAtLastGpsUpdate;
    double expectedMinSteps = distanceMeters / 1.5;

    debugPrint(
      '🔍 [حماية الموقع$tag] المسافة $distanceMeters م | خطوات فعلية: $stepsTaken | المتوقع: $expectedMinSteps',
    );

    if (stepsTaken < expectedMinSteps && distanceMeters > 15) {
      debugPrint(
        'لم يمشِ المستخدم$tag مسافة كافية لقطع هذه المسافة — سيتم رفض التحديث',
      );
      return false;
    }

    _stepsAtLastGpsUpdate = _trustedTotalSteps;
    debugPrint(
      'مشى المستخدم$tag مسافة كافية — سيتم قبول التحديث',
    );
    return true;
  }

  /// يتحقق إن كانت السرعة المحسوبة منطقية (أقل من 4 م/ث — فلتر 2).
  ///
  /// يُعيد `false` إذا كانت القفزة وهمية، `true` إذا اجتازت الفحص،
  /// و`null` إذا كان الوقت صفراً (غير قادر على الحساب).
  bool? isSpeedJumpValid({
    required double distanceMeters,
    required int timeDiffSeconds,
    String tag = '',
  }) {
    if (timeDiffSeconds <= 0) return null;

    final speed = distanceMeters / timeDiffSeconds;
    debugPrint(
      '🏃 [فلتر السرعة$tag] مسافة: ${distanceMeters.toStringAsFixed(1)} م | زمن: ${timeDiffSeconds}ث | سرعة: ${speed.toStringAsFixed(1)} م/ث',
    );

    if (speed > 4.0) {
      debugPrint('⚠️ [فلتر السرعة$tag] ❌ قفزة GPS وهمية (سرعة $speed م/ث).');
      return false;
    }

    debugPrint('✅ [فلتر السرعة$tag] الموقع منطقي واجتاز الفحص.');
    return true;
  }

  /// تصفير جميع عدادات المشي (يُستدعى عند إيقاف الجلسة).
  void reset() {
    _trustedTotalSteps = 0;
    _stepsAtLastGpsUpdate = 0;
    _consecutiveSteps = 0;
  }

  /// إيقاف المستشعر وتصفير العدادات.
  void stop() {
    _accelSub?.cancel();
    _accelSub = null;
    reset();
  }
}
