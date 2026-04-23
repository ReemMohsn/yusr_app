import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:vibration/vibration.dart';
import '../data/repositories/sensors_repository.dart';
import 'state/auto_counter_state.dart';
import 'counter_provider.dart'; 

final autoCounterControllerLogicProvider =
    StateNotifierProvider<AutoCounterControllerLogic, AutoCounterState>((ref) {
  return AutoCounterControllerLogic(SensorsRepository(), ref);
});

class AutoCounterControllerLogic extends StateNotifier<AutoCounterState> {
  final SensorsRepository _repository;
  final Ref _ref;
  StreamSubscription? _accSub;
  StreamSubscription? _magSub;

  // إعدادات الفلترة
  DateTime _lastStepTime = DateTime.now();
  int _consecutiveSteps = 0;
  double _lastAcc = 0.0;
  double _lastHeading = 0.0;

  AutoCounterControllerLogic(this._repository, this._ref) : super(const AutoCounterState());

  void startTracking() {
    if (state.isRunning) return;
    
    // قراءة نوع النسك من الـ UI Provider (Tawaf or Saee)
    final isTawaf = _ref.read(counterTypeControllerProvider); 

    state = state.copyWith(
      isRunning: true, 
      isCompleted: false, 
      currentLap: 1,
      trackingType: isTawaf ? TrackingType.tawaf : TrackingType.saee,
    );

    _listenToSensors(isTawaf);
  }

  void _listenToSensors(bool isTawaf) {
    // مراقبة المشي (للطرفين)
    _accSub = _repository.accelerationStream.listen((acc) {
      _processWalking(acc, isTawaf);
    });

    // مراقبة الدوران (للطواف فقط)
    if (isTawaf) {
      _magSub = _repository.headingStream.listen(_processRotation);
    }
  }

  void _processWalking(double acc, bool isTawaf) {
    if (_lastAcc > 2.5 && acc < _lastAcc) { // Peak Detection
      final now = DateTime.now();
      int diff = now.difference(_lastStepTime).inMilliseconds;

      if (diff >= 450 && diff <= 1100) {
        _consecutiveSteps++;
        _lastStepTime = now;
        if (_consecutiveSteps >= 2) state = state.copyWith(isMoving: true);
        
        if (!isTawaf && _consecutiveSteps >= 5) {
          _updateSaeeProgress();
        }
      } else if (diff > 1200) {
        _consecutiveSteps = 0;
        state = state.copyWith(isMoving: false);
      }
    }
    _lastAcc = acc;
  }

  void _processRotation(double heading) {
    if (!state.isMoving) return;
    if (_lastHeading == 0) { _lastHeading = heading; return; }

    double delta = (heading - _lastHeading).abs();
    if (delta > 180) delta = 360 - delta;
    
    if (delta > 1.2) {
      double newAngle = state.accumulatedAngle + delta;
      state = state.copyWith(accumulatedAngle: newAngle);
      _lastHeading = heading;

      if (state.accumulatedAngle >= 360) _nextLap();
    }
  }

  void _updateSaeeProgress() {
    int steps = state.stepsInCurrentLap + 1;
    state = state.copyWith(stepsInCurrentLap: steps);
    if (steps >= 20) _nextLap(); // 20 خطوة للتجربة
  }

  void _nextLap() {
    _triggerVibration();
    if (state.currentLap < state.totalLaps) {
      state = state.copyWith(
        currentLap: state.currentLap + 1,
        accumulatedAngle: 0,
        stepsInCurrentLap: 0,
      );
    } else {
      stop();
    }
  }

  void stop() {
    _accSub?.cancel();
    _magSub?.cancel();
    state = state.copyWith(isRunning: false, isCompleted: true);
  }

  void reset() {
    stop();
    state = const AutoCounterState();
  }

  void _triggerVibration() async {
    if (await Vibration.hasVibrator() ?? false) Vibration.vibrate(duration: 500);
  }
}