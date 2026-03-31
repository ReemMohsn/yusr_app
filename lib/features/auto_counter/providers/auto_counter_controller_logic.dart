import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:pedometer/pedometer.dart';
import 'state/auto_counter_state.dart';

part 'auto_counter_controller_logic.g.dart';

@riverpod
class AutoCounterControllerLogic extends _$AutoCounterControllerLogic {
  StreamSubscription? _gyroSub;
  StreamSubscription? _accelSub;
  StreamSubscription? _stepSub;

  // إعدادات الدقة
  static const double _moveThreshold = 0.15;
  static const double _gyroDeadZone = 0.01;
  // حد الأمان: لا نبحث عن الالتفاف إلا بعد 300 خطوة
  static const int _minStepsToStartLookingForTurn = 300;
  // زاوية الالتفاف المطلوبة لاعتبار الشوط منتهياً (140 درجة كافية لرصد الاستدارة عند الصفا والمروة)
  static const double _turnThreshold = 140.0;

  // متغير داخلي لتتبع الدوران في السعي (لا يحتاج أن يكون في الـ State)
  double _saeeTurnAngle = 0.0;

  @override
  AutoCounterState build() {
    ref.onDispose(() => _stopAllSensors());
    return const AutoCounterState();
  }

  void startTracking(TrackingType type) async {
    state = state.copyWith(permissionError: null);

    if (type == TrackingType.saee) {
      var status = await Permission.activityRecognition.request();
      if (!status.isGranted) {
        state = state.copyWith(
          isRunning: false,
          permissionError:
              "نحتاج لتفعيل إذن النشاط البدني لعد خطوات السعي تلقائياً.",
        );
        return;
      }
    }

    _stopAllSensors();
    _saeeTurnAngle = 0.0; // تصفير زاوية الالتفاف عند البدء الجديد

    state = state.copyWith(
      isRunning: true,
      isCompleted: false,
      currentLap: 0,
      accumulatedAngle: 0.0,
      stepsInCurrentLap: 0,
      startSteps: 0,
      trackingType: type,
    );
    _initSensors();
  }

  void _initSensors() {
    _accelSub = userAccelerometerEventStream().listen((
      UserAccelerometerEvent event,
    ) {
      double totalMotion = event.x.abs() + event.y.abs() + event.z.abs();
      bool moving = totalMotion > _moveThreshold;
      if (state.isMoving != moving) {
        state = state.copyWith(isMoving: moving);
      }
    });

    _gyroSub = gyroscopeEventStream().listen((GyroscopeEvent event) {
      if (state.isRunning && state.isMoving) {
        if (state.trackingType == TrackingType.tawaf) {
          _processTawafLogic(event);
        } else if (state.trackingType == TrackingType.saee) {
          // استخدام الجيروسكوب في السعي لرصد الالتفاف عند الصفا والمروة
          _processSaeeTurnLogic(event);
        }
      }
    });

    _stepSub = Pedometer.stepCountStream.listen((StepCount event) {
      if (state.trackingType == TrackingType.saee && state.isRunning) {
        _processSaeeStepsLogic(event.steps);
      }
    });
  }

  // منطق الطواف
  void _processTawafLogic(GyroscopeEvent event) {
    double deltaAngle = event.z * (180 / 3.14) * 0.02;
    if (deltaAngle.abs() > _gyroDeadZone) {
      double newAngle = state.accumulatedAngle + deltaAngle;
      if (newAngle.abs() >= 360) {
        _onLapCompleted();
      } else {
        state = state.copyWith(accumulatedAngle: newAngle);
      }
    }
  }

  // منطق خطوات السعي
  void _processSaeeStepsLogic(int totalSteps) {
    if (state.startSteps == 0) {
      state = state.copyWith(startSteps: totalSteps);
      return;
    }
    int stepsDiff = totalSteps - state.startSteps;
    state = state.copyWith(stepsInCurrentLap: stepsDiff);
  }

  // منطق الالتفاف في السعي (هو المسؤول عن إنهاء الشوط)
  void _processSaeeTurnLogic(GyroscopeEvent event) {
    // نحسب الدوران حول المحور الرأسي للجهاز
    double delta = event.z * (180 / 3.14) * 0.02;
    _saeeTurnAngle += delta;

    // الشرط الذكي:
    // 1. يجب أن يكون المعتمر قد قطع عدداً معقولاً من الخطوات (صمام أمان المسافة)
    // 2. يجب أن يرصد الجيروسكوب التفافاً حقيقياً (تغيير اتجاه)
    if (state.stepsInCurrentLap >= _minStepsToStartLookingForTurn &&
        _saeeTurnAngle.abs() >= _turnThreshold) {
      _onLapCompleted();
      _saeeTurnAngle = 0.0; // تصفير الزاوية للشوط القادم

      // ملاحظة: إعادة تعيين startSteps ستحدث تلقائياً في Pedometer stream
      // بمجرد أن يتم استدعاء _onLapCompleted وتصفير الـ state
    }
  }

  void _onLapCompleted() {
    int nextLap = state.currentLap + 1;
    if (nextLap >= 7) {
      state = state.copyWith(
        currentLap: 7,
        isCompleted: true,
        isRunning: false,
      );
      _stopAllSensors();
    } else {
      state = state.copyWith(
        currentLap: nextLap,
        accumulatedAngle: 0.0,
        stepsInCurrentLap: 0,
        startSteps:
            0, // تصفير البداية ليتم التقاط القيمة الجديدة في الخطوة القادمة
      );
    }
  }

  void reset() {
    _stopAllSensors();
    state = const AutoCounterState();
  }

  void _stopAllSensors() {
    _gyroSub?.cancel();
    _accelSub?.cancel();
    _stepSub?.cancel();
    _gyroSub = null;
    _accelSub = null;
    _stepSub = null;
  }
}
