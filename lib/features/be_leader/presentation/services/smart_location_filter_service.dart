import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:pedometer/pedometer.dart';


/// خدمة مشتركة لعدّ الخطوات الذكي والتحقق من صحة حركة الـ GPS.
/// تُستخدم في كلٍّ من [LeaderTrackingController] و [PilgrimTrackingController]
/// لتجنب تكرار الكود — كل كونترولر يحتفظ بنسخته الخاصة من هذه الخدمة.
///
/// ### التحديث: Hardware Pedometer بدلاً من Accelerometer اليدوي
/// - يعتمد على `Pedometer.stepCountStream` المُشغَّل عبر شريحة DSP منخفضة الطاقة
/// - لا يتأثر بوضع الهاتف (جيب / يد / حقيبة) لأن المعالجة تتم على مستوى الـ HAL
/// - أقل استهلاكاً للطاقة لأنه لا يُطلق أحداثاً إلا عند وقوع خطوة فعلية (≠ 100 حدث/ثانية)
///
/// ### ثوابت عتبة دقة GPS (التعديل 4)
/// تم توحيد العتبة لتكون 35م لكل من المشرف والحاج لتوسيع هامش التسامح مع الدقة قليلاً.
/// - [kLeaderAccuracyThreshold]: 35م
/// - [kPilgrimAccuracyThreshold]: 35م
class SmartLocationFilterService {
  // ─── ثوابت عتبة دقة GPS ───────────────────────────────────────────────────
  /// عتبة دقة GPS للمشرف والحاج — تم توسيعها لـ 35
  static const double kLeaderAccuracyThreshold = 35.0;

  /// عتبة دقة GPS للحاج
  static const double kPilgrimAccuracyThreshold = 35.0;

  // ─── Hardware Pedometer ──────────────────────────────────────────────────
  StreamSubscription<StepCount>? _stepCountSub;
  StreamSubscription<PedestrianStatus>? _walkingStatusSub;
  Timer? _stoppedTimer;

  /// آخر قراءة مُستلمة من نظام التشغيل (تراكمية منذ إعادة تشغيل الهاتف)
  int _lastHardwareTotalSteps = -1;

  /// قراءة نظام التشغيل عند بدء الجلسة — تُطرح لحساب خطوات الجلسة فقط
  int _sessionStartSteps = 0;

  /// إجمالي خطوات الجلسة الحالية (نسبي — يبدأ من صفر مع كل جلسة)
  int _trustedTotalSteps = 0;

  /// خطوات الجلسة عند آخر تحديث GPS مقبول — لحساب الفرق في [isMovementReal]
  int _stepsAtLastGpsUpdate = 0;

  /// هل الشخص يمشي حالياً؟ (من PedestrianStatus)
  bool _isCurrentlyWalking = true;

  void startSmartStepCounting({String tag = ''}) {
    _stepCountSub?.cancel();
    _walkingStatusSub?.cancel();
    _stoppedTimer?.cancel();

    // ── 1. Hardware Step Counter ──────────────────────────────────────────
    // يعمل على شريحة DSP مخصصة → لا يستهلك CPU ولا يُطلق أحداثاً إلا عند الخطوة
    _stepCountSub = Pedometer.stepCountStream.listen(
      (StepCount event) {
        final int totalFromOS = event.steps;

        // أخذ القراءة الأولى كـ offset لعزل خطوات هذه الجلسة فقط
        if (_lastHardwareTotalSteps == -1) {
          _lastHardwareTotalSteps = totalFromOS;
          _sessionStartSteps = totalFromOS;
          debugPrint(
            '👟 [عداد الخطوات$tag] تهيئة: offset الجلسة = $totalFromOS خطوة',
          );
          return;
        }

        final int delta = totalFromOS - _lastHardwareTotalSteps;

        // تجاهل القراءات غير المنطقية (انحراف عكسي أو قفزة > 10 دفعة واحدة)
        if (delta <= 0 || delta > 10) {
          _lastHardwareTotalSteps = totalFromOS;
          return;
        }

        _lastHardwareTotalSteps = totalFromOS;
        _trustedTotalSteps = totalFromOS - _sessionStartSteps;

        // إعادة تشغيل مؤقت التوقف مع كل خطوة — الشخص يمشي فعلاً
        _isCurrentlyWalking = true;
        _resetStoppedTimer();

        debugPrint(
          '👟 [عداد الخطوات$tag] +$delta خطوة | إجمالي الجلسة: $_trustedTotalSteps',
        );
      },
      onError: (error) {
        debugPrint('❌ [عداد الخطوات$tag] خطأ في Hardware Pedometer: $error');
      },
    );

    // ── 2. Pedestrian Status — اكتشاف التوقف الكامل ──────────────────────
    // يستخدم نفس الشريحة المنخفضة الطاقة → تكلفة إضافية شبه معدومة
    _walkingStatusSub = Pedometer.pedestrianStatusStream.listen(
      (PedestrianStatus event) {
        final isWalking = event.status == 'walking';

        if (!isWalking && _isCurrentlyWalking) {
          // أعطِ 5 ثوانٍ قبل اعتبار الشخص متوقفاً فعلاً (لتجنب الحركات القصيرة)
          _resetStoppedTimer();
        } else if (isWalking) {
          _stoppedTimer?.cancel();
          _isCurrentlyWalking = true;
          debugPrint('🚶 [مشي$tag] استُؤنف المشي — الفلتر نشط');
        }
      },
      onError: (error) {
        // في حال عدم دعم الجهاز للـ PedestrianStatus نُبقي على السلوك الافتراضي (مشي)
        debugPrint('⚠️ [توقف$tag] لا يدعم الجهاز PedestrianStatus: $error');
      },
    );
  }

