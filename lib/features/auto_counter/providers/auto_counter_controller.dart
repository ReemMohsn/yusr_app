import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vibration/vibration.dart';
import 'state/auto_counter_state.dart'; 

part 'auto_counter_controller.g.dart';

// --- 1. تعريف شكل البيانات الخام القادمة من المستشعرات ---
class TawafRawData {
  final double heading;
  final int stepCount;
  TawafRawData({required this.heading, required this.stepCount});
}

// --- 2. المحرك الوهمي (Mock Engine) - تم وضعه هنا كبديل للملف المفقود ---
class MockTawafEngine {
  StreamController<TawafRawData>? _controller;
  Timer? _timer;
  double _angle = 0;
  int _steps = 0;

  Stream<TawafRawData> get dataStream => _controller!.stream;

  void start() {
    _controller = StreamController<TawafRawData>();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _angle = (_angle + 15) % 360; // محاكاة دوران الحاج
      _steps += 2; // محاكاة المشي
      if (!_controller!.isClosed) {
        _controller!.add(TawafRawData(heading: _angle, stepCount: _steps));
      }
    });
  }

  void stop() {
    _timer?.cancel();
    _controller?.close();
  }
}

@riverpod
MockTawafEngine mockEngine(Ref ref) {
  return MockTawafEngine();
}

@riverpod
class AutoCounterController extends _$AutoCounterController {
  StreamSubscription? _subscription;

  @override
  AutoCounterState build() {
    // تنظيف الموارد تلقائياً عند إغلاق الشاشة أو الـ Provider
    ref.onDispose(() {
      _subscription?.cancel();
    });
    return const AutoCounterState();
  }

  /// بدء الطواف
  void startTracking() {
    if (state.isRunning) return;

    state = state.copyWith(
      isRunning: true,
      isCompleted: false,
      currentLap: 1,
      accumulatedAngle: 0,
      stepsInCurrentLap: 0,
    );

    final engine = ref.read(mockEngineProvider);
    engine.start();

    // الاستماع لبيانات المحرك الوهمي
    _subscription = engine.dataStream.listen((data) {
      _processData(data);
    });
  }

  void _processData(TawafRawData data) {
    // تحديث الحالة بالبيانات القادمة
    state = state.copyWith(
      accumulatedAngle: data.heading,
      stepsInCurrentLap: data.stepCount,
    );

    // لتجربة الاهتزاز الآن: إذا وصل لزاوية قريبة من 360 (دورة كاملة)
    if (state.accumulatedAngle >= 345 && state.stepsInCurrentLap >= 20) { 
      _onLapCompleted();
    }
  }

  void _onLapCompleted() {
    _triggerVibration();
    
    if (state.currentLap < state.totalLaps) {
      state = state.copyWith(
        currentLap: state.currentLap + 1,
        accumulatedAngle: 0,
        stepsInCurrentLap: 0,
      );
    } else {
      _finishTawaf();
    }
  }

  void _finishTawaf() {
    state = state.copyWith(
      isRunning: false, 
      isCompleted: true,
      currentLap: 7, 
    );
    _triggerVibration(); 
    ref.read(mockEngineProvider).stop();
    _subscription?.cancel();
  }

  void reset() {
    ref.read(mockEngineProvider).stop();
    _subscription?.cancel();
    state = const AutoCounterState();
  }
Future<void> _triggerVibration() async {
  if (await Vibration.hasVibrator()) {
    Vibration.vibrate(
      pattern: [
        0,   // ابدأ فوراً
        300, // نبضة 1 (قوية جداً)
        100, // فاصل قصير جداً لزيادة حدة الشعور بالنبضة التالية
        300, // نبضة 2
        100, // فاصل
        300, // نبضة 3
        100, // فاصل
        300, // نبضة 4
        100, // فاصل
        400  // نبضة 5 (الأطول والختامية لضمان أقصى تنبيه)
      ],
    );
  }
}
//   Future<void> _triggerVibration() async {
//   if (await Vibration.hasVibrator()) {
//     // التحقق مما إذا كان الجهاز يدعم التحكم في الشدة (Amplitude)
//     if (await Vibration.hasAmplitudeControl()) {
//       Vibration.vibrate(
//         pattern: [0, 500, 200, 500], // اهتزاز نصف ثانية، توقف بسيط، ثم نصف ثانية أخرى
//         intensities: [0, 255, 0, 255], // 255 هي أقصى قوة ممكنة للمحرك
//       );
//     } else {
//       // إذا كان الجهاز لا يدعم التحكم بالشدة، نكتفي بنمط طويل وقوي
//       Vibration.vibrate(pattern: [0, 1000]); // اهتزاز متواصل لمدة ثانية كاملة
//     }
//   }
// }
}