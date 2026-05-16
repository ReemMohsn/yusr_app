import 'dart:async';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../data/repositories/sensors_repository.dart';
import 'state/auto_counter_state.dart';
import 'counter_provider.dart';

part 'auto_counter_controller.g.dart';

// مفاتيح حفظ الحالة في SharedPreferences

const _kSavedLap = 'tawaf_saved_lap';
const _kSavedType = 'tawaf_saved_type'; // true=طواف false=سعي
const _kSavedRunning = 'tawaf_saved_running';

@riverpod
class AutoCounterController extends _$AutoCounterController {
  //  ثوابت الضبط — Hardware Pedometer
  // ═══════════════════════════════════════════════════════════

  /// نافذة زمنية لاعتبار الحاج "واقفاً" إذا لم تأتِ خطوة جديدة (ms)
  /// 10000ms (10 ثوانٍ) = يمنح الحاج وقتاً لتأخر حساس الخطوات دون أن يوقف الجيروسكوب
  static const int _stoppedThresholdMs = 10000;

  // ثوابت الضبط — الجيروسكوب
  // ═══════════════════════════════════════════════════════════

  /// الحد الأدنى لسرعة الجيروسكوب (deg/s) — يُلغي الضجيج الساكن
  static const double _gyroNoise = 2.0;

  /// الحد الأقصى لسرعة الجيروسكوب (deg/s) — يمنع احتساب هز الهاتف العنيف
  /// أرجحة اليد السريعة جداً قد تصل إلى 250 درجة/ثانية
  static const double _gyroMaxRate = 250.0;

  /// أقصى تغيير مسموح في الزاوية بين قراءتين متتاليتين (deg)
  /// أي قفزة أكبر = تداخل مغناطيسي أو اهتزاز عنيف → تُتجاهل
  static const double _gyroMaxDeltaPerFrame = 25.0;

  //  ثوابت الضبط — الطواف
  // ═══════════════════════════════════════════════════════════

  /// زاوية اكتمال الشوط (345° بدل 360° لتعويض انجراف الجيروسكوب)
  static const double _tawafLapAngle = 345.0;

  /// الحد الأدنى للخطوات لاعتبار الشوط حقيقياً
  // static const int _tawafMinSteps = 200;
  static const int _tawafMinSteps = 10;

  /// الحد الأدنى للوقت بالثواني لاعتبار الشوط حقيقياً
  // static const int _tawafMinSeconds = 120;
  static const int _tawafMinSeconds = 5;

  //  ثوابت الضبط — السعي
  // ═══════════════════════════════════════════════════════════

  /// زاوية الالتفاف (U-Turn) بين الصفا والمروة
  static const double _saeeUTurnAngle = 130.0;

  /// الحد الأدنى للخطوات قبل اعتبار الالتفاف حقيقياً
  // static const int _saeeMinStepsBeforeUTurn = 400;
  static const int _saeeMinStepsBeforeUTurn = 10;

  /// الحد الأدنى للوقت بالثواني لإتمام شوط سعي
  // static const int _saeeMinSeconds = 180;
  static const int _saeeMinSeconds = 5;

  /// الحد الأدنى لخطوات الشوط 7 في السعي (الوصول للمروة بلا التفاف)
  // static const int _saeeLastLapMinSteps = 500;
  static const int _saeeLastLapMinSteps = 10;

  // متغيرات داخلية
  // ═══════════════════════════════════════════════════════════

  StreamSubscription<StepEvent>? _stepSub;
  StreamSubscription<WalkingStatus>? _walkSub;
  StreamSubscription<GyroscopeReading>? _gyroSub;
  StreamSubscription<Position>? _keepAliveSub;
  //مؤقت يقوم بالحساب بمجرد توقف الخطوات ليصل ل 10 ث ثم يقوم باطفاء الروابط الاخرى لتوفير الطاقة
  Timer? _stoppedTimer;

  // — Pedometer —
  int _lastTotalSteps = -1; // -1 يعني "لم نبدأ بعد"

  // — الجيروسكوب —
  DateTime? _lastGyroTime;
  double _tawafSignedAngle = 0.0; // الزاوية الموقَّعة للطواف
  double _saeeSignedAngle = 0.0; // الزاوية للسعي (تُصفَّر بعد كل التفاف)

  // — التوقيت —
  //يحفظ زمن بدء الشوط
  DateTime _lapStartTime = DateTime.now();

  // — الإشعارات —
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  bool _notificationsInitialized = false;

  //  البناء الأولي

  @override
  AutoCounterState build() {
    ref.onDispose(_cleanup);
    _initNotifications();
    return const AutoCounterState();
  }

  // Public API
  // ═══════════════════════════════════════════════════════════

  /// بدء التتبع — يستعيد الشوط المحفوظ إذا كان التطبيق أُغلق مسبقاً
  Future<void> startTracking() async {
    if (state.isRunning) return;

    // طلب صلاحية Activity Recognition (Android 10+)
    final status = await Permission.activityRecognition.request();
    if (!status.isGranted) {
      state = state.copyWith(
        permissionError: 'يرجى منح صلاحية رصد النشاط الحركي من إعدادات الجهاز',
      );
      return;
    }

    final isTawaf = ref.read(counterTypeControllerProvider);

    // استعادة الشوط المحفوظ لو كان هناك جلسة سابقة لم تكتمل
    final savedLap = await _loadSavedLap(isTawaf);

    // تهيئة الحالة
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
      isMoving: true, // البدء بحالة حركة لضمان التقاط الزوايا الأولى فوراً
      turnDetected: false,
      startHeading: -1.0,
      permissionError: null,
      trackingType: isTawaf ? TrackingType.tawaf : TrackingType.saee,
    );

    await _saveState(isTawaf: isTawaf, lap: savedLap, isRunning: true);
    WakelockPlus.enable(); // إبقاء الشاشة/المعالج مستيقظاً لضمان عمل الحساسات
    _startSensors(isTawaf);
  }

  void stop() => _cleanup();

  void reset() {
    _cleanup();
    _clearSavedState();
    state = const AutoCounterState();
  }

  /// تصحيح يدوي + (زيادة شوط)
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
    _saveState(
      isTawaf: state.trackingType == TrackingType.tawaf,
      lap: newLap,
      isRunning: true,
    );
  }

  /// تصحيح يدوي - (إنقاص شوط)
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
    _saveState(
      isTawaf: state.trackingType == TrackingType.tawaf,
      lap: newLap,
      isRunning: true,
    );
  }

  // تشغيل الحساسات
  // ═══════════════════════════════════════════════════════════

  void _startSensors(bool isTawaf) {
    final repo = SensorsRepository();

    // ── 0. تفعيل خدمة الخلفية (Keep Alive) لضمان وصول بيانات الحساسات والشاشة مغلقة ──
    _startForegroundKeepAlive();

    // ── 1. Hardware Pedometer — عداد الخطوات الدقيق ──────────
    _stepSub = repo.stepStream.listen(
      (event) => _handleStep(event, isTawaf),
      onError: (_) => _handleSensorError('تعذّر الوصول لعداد الخطوات'),
    );

    // ── 2. Walking Status — رصد التوقف والاستئناف ────────────
    _walkSub = repo.walkingStatusStream.listen(
      (status) => _handleWalkingStatus(status),
      onError: (_) {
        /* Pedometer.pedestrianStatusStream قد لا يتوفر على بعض الأجهزة */
      },
    );

    // ── 3. الجيروسكوب — قياس الدوران ─────────────────────────
    _gyroSub = repo.gyroscopeStream.listen(
      (reading) => isTawaf ? _processTawaf(reading) : _processSaee(reading),
      onError: (_) => _handleSensorError('تعذّر الوصول للجيروسكوب'),
    );
  }

  // معالجة الخطوات

  void _handleStep(StepEvent event, bool isTawaf) {
    if (_lastTotalSteps == -1) {
      // أول قراءة — نحفظها كمرجع ولا نضيف شيئاً
      _lastTotalSteps = event.totalSteps;
      return;
    }

    final int delta = event.totalSteps - _lastTotalSteps;

    // تجاهل قراءات غير منطقية (مثل إعادة تشغيل الجهاز)
    if (delta <= 0 || delta > 10) {
      _lastTotalSteps = event.totalSteps;
      return;
    }

    _lastTotalSteps = event.totalSteps;

    // أعد تشغيل مؤقت التوقف مع كل خطوة جديدة
    _resetStoppedTimer();

    final int newSteps = state.stepsInCurrentLap + delta;
    state = state.copyWith(isMoving: true, stepsInCurrentLap: newSteps);

    // ── الشوط 7 في السعي: يكتمل بالوصول للمروة (بلا التفاف) ──
    if (!isTawaf && state.currentLap == 7 && newSteps >= _saeeLastLapMinSteps) {
      final int secondsInLap = DateTime.now()
          .difference(_lapStartTime)
          .inSeconds;
      if (secondsInLap >= _saeeMinSeconds) {
        _onLapCompleted();
      }
    }

    // التحقق المركزي من الشروط بعد كل خطوة لتفادي ضياع الأشواط
    _checkLapCompletionConditions(isTawaf);
  }

  // معالجة حالة المشي
  // ═══════════════════════════════════════════════════════════

  void _handleWalkingStatus(WalkingStatus status) {
    if (!status.isWalking && state.isMoving) {
      // الجهاز أعلن التوقف → نعطيه 3 ثوانٍ قبل الإعلان الرسمي
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
    if (state.isMoving) {
      state = state.copyWith(isMoving: false);
      // أوقف تكامل الجيروسكوب — أعد مرجع الوقت لمنع قفزة dt عند الاستئناف
      _lastGyroTime = null;
    }
  }

  // ثلاثة مستويات من الفلترة:
  //   1. فلتر المشي: لا تكامل إذا isMoving=false
  //   2. فلتر الضجيج: تجاهل < 2 deg/s
  //   3. فلتر القفزات: تجاهل > 15° بين قراءتين (تداخل مغناطيسي)
  // ═══════════════════════════════════════════════════════════

  void _processTawaf(GyroscopeReading reading) {
    // ── القفل الأول: لا تكامل إذا الحاج واقف ──
    if (!state.isMoving) {
      _lastGyroTime = null;
      return;
    }

    // ── حساب dt بدقة ──
    final now = reading.timestamp;
    if (_lastGyroTime == null) {
      _lastGyroTime = now;
      return;
    }

    final double dt =
        now.difference(_lastGyroTime!).inMicroseconds / 1_000_000.0;
    _lastGyroTime = now;

    // تجاهل dt غير منطقي
    if (dt <= 0 || dt > 0.5) return;

    final double absRate = reading.zRate.abs();

    // ── الفلتر الثاني: الضجيج الساكن ──
    if (absRate < _gyroNoise) return;

    // ── الفلتر الثالث: هز الهاتف ──
    if (absRate > _gyroMaxRate) return;

    // ── الفلتر الرابع: القفزات المغناطيسية ──
    // أقصى تغيير مسموح بين قراءتين = 15° (مستحيل بشرياً تجاوزه في 20ms)
    final double degreesThisFrame = reading.zRate * dt;
    if (degreesThisFrame.abs() > _gyroMaxDeltaPerFrame) return;

    // ── التكامل الموقَّع ──
    _tawafSignedAngle += degreesThisFrame;

    // حدّث الـ UI
    state = state.copyWith(accumulatedAngle: _tawafSignedAngle.abs());

    // التحقق المركزي من الشروط
    _checkLapCompletionConditions(true);
  }

  // ═══════════════════════════════════════════════════════════
  //منطق السعي — رصد الالتفاف بالجيروسكوب

  void _processSaee(GyroscopeReading reading) {
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

    // فلتر الضجيج فقط (لا نفلتر السرعة العليا — الالتفاف سريع بطبيعته)
    if (reading.zRate.abs() < _gyroNoise) return;

    // فلتر القفزات المغناطيسية
    final double degreesThisFrame = reading.zRate * dt;
    if (degreesThisFrame.abs() > _gyroMaxDeltaPerFrame) return;

    _saeeSignedAngle += degreesThisFrame;

    // التحقق المركزي من الشروط
    _checkLapCompletionConditions(false);
  }

  // ═══════════════════════════════════════════════════════════
  //  فحص الشروط المركزي (إصلاح خلل ضياع الأشواط)

  void _checkLapCompletionConditions(bool isTawaf) {
    final now = DateTime.now();
    final int secondsInLap = now.difference(_lapStartTime).inSeconds;

    if (isTawaf) {
      if (_tawafSignedAngle.abs() >= _tawafLapAngle) {
        if (state.stepsInCurrentLap >= _tawafMinSteps &&
            secondsInLap >= _tawafMinSeconds) {
          _onLapCompleted();
        } else if (_tawafSignedAngle.abs() > 600.0) {
          // تجاوز الزاوية بشكل مبالغ فيه جداً دون إكمال الخطوات يعني تلاعباً
          _tawafSignedAngle = 0.0;
          state = state.copyWith(accumulatedAngle: 0.0);
        }
      }
    } else {
      if (state.currentLap < 7 &&
          !state.turnDetected &&
          _saeeSignedAngle.abs() >= _saeeUTurnAngle) {
        if (state.stepsInCurrentLap >= _saeeMinStepsBeforeUTurn &&
            secondsInLap >= _saeeMinSeconds) {
          state = state.copyWith(turnDetected: true);
          _onLapCompleted();
        } else if (_saeeSignedAngle.abs() > 360.0) {
          // التفافات وهمية كثيرة
          _saeeSignedAngle = 0.0;
        }
      }
    }
  }

  // اكتمال الشوط
  // ═══════════════════════════════════════════════════════════

  void _onLapCompleted() {
    _triggerVibration();
    _showLapNotification(state.currentLap);
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
      _saveState(
        isTawaf: state.trackingType == TrackingType.tawaf,
        lap: newLap,
        isRunning: true,
      );
    } else {
      _finishProcess();
    }
  }

  void _finishProcess() {
    _triggerVibration(isFinal: true);
    _showCompletionNotification();
    _cleanup();
    _clearSavedState();
    state = state.copyWith(isRunning: false, isCompleted: true, currentLap: 7);
  }

  void _resetLapCounters() {
    _lastTotalSteps = -1;
    _lastGyroTime = null;
    _tawafSignedAngle = 0.0;
    _saeeSignedAngle = 0.0;
    _lapStartTime = DateTime.now();
  }

  // حفظ الحالة (SharedPreferences)
  // ═══════════════════════════════════════════════════════════

  Future<void> _saveState({
    required bool isTawaf,
    required int lap,
    required bool isRunning,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_kSavedLap, lap);
      await prefs.setBool(_kSavedType, isTawaf);
      await prefs.setBool(_kSavedRunning, isRunning);
    } catch (_) {}
  }

  Future<int> _loadSavedLap(bool isTawaf) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedRunning = prefs.getBool(_kSavedRunning) ?? false;
      final savedType = prefs.getBool(_kSavedType) ?? isTawaf;

      // استعادة الشوط فقط إذا كان نفس نوع النسك وكانت هناك جلسة سابقة
      if (savedRunning && savedType == isTawaf) {
        return (prefs.getInt(_kSavedLap) ?? 1).clamp(1, 7);
      }
    } catch (_) {}
    return 1;
  }

  Future<void> _clearSavedState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kSavedLap);
      await prefs.remove(_kSavedType);
      await prefs.remove(_kSavedRunning);
    } catch (_) {}
  }

  // الإشعارات المحلية
  // ═══════════════════════════════════════════════════════════

  Future<void> _initNotifications() async {
    if (_notificationsInitialized) return;
    try {
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const settings = InitializationSettings(android: androidSettings);
      await _notifications.initialize(settings);
      _notificationsInitialized = true;
    } catch (_) {}
  }

  Future<void> _showLapNotification(int completedLap) async {
    if (!_notificationsInitialized) return;
    final type = state.trackingType == TrackingType.tawaf ? 'الطواف' : 'السعي';
    final remaining = 7 - completedLap;
    try {
      await _notifications.show(
        completedLap,
        '✅ $type — الشوط $completedLap مكتمل',
        remaining > 0 ? 'تبقّى $remaining أشواط' : 'اكتمل النسك بحمد الله!',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'tawaf_counter',
            'عداد الطواف والسعي',
            importance: Importance.high,
            priority: Priority.high,
            playSound: false,
          ),
        ),
      );
    } catch (_) {}
  }

  Future<void> _showCompletionNotification() async {
    if (!_notificationsInitialized) return;
    final type = state.trackingType == TrackingType.tawaf ? 'الطواف' : 'السعي';
    try {
      await _notifications.show(
        100,
        '🎉 تم إتمام $type',
        'اكتملت الأشواط السبعة بحمد الله وفضله',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'tawaf_counter',
            'عداد الطواف والسعي',
            importance: Importance.max,
            priority: Priority.max,
            playSound: true,
          ),
        ),
      );
    } catch (_) {}
  }

  // مساعدات
  // ═══════════════════════════════════════════════════════════

  void _handleSensorError(String message) {
    state = state.copyWith(permissionError: message);
    _cleanup();
  }

  void _cleanup() {
    WakelockPlus.disable(); // السماح للنظام بالنوم مجدداً
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

    if (state.isRunning) {
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

  // إدارة العمل في الخلفية (Foreground Service)
  // ═══════════════════════════════════════════════════════════

  /// تشغيل خدمة أمامية (Trick) لإبقاء الحساسات تعمل والشاشة مغلقة
  void _startForegroundKeepAlive() {
    if (Platform.isAndroid) {
      final locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.low,
        distanceFilter:
            1000, // لا نحتاج تحديثات موقع فعلية، فقط إبقاء الخدمة حية
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText: "جاري حساب أشواطك بدقة في الخلفية",
          notificationTitle: "يُسر - العداد التلقائي نشط",
          enableWakeLock: true,
        ),
      );
      _keepAliveSub = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen((_) {});
    }
  }
}