  bool isMovementReal({
    required double distanceMeters,
    required double currentAccuracy,
    required double previousAccuracy,
    String tag = '',
  }) {
    // 1. مسافات صغيرة جداً تُقبل دائماً (GPS error margin طبيعي)
    if (distanceMeters < 5) return true;

    // 2. ZUPT: الشخص متوقف تماماً (مفيش خطوات) → فقط تصحيحات GPS ضمن هامش الخطأ
    if (!_isCurrentlyWalking) {
      final double allowedNoiseRadius = math.max(
        currentAccuracy,
        previousAccuracy,
      );
      if (distanceMeters <= allowedNoiseRadius) {
        debugPrint(
          '🔄 [ZUPT$tag] متوقف لكن القفزة (${distanceMeters.toStringAsFixed(1)}م) ضمن هامش الخطأ (${allowedNoiseRadius.toStringAsFixed(1)}م) — مقبولة.',
        );
        return true;
      }
      debugPrint(
        '🛑 [ZUPT$tag] رفض! متوقف تماماً والقفزة (${distanceMeters.toStringAsFixed(1)}م) أكبر من هامش الخطأ.',
      );
      return false;
    }

    // 3. حساب الخطوات منذ آخر تحديث GPS مقبول
    final int stepsTaken = _trustedTotalSteps - _stepsAtLastGpsUpdate;
    final double expectedMinSteps = distanceMeters / 1.5;

    // 4. الخطوات كافية للمسافة → قبول
    if (stepsTaken >= expectedMinSteps) {
      _stepsAtLastGpsUpdate = _trustedTotalSteps;
      debugPrint(
        '✅ [حماية الموقع$tag] مشى المستخدم مسافة كافية ($stepsTaken خطوات).',
      );
      return true;
    }

    // 5. الخطوات غير كافية.. هل القفزة تصحيح GPS ضمن هامش الخطأ؟
    final double allowedNoiseRadius = math.max(
      currentAccuracy,
      previousAccuracy,
    );
    if (distanceMeters <= allowedNoiseRadius) {
      _stepsAtLastGpsUpdate = _trustedTotalSteps;
      debugPrint(
        '🔄 [حماية الموقع$tag] تصحيح GPS مسموح ضمن هامش الخطأ بدون خطوات.',
      );
      return true;
    }

    // 6. رفض القفزة الوهمية
    debugPrint(
      '🛑 [حماية الموقع$tag] رفض! مسافة (${distanceMeters.toStringAsFixed(1)}م) > هامش الخطأ (${allowedNoiseRadius.toStringAsFixed(1)}م) بخطوات غير كافية ($stepsTaken).',
    );
    return false;
  }

  /// يتحقق إن كانت السرعة المحسوبة منطقية (أقل من 4 م/ث — فلتر السرعة).
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
      '🏃 [فلتر السرعة$tag] مسافة: ${distanceMeters.toStringAsFixed(1)} م'
      ' | زمن: ${timeDiffSeconds}ث'
      ' | سرعة: ${speed.toStringAsFixed(1)} م/ث',
    );

    if (speed > 4.0) {
      debugPrint('⚠️ [فلتر السرعة$tag] ❌ قفزة GPS وهمية (سرعة $speed م/ث).');
      return false;
    }

    debugPrint('✅ [فلتر السرعة$tag] الموقع منطقي واجتاز الفحص.');
    return true;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // مساعدات داخلية
  // ═══════════════════════════════════════════════════════════════════════════

  /// يُعيد تشغيل مؤقت التوقف من الصفر.
  /// يُستدعى مع كل خطوة جديدة أو عند رصد إشارة توقف من PedestrianStatus.
  void _resetStoppedTimer() {
    _stoppedTimer?.cancel();
    _stoppedTimer = Timer(const Duration(seconds: 5), () {
      _isCurrentlyWalking = false;
      debugPrint('🛑 [توقف] تم رصد التوقف الكامل — تجميد قبول قفزات GPS');
    });
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // إدارة دورة الحياة
  // ═══════════════════════════════════════════════════════════════════════════

  /// تصفير جميع عدادات الجلسة (يُستدعى عند انتهاء الجلسة أو إعادة التشغيل).
  void reset() {
    _stoppedTimer
        ?.cancel(); // 🔧 إصلاح: إلغاء أي مؤقت توقف معلق لمنعه من الإطلاق بعد التصفير
    _trustedTotalSteps = 0;
    _stepsAtLastGpsUpdate = 0;
    _lastHardwareTotalSteps = -1;
    _sessionStartSteps = 0;
    _isCurrentlyWalking = true;
  }

  /// إيقاف جميع المستشعرات والمؤقتات وتصفير العدادات.
  void stop() {
    _stepCountSub?.cancel();
    _walkingStatusSub?.cancel();
    _stoppedTimer?.cancel();
    _stepCountSub = null;
    _walkingStatusSub = null;
    _isCurrentlyWalking = true;
    reset();
  }
}
