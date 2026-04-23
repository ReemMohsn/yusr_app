import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vibration/vibration.dart';
import '../data/repositories/sensors_repository.dart';
import 'state/auto_counter_state.dart';
import 'counter_provider.dart';

part 'auto_counter_controller.g.dart';

@riverpod
class AutoCounterController extends _$AutoCounterController {
  // --- إعدادات الحساسية والدقة ---
  
  // 1. فلتر المشي (Anti-Shake)
  static const double _stepThresholdMin = 3.0; 
  static const int _requiredStepsToConfirm = 3;
  static const int _lastStepMsMin = 300;
  static const int _lastStepMsMax = 1250;
  
  // 2. إعدادات الطواف (Tawaf) لمنع الغش الحركي
  static const double _compassNoiseFilter = 1.8; 
  static const double _maxAllowedRotationPerFrame = 15.0; // سقف الدوران المنطقي لمنع الهز السريع
  static const double _tawafCompletionAngle = 360.0;
  
  // --- فلاتر المنطق البشري (Human Logic Filters) ---
  // الحد الأدنى للخطوات في الشوط الواحد للطواف (مستحيل يطوف بأقل من 50 خطوة)
  static const int _minStepsPerTawafLap = 50; 
  // الحد الأدنى للوقت (بالثواني) لإنهاء شوط واحد (مستحيل يطوف في أقل من 45 ثانية)
  static const int _minSecondsPerTawafLap = 45;

  // 3. إعدادات السعي (Sa'ee)
  static const int _minStepsForUTurn = 150;
  static const double _uTurnThreshold = 160.0;

  StreamSubscription? _accSub;
  StreamSubscription? _magSub;
  
  DateTime _lastStepTime = DateTime.now();
  DateTime _lapStartTime = DateTime.now(); // لتتبع وقت بداية كل شوط
  int _stepConfirmationCount = 0;
  double _lastHeading = -1.0;

  @override
  AutoCounterState build() {
    ref.onDispose(() => _stopSensors());
    return const AutoCounterState();
  }

  // --- التحكم في التتبع ---
  void startTracking() {
    if (state.isRunning) return;
    final isTawaf = ref.read(counterTypeControllerProvider);
    
    _lapStartTime = DateTime.now(); // تسجيل بداية أول شوط
    state = state.copyWith(
      isRunning: true,
      isCompleted: false,
      currentLap: 1,
      stepsInCurrentLap: 0,
      accumulatedAngle: 0,
      startHeading: -1.0,
      isMoving: false,
      turnDetected: false,
      trackingType: isTawaf ? TrackingType.tawaf : TrackingType.saee,
    );

    _startSensors(isTawaf);
  }

  void _startSensors(bool isTawaf) {
    final repo = SensorsRepository();
    
    _accSub = repo.accelerationStream.listen((acc) => _handleWalking(acc, isTawaf));
    
    _magSub = repo.headingStream.listen((heading) {
      if (isTawaf) {
        _processTawafLogic(heading);
      } else {
        _processSaeeLogic(heading);
      }
    });
  }

  // --- معالجة المشي ---

  void _handleWalking(double acc, bool isTawaf) {
    if (acc > _stepThresholdMin && acc < 12.0) {
      final now = DateTime.now();
      int ms = now.difference(_lastStepTime).inMilliseconds;

      if (ms > _lastStepMsMin && ms < _lastStepMsMax) {
        _stepConfirmationCount++;
        
        if (_stepConfirmationCount >= _requiredStepsToConfirm) {
          int inc = (_stepConfirmationCount == _requiredStepsToConfirm) ? 3 : 1;
          
          state = state.copyWith(
            isMoving: true,
            stepsInCurrentLap: state.stepsInCurrentLap + inc,
          );

          if (!isTawaf && state.currentLap == 7 && state.stepsInCurrentLap >= 450) {
            _finishProcess();
          }
        }
      } else if (ms > _lastStepMsMax) {
        _resetMovement();
      }
      _lastStepTime = now;
    } else {
      final now = DateTime.now();
      if (now.difference(_lastStepTime).inMilliseconds > _lastStepMsMax) {
        _resetMovement();
      }
    }
  }

