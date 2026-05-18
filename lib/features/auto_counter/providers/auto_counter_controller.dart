import 'dart:async';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../data/repositories/sensors_repository.dart';
import 'auto_counter_notification_provider.dart';
import 'auto_counter_storage_provider.dart';
import 'state/auto_counter_state.dart';
import 'counter_provider.dart';
import '../services/auto_counter_strings.dart';

part 'auto_counter_controller.g.dart';

@riverpod
class AutoCounterController extends _$AutoCounterController {
  static const int _stoppedThresholdMs = 5000;

  // — الجيروسكوب —
  static const double _gyroNoise = 2.0;
  // static const double _gyroMaxRate = 85.0;
  static const double _gyroMaxRate = 250.0;

  static const double _gyroMaxDeltaPerFrame = 25.0;

  // — الطواف —
  static const double _tawafLapAngle = 345.0;
  // static const int _tawafMinSteps = 200;
  // static const int _tawafMinSeconds = 120;
  static const int _tawafMinSteps = 10;
  static const int _tawafMinSeconds = 50;

  // — السعي —
  static const double _saeeUTurnAngle = 130.0;
  // static const int _saeeMinStepsBeforeUTurn = 400;
  // static const int _saeeMinSeconds = 180;
  // static const int _saeeLastLapMinSteps = 500;
  static const int _saeeMinStepsBeforeUTurn = 10;
  static const int _saeeMinSeconds = 5;
  static const int _saeeLastLapMinSteps = 10;

  // متغيرات داخلية
  // ═══════════════════════════════════════════════════════════

  StreamSubscription<StepEvent>? _stepSub;
  StreamSubscription<WalkingStatus>? _walkSub;
  StreamSubscription<GyroscopeReading>? _gyroSub;
  StreamSubscription<Position>? _keepAliveSub;
  Timer? _stoppedTimer;

  int _lastTotalSteps = -1;

  DateTime? _lastGyroTime;
  double _tawafSignedAngle = 0.0;
  double _saeeSignedAngle = 0.0;
  DateTime _lapStartTime = DateTime.now();

  //  البناء الأولي
  // ═══════════════════════════════════════════════════════════

  @override
  AutoCounterState build() {
    ref.onDispose(_cleanup);
    ref.read(autoCounterNotificationProvider).init();
    return const AutoCounterState();
  }

  // Public API
  // ═══════════════════════════════════════════════════════════

  Future<void> startTracking() async {
    if (state.isRunning) return;

    final isGranted = await Permission.activityRecognition.request();
    if (!ref.mounted) return;

    if (!isGranted.isGranted) {
      state = state.copyWith(
        permissionError: AutoCounterStrings.activityPermissionDenied,
        // permissionError: 'يرجى منح صلاحية رصد النشاط الحركي من إعدادات الجهاز',
      );
      return;
    }

    final isTawaf = ref.read(counterTypeControllerProvider);
    //استعادة الشوط المحفوظ
    final savedLap = await ref
        .read(autoCounterStorageProvider)
        .loadSavedLap(isTawaf);
    if (!ref.mounted) return;

    //تهيئة الحالة
    _tawafSignedAngle = 0.0;
    _saeeSignedAngle = 0.0;
    _lastTotalSteps = -1;
    _lastGyroTime = null;
    _lapStartTime = DateTime.now();

    state = state.copyWith(
      isRunning: true,
      isCompleted: false,
      currentLap: savedLap,
      stepsInCurrentLap: 0,
      accumulatedAngle: 0.0,
      // isMoving: false,
      isMoving: true,
      turnDetected: false,
      startHeading: -1.0,
      permissionError: null,
      trackingType: isTawaf ? TrackingType.tawaf : TrackingType.saee,
    );

    await ref
        .read(autoCounterStorageProvider)
        .saveState(isTawaf: isTawaf, lap: savedLap, isRunning: true);

    WakelockPlus.enable();
    _startSensors(isTawaf);
  }

  void stop() => _cleanup();

  void reset() {
    _cleanup();
    ref.read(autoCounterStorageProvider).clearSavedState();
    state = const AutoCounterState();
  }

  /// تصحيح يدوي — زيادة شوط
  void incrementLap() {
    if (!state.isRunning || state.currentLap >= 7) return;
    final newLap = state.currentLap + 1;
    _resetLapCounters();
    state = state.copyWith(
      currentLap: newLap,
      stepsInCurrentLap: 0,
      accumulatedAngle: 0.0,
      turnDetected: false,
    );
    ref
        .read(autoCounterStorageProvider)
        .saveState(
          isTawaf: state.trackingType == TrackingType.tawaf,
          lap: newLap,
          isRunning: true,
        );
  }

  /// تصحيح يدوي — إنقاص شوط
  void decrementLap() {
    if (!state.isRunning || state.currentLap <= 1) return;
    final newLap = state.currentLap - 1;
    _resetLapCounters();
    state = state.copyWith(
      currentLap: newLap,
      stepsInCurrentLap: 0,
      accumulatedAngle: 0.0,
      turnDetected: false,
    );
    ref
        .read(autoCounterStorageProvider)
        .saveState(
          isTawaf: state.trackingType == TrackingType.tawaf,
          lap: newLap,
          isRunning: true,
        );
  }

  // تشغيل الحساسات
  // ═══════════════════════════════════════════════════════════

  void _startSensors(bool isTawaf) {
    final repo = SensorsRepository();

    _startForegroundKeepAlive();

    // Hardware Pedometer
    _stepSub = repo.stepStream.listen(
      (event) => _handleStep(event, isTawaf),
      onError: (_) => _handleSensorError(AutoCounterStrings.stepSensorError),
    );

    // Walking Statu
    _walkSub = repo.walkingStatusStream.listen(
      _handleWalkingStatus,
      onError: (_) {},
    );

    //لجيروسكوب — قياس الدوران
    _gyroSub = repo.gyroscopeStream.listen(
      (reading) => isTawaf ? _processTawaf(reading) : _processSaee(reading),
      onError: (_) =>
          _handleSensorError(AutoCounterStrings.gyroscopeSensorError),
    );
  }

  // معالجة الخطوات
  // ═══════════════════════════════════════════════════════════

  void _handleStep(StepEvent event, bool isTawaf) {
    if (!ref.mounted) return;

    if (_lastTotalSteps == -1) {
      _lastTotalSteps = event.totalSteps;
      return;
    }

    //تجاهل قراءات غير منطقية
    final int delta = event.totalSteps - _lastTotalSteps;
    if (delta <= 0 || delta > 10) {
      _lastTotalSteps = event.totalSteps;
      return;
    }

    _lastTotalSteps = event.totalSteps;
    // أعد تشغيل مؤقت التوقف مع كل خطوة جديدة
    _resetStoppedTimer();

    final int newSteps = state.stepsInCurrentLap + delta;
    state = state.copyWith(isMoving: true, stepsInCurrentLap: newSteps);

    // الشوط 7 في السعي: يكتمل بالوصول للمروة بلا التفاف
    if (!isTawaf && state.currentLap == 7 && newSteps >= _saeeLastLapMinSteps) {
      final int elapsed = DateTime.now().difference(_lapStartTime).inSeconds;
      if (elapsed >= _saeeMinSeconds) {
        _onLapCompleted();
        return;
      }
    }

    _checkLapCompletion(isTawaf);
  }

  // معالجة حالة المشي
  // ═══════════════════════════════════════════════════════════

  void _handleWalkingStatus(WalkingStatus status) {
    if (!ref.mounted) return;

    if (!status.isWalking && state.isMoving) {
      _startStoppedCountdown();
    } else if (status.isWalking && !state.isMoving) {
      _stoppedTimer?.cancel();
    }
  }

  void _resetStoppedTimer() {
    _stoppedTimer?.cancel();
    _stoppedTimer = Timer(
      const Duration(milliseconds: _stoppedThresholdMs),
      _onWalkingStopped,
    );
  }

  void _startStoppedCountdown() {
    _stoppedTimer?.cancel();
    _stoppedTimer = Timer(
      const Duration(milliseconds: _stoppedThresholdMs),
      _onWalkingStopped,
    );
  }

  void _onWalkingStopped() {
    if (!ref.mounted) return;
    if (state.isMoving) {
      state = state.copyWith(isMoving: false);
      _lastGyroTime = null;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // منطق الطواف
  //ثلاثة مستويات من الفلترة
  // ═══════════════════════════════════════════════════════════

  void _processTawaf(GyroscopeReading reading) {
    if (!ref.mounted) return;
    //لا تكامل اذا الحاج واقف
    if (!state.isMoving) {
      _lastGyroTime = null;
      return;
    }

    final now = reading.timestamp;
    if (_lastGyroTime == null) {
      _lastGyroTime = now;
      return;
    }

    final double dt =
        now.difference(_lastGyroTime!).inMicroseconds / 1_000_000.0;
    _lastGyroTime = now;
    if (dt <= 0 || dt > 0.5) return;

    final double absRate = reading.zRate.abs();
    //فلتر الضجيج
    if (absRate < _gyroNoise) return;

    //  الفلتر الثالث: هز الهاتف
    if (absRate > _gyroMaxRate) return;

    //الفلتر الرابع: القفزات المغناطيسية
    final double delta = reading.zRate * dt;
    if (delta.abs() > _gyroMaxDeltaPerFrame) return;
    //التكامل الموقَّع
    _tawafSignedAngle += delta;

    //تحديث الواجهة
    state = state.copyWith(accumulatedAngle: _tawafSignedAngle.abs());

    //التحقق المركزي من الشروط
    _checkLapCompletion(true);
  }

  // منطق السعي
  // ═══════════════════════════════════════════════════════════

  void _processSaee(GyroscopeReading reading) {
    if (!ref.mounted) return;
    if (!state.isMoving) {
      _lastGyroTime = null;
      return;
    }

    final now = reading.timestamp;
    if (_lastGyroTime == null) {
      _lastGyroTime = now;
      return;
    }

    final double dt =
        now.difference(_lastGyroTime!).inMicroseconds / 1_000_000.0;
    _lastGyroTime = now;
    if (dt <= 0 || dt > 0.5) return;
    //فلترة الضجيج فقط
    if (reading.zRate.abs() < _gyroNoise) return;

    // فلتر القفزات المغناطيسية
    final double delta = reading.zRate * dt;
    if (delta.abs() > _gyroMaxDeltaPerFrame) return;

    _saeeSignedAngle += delta;

    //التحقق المركزي من الشروط
    _checkLapCompletion(false);
  }

  // فحص اكتمال الشوط (مركزي)
  // ═══════════════════════════════════════════════════════════

  void _checkLapCompletion(bool isTawaf) {
    if (!ref.mounted) return;
    final int elapsed = DateTime.now().difference(_lapStartTime).inSeconds;

    if (isTawaf) {
      if (_tawafSignedAngle.abs() >= _tawafLapAngle) {
        if (state.stepsInCurrentLap >= _tawafMinSteps &&
            elapsed >= _tawafMinSeconds) {
          _onLapCompleted();
        } else if (_tawafSignedAngle.abs() > 600.0) {
          _tawafSignedAngle = 0.0;
          state = state.copyWith(accumulatedAngle: 0.0);
        }
      }
    } else {
      if (state.currentLap < 7 &&
          !state.turnDetected &&
          _saeeSignedAngle.abs() >= _saeeUTurnAngle) {
        if (state.stepsInCurrentLap >= _saeeMinStepsBeforeUTurn &&
            elapsed >= _saeeMinSeconds) {
          state = state.copyWith(turnDetected: true);
          _onLapCompleted();
        } else if (_saeeSignedAngle.abs() > 360.0) {
          _saeeSignedAngle = 0.0;
        }
      }
    }
  }

  // اكتمال الشوط
  // ═══════════════════════════════════════════════════════════

  void _onLapCompleted() {
    if (!ref.mounted) return;
    _triggerVibration();
    ref
        .read(autoCounterNotificationProvider)
        .showLapNotification(
          completedLap: state.currentLap,
          isTawaf: state.trackingType == TrackingType.tawaf,
        );
    _resetLapCounters();

    if (state.currentLap < 7) {
      final newLap = state.currentLap + 1;
      state = state.copyWith(
        currentLap: newLap,
        stepsInCurrentLap: 0,
        accumulatedAngle: 0.0,
        turnDetected: false,
        startHeading: -1.0,
        isMoving: false,
      );
      ref
          .read(autoCounterStorageProvider)
          .saveState(
            isTawaf: state.trackingType == TrackingType.tawaf,
            lap: newLap,
            isRunning: true,
          );
    } else {
      _finishProcess();
    }
  }

  void _finishProcess() {
    if (!ref.mounted) return;
    _triggerVibration(isFinal: true);
    ref
        .read(autoCounterNotificationProvider)
        .showCompletionNotification(
          isTawaf: state.trackingType == TrackingType.tawaf,
        );
    _cleanup();
    ref.read(autoCounterStorageProvider).clearSavedState();
    state = state.copyWith(isRunning: false, isCompleted: true, currentLap: 7);
  }

  void _resetLapCounters() {
    _lastTotalSteps = -1;
    _lastGyroTime = null;
    _tawafSignedAngle = 0.0;
    _saeeSignedAngle = 0.0;
    _lapStartTime = DateTime.now();
  }

  // مساعدات
  // ═══════════════════════════════════════════════════════════

  void _handleSensorError(String message) {
    if (!ref.mounted) return;
    state = state.copyWith(permissionError: message);
    _cleanup();
  }

  void _cleanup() {
    WakelockPlus.disable();
    _stepSub?.cancel();
    _walkSub?.cancel();
    _gyroSub?.cancel();
    _keepAliveSub?.cancel();
    _stoppedTimer?.cancel();
    _stepSub = null;
    _walkSub = null;
    _gyroSub = null;
    _keepAliveSub = null;
    _stoppedTimer = null;
    _lastGyroTime = null;
    _lastTotalSteps = -1;
    if (ref.mounted && state.isRunning) {
      state = state.copyWith(isRunning: false, isMoving: false);
    }
  }

  Future<void> _triggerVibration({bool isFinal = false}) async {
    try {
      if (await Vibration.hasVibrator() == true) {
        Vibration.vibrate(duration: isFinal ? 1000 : 400);
      }
    } catch (_) {}
  }

  //إدارة العمل في الخلفية
  void _startForegroundKeepAlive() {
    if (!Platform.isAndroid) return;
    _keepAliveSub = Geolocator.getPositionStream(
      locationSettings: AndroidSettings(
        accuracy: LocationAccuracy.low,
        distanceFilter: 1000,
        foregroundNotificationConfig: ForegroundNotificationConfig(
          // notificationTitle: 'يُسر - العداد التلقائي نشط',
          // notificationText: 'جاري حساب أشواطك بدقة في الخلفية',
          notificationTitle: AutoCounterStrings.foregroundNotificationTitle,
          notificationText: AutoCounterStrings.foregroundNotificationBody,
          enableWakeLock: true,
        ),
      ),
    ).listen((_) {});
  }
}