  void _resetMovement() {
    _stepConfirmationCount = 0;
    if (state.isMoving) {
      state = state.copyWith(isMoving: false);
      _lastHeading = -1.0; 
    }
  }

  // --- منطق الطواف (Tawaf) المحدث بالفلاتر الزمنية والحركية ---

  void _processTawafLogic(double currentHeading) {
    // القفل الأساسي: لا تحسب أي زاوية إذا كان المستخدم واقفاً
    if (!state.isMoving) {
      _lastHeading = -1.0; 
      return; 
    }

    if (_lastHeading == -1.0) {
      _lastHeading = currentHeading;
      return;
    }

    // 1. حساب الفرق اللحظي بين القراءتين
    double delta = (currentHeading - _lastHeading).abs();
    
    // معالجة قفزة الـ 360 درجة
    if (delta > 180) delta = 360 - delta;

    // 2. فلتر "التأرجح" والسرعة المنطقية
    if (delta > _compassNoiseFilter && delta < _maxAllowedRotationPerFrame) { 
      
      double updatedTotalAngle = state.accumulatedAngle + delta;
      
      state = state.copyWith(accumulatedAngle: updatedTotalAngle);
      _lastHeading = currentHeading;

      // 3. تحقق من شروط اتمام الشوط (الدوران + الخطوات + الوقت)
      if (state.accumulatedAngle >= _tawafCompletionAngle) {
        final now = DateTime.now();
        final secondsInLap = now.difference(_lapStartTime).inSeconds;

        if (state.stepsInCurrentLap >= _minStepsPerTawafLap && secondsInLap >= _minSecondsPerTawafLap) {
          _onLapCompleted();
        } else {
          // إذا اكتملت الزاوية ولكن الشروط لم تتحقق (احتمال هز الهاتف)
          // نقوم بتصفير الزاوية المتراكمة لإجبار النظام على بدء الحساب من جديد
          state = state.copyWith(accumulatedAngle: 0);
        }
      }
    } else if (delta >= _maxAllowedRotationPerFrame) {
      // في حالة حدوث قفزة كبيرة (هز عنيف)، نحدث المرجع فقط دون إضافة درجات
      _lastHeading = currentHeading;
    }
  }

  // --- منطق السعي (Sa'ee) ---

  void _processSaeeLogic(double currentHeading) {
    if (!state.isMoving) return;

    if (state.startHeading == -1.0) {
      state = state.copyWith(startHeading: currentHeading);
      return;
    }

    double angleDiff = (currentHeading - state.startHeading).abs();
    if (angleDiff > 180) angleDiff = 360 - angleDiff;

    if (state.currentLap < 7 && 
        state.stepsInCurrentLap >= _minStepsForUTurn && 
        angleDiff >= _uTurnThreshold) {
      if (!state.turnDetected) {
        state = state.copyWith(turnDetected: true);
        _onLapCompleted();
      }
    }
  }

  // --- أحداث الإتمام ---

  void _onLapCompleted() {
    _triggerVibration();
    _stepConfirmationCount = 0;
    _lastHeading = -1.0;
    _lapStartTime = DateTime.now(); // إعادة ضبط مؤقت الشوط الجديد

    if (state.currentLap < 7) {
      state = state.copyWith(
        currentLap: state.currentLap + 1,
        stepsInCurrentLap: 0,
        accumulatedAngle: 0,
        turnDetected: false,
        startHeading: -1.0,
      );
    } else {
      _finishProcess();
    }
  }

  void _finishProcess() {
    _triggerVibration(isFinal: true);
    _stopSensors();
    state = state.copyWith(isRunning: false, isCompleted: true, currentLap: 7);
  }

  void _stopSensors() {
    _accSub?.cancel();
    _magSub?.cancel();
    _accSub = null;
    _magSub = null;
  }

  void stop() => _stopSensors();

  void reset() {
    _stopSensors();
    _stepConfirmationCount = 0;
    state = const AutoCounterState();
  }

  Future<void> _triggerVibration({bool isFinal = false}) async {
    try {
      if (await Vibration.hasVibrator() ?? false) {
        isFinal ? Vibration.vibrate(duration: 800) : Vibration.vibrate(duration: 400);
      }
    } catch (e) {}
  }
}