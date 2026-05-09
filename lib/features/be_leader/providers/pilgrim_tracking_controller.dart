import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vibration/vibration.dart';
import 'package:yusr/core/common/providers/location_service.dart';
import 'package:yusr/core/common/providers/shared_preferences_service_provider.dart';
import 'package:yusr/core/constants/shared_preferences_keys.dart';
import 'package:yusr/features/be_leader/presentation/services/smart_location_filter_service.dart';
import 'package:yusr/features/be_leader/providers/active_session_id_provider.dart';
import 'package:yusr/features/be_leader/providers/be_leader_repository_provider.dart';
import 'package:yusr/features/be_leader/providers/ble_radar_service_provider.dart';
import 'package:yusr/features/be_leader/providers/state/pilgrim_tracking_state.dart';
import 'package:yusr/features/be_leader/providers/tracking_repository_provider.dart';
import 'package:permission_handler/permission_handler.dart' hide ServiceStatus;

part 'pilgrim_tracking_controller.g.dart';

@Riverpod(keepAlive: true)
class PilgrimTrackingController extends _$PilgrimTrackingController {
  // ─── Subscriptions ────────────────────────────────────────────────────────
  StreamSubscription<Position>? _positionStreamSub;
  StreamSubscription<DatabaseEvent>? _leaderStreamSub;
  StreamSubscription<ServiceStatus>? _serviceStatusSub;
  StreamSubscription<DatabaseEvent>? _myFirebaseDataSub;
  Timer? _leaderTimeoutTimer;

  // ─── حالة الجلسة الحالية ──────────────────────────────────────────────────
  int? _currentSessionId;
  String? _currentPilgrimId;
  String? _currentPilgrimName;

  // ─── فلترة الموقع ─────────────────────────────────────────────────────────
  Position? _lastValidPosition;
  DateTime? _lastUpdateTime;

  // ─── فلترة المشي (مُفوَّضة للخدمة المشتركة) ──────────────────────────────
  final SmartLocationFilterService _locationFilter =
      SmartLocationFilterService();

  // ─── حالة التنبيهات ───────────────────────────────────────────────────────
  DateTime? _redZoneEntryTime;
  bool _hasWarnedYellow = false;
  bool _isSafeByBle = false;
  bool _isAlarmActive = false;
  bool _isMutedManually =
      false; // 🔇 هل أوقف الحاج الصوت يدوياً؟ (لا يعود تلقائياً)
  double?
  _currentBleDistance; // ← مسافة BLE التي أرسلها المشرف — تُعرَض بدلاً من GPS عند التحقق من الأمان
  final int _alarmDelaySeconds = 10;

  final double _yellowZone = 20;
  final double _redZone = 30;

  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  PilgrimTrackingState build() {
    ref.onDispose(stopTracking);
    return PilgrimTrackingState();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // دالة البدء الرئيسية
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> acceptAndStartTracking({
    required int sessionId,
    required String pilgrimId,
    required String pilgrimName,
  }) async {
    state = PilgrimTrackingState(isLoading: true);

    try {
      final trackingApiRepo = ref.read(leaderTrackingApiRepositoryProvider);
      await trackingApiRepo.respondToSession(sessionId, 2);

      _currentSessionId = sessionId;
      _currentPilgrimId = pilgrimId;
      _currentPilgrimName = pilgrimName;

      // 🌟 تحديث المزود التفاعلي ليظهر زر الهيدر فوراً
      ref.read(activeSessionIdProvider.notifier).updateSessionId(sessionId);

      final sharedPrefs = ref.read(sharedPreferencesServiceProvider);
      await sharedPrefs.setInt(SharedPreferencesKeys.sessionId, sessionId);

      final locationService = ref.read(locationServiceProvider);

      // 1️⃣ فحص خدمة GPS
      final serviceEnabled = await locationService.isServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('⚠️ [GPS] الخدمة مطفأة عند بدء التتبع.');
        state = PilgrimTrackingState(
          leaderLocation: state.leaderLocation,
          gpsWarning: 'يرجى تفعيل خدمة الـ GPS (الموقع) في هاتفك.',
        );
      }

      // 2️⃣ فحص وطلب صلاحيات الموقع
      final permissionsGranted = await locationService
          .ensurePermissionsGranted();
      if (!permissionsGranted) {
        state = PilgrimTrackingState(
          leaderLocation: state.leaderLocation,
          gpsWarning:
              'لا يمكن بدء التتبع بدون صلاحيات الموقع. يرجى تفعيلها من الإعدادات.',
        );
        return;
      }

      // 3️⃣ طلب صلاحيات البلوتوث (أندرويد 12+)
      await [
        Permission.bluetooth,
        Permission.bluetoothAdvertise,
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
      ].request();

      // 4️⃣ تشغيل عدّاد الخطوات الذكي
      _locationFilter.startSmartStepCounting(tag: ' [الحاج]');

      // 5️⃣ تشغيل بث البلوتوث عبر BleRadarService الموحَّد
      await ref
          .read(bleRadarServiceProvider)
          .initBroadcasting(
            pilgrimId: pilgrimId,
            onWarning: (warningMsg) {
              state = state.copyWith(bleWarning: warningMsg);
            },
          );

      // 6️⃣ مراقبة تشغيل/إيقاف GPS (دالة منفصلة)
      _listenToGpsStatusChanges();

      // 7️⃣ جلب الموقع الأولي
      if (serviceEnabled) {
        final initialPos = await locationService.tryGetCurrentPosition();
        if (initialPos != null) _applyValidPosition(initialPos);
      }

      // 8️⃣ تشغيل Stream الموقع المستمر (دالة منفصلة)
      _startLocationUpdates();

      // 9️⃣ استماع موقع المشرف من Firebase (دالة منفصلة)
      _listenToLeaderStream();

      // 🔟 استماع "صك الأمان" الخاص بي من Firebase (دالة منفصلة)
      _listenToMyPilgrimData();
    } catch (e) {
      state = PilgrimTrackingState(errorMessage: e.toString());
      final sharedPrefs = ref.read(sharedPreferencesServiceProvider);
      await sharedPrefs.removeInt(SharedPreferencesKeys.sessionId);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // دوال مساعدة — موقع الحاج
  // ═══════════════════════════════════════════════════════════════════════════

  /// يُطبِّق موقعاً صالحاً: يحفظه، يُحدِّث Firebase، ويُحدِّث الحالة.
  void _applyValidPosition(Position pos) {
    _lastValidPosition = pos;
    _lastUpdateTime = DateTime.now();

    final currentPos = LatLng(pos.latitude, pos.longitude);
    final trackingRepo = ref.read(trackingRepositoryProvider);

    trackingRepo.updatePilgrimLocation(
      sessionId: _currentSessionId!,
      pilgrimId: _currentPilgrimId!,
      pilgrimName: _currentPilgrimName!,
      location: currentPos,
      isRealMove: true, // ← تحرك حقيقي — يُحدّث lastPositionUpdate في Firebase
    );

    _updateStateAndCheckDistance(
      pilgrimLoc: currentPos,
      leaderLoc: state.leaderLocation,
      clearWarning: true,
    );
  }

  /// يُشغِّل Stream الموقع المستمر مع تطبيق الفلاتر الثلاثة.
  void _startLocationUpdates() {
    final locationService = ref.read(locationServiceProvider);
    final trackingRepo = ref.read(trackingRepositoryProvider);

    _positionStreamSub?.cancel();
    _positionStreamSub = locationService.foregroundPositionStream.listen(
      (Position position) {
        debugPrint(
          '📍 [الحاج] موقع جديد | دقة: ${position.accuracy.toStringAsFixed(1)} م | ${position.latitude}, ${position.longitude}',
        );

        // 🔴 فلتر 1: رفض المواقع ضعيفة الدقة — نبضة الحياة
        if (position.accuracy > 25) {
          debugPrint(
            '⚠️ [الحاج] ❌ دقة ضعيفة (${position.accuracy} م). إرسال نبضة حياة...',
          );
          if (_lastValidPosition != null) {
            // isRealMove: false (افتراضي) — نبضة حياة: تُبقي الجلسة حية بدون تغيير lastPositionUpdate
            trackingRepo.updatePilgrimLocation(
              sessionId: _currentSessionId!,
              pilgrimId: _currentPilgrimId!,
              pilgrimName: _currentPilgrimName!,
              location: LatLng(
                _lastValidPosition!.latitude,
                _lastValidPosition!.longitude,
              ),
            );
          }
          return;
        }

        // 🔴 فلتر 2 + 3: رفض القفزات الوهمية (سرعة و خطوات)
        if (_lastValidPosition != null && _lastUpdateTime != null) {
          final distanceJump = Geolocator.distanceBetween(
            _lastValidPosition!.latitude,
            _lastValidPosition!.longitude,
            position.latitude,
            position.longitude,
          );
          final timeDiffSeconds = DateTime.now()
              .difference(_lastUpdateTime!)
              .inSeconds;

          // فلتر 2: السرعة
          if (_locationFilter.isSpeedJumpValid(
                distanceMeters: distanceJump,
                timeDiffSeconds: timeDiffSeconds,
                tag: ' [الحاج]',
              ) ==
              false) {
            return;
          }

          // فلتر 3: الخطوات
          if (!_locationFilter.isMovementReal(distanceJump, tag: ' [الحاج]')) {
            debugPrint('🛑 [حماية] قفزة GPS وهمية — لا خطوات كافية!');
            return;
          }
        }

        debugPrint('الموقع اجتاز جميع الفلاتر — جاري التحديث في فايربيس...');
        _applyValidPosition(position);
      },
      onError: (error) {
        debugPrint('❌ [الحاج] خطأ في مستمع الموقع: $error');
      },
    );
  }

  /// يُشغِّل مستمع تحديثات موقع المشرف من Firebase.
  /// مُستخرَجة لتوحيد النمط مع [الدوال المنفصلة الأخرى].
  void _listenToLeaderStream() {
    final trackingRepo = ref.read(trackingRepositoryProvider);
    _leaderStreamSub?.cancel();
    _leaderStreamSub = trackingRepo
        .leaderStream(_currentSessionId.toString())
        .listen((DatabaseEvent event) {
          if (event.snapshot.exists) {
            final data = event.snapshot.value as Map<dynamic, dynamic>;
            final lat = data['latitude'];
            final lng = data['longitude'];
            if (lat != null && lng != null) {
              _resetLeaderTimeoutTimer();
              _updateStateAndCheckDistance(leaderLoc: LatLng(lat, lng));
            }
          }
        });
  }

  /// يُشغِّل مستمع بيانات الحاج نفسه من Firebase للتحقق من "صك الأمان" (isSafeByBle).
  void _listenToMyPilgrimData() {
    final trackingRepo = ref.read(trackingRepositoryProvider);
    _myFirebaseDataSub?.cancel();
    _myFirebaseDataSub = trackingRepo
        .pilgrimStream(_currentSessionId.toString(), _currentPilgrimId!)
        .listen((DatabaseEvent event) {
          if (event.snapshot.exists) {
            final data = event.snapshot.value as Map<dynamic, dynamic>;
            final bool isSafe = data['isSafeByBle'] ?? false;

            // ← قراءة مسافة BLE التي أرسلها المشرف لعرضها في الواجهة بدلاً من GPS
            _currentBleDistance = (data['bleDistance'] as num?)?.toDouble();

            if (_isSafeByBle != isSafe) {
              _isSafeByBle = isSafe;
              if (_isSafeByBle) {
                // صك الأمان الجديد: أعد حساب المسافة فوراً لإلغاء أي إنذار نشط
                _updateStateAndCheckDistance(
                  pilgrimLoc: state.pilgrimLocation,
                  leaderLoc: state.leaderLocation,
                );
              } else {
                // انتهى صك الأمان → صفّر مسافة BLE
                _currentBleDistance = null;
              }
            }
          }
        });
  }

  /// يُراقب حالة خدمة GPS ويُعيد التشغيل عند إعادة تفعيلها.
  void _listenToGpsStatusChanges() {
    final locationService = ref.read(locationServiceProvider);

    _serviceStatusSub?.cancel();
    _serviceStatusSub = locationService.serviceStatusStream.listen((
      ServiceStatus status,
    ) async {
      if (status == ServiceStatus.disabled) {
        debugPrint('⚠️ [GPS] تم إغلاق مفتاح GPS!');
        state = PilgrimTrackingState(
          pilgrimLocation: state.pilgrimLocation,
          leaderLocation: state.leaderLocation,
          distance: state.distance,
          gpsWarning: 'تم إغلاق خدمة الموقع (GPS) في الهاتف. يرجى تفعيلها.',
          bleWarning: state.bleWarning,
        );
      } else {
        debugPrint('✅ [GPS] تم تفعيل GPS — إعادة تشغيل المستمع...');
        state = PilgrimTrackingState(
          pilgrimLocation: state.pilgrimLocation,
          leaderLocation: state.leaderLocation,
          distance: state.distance,
          gpsWarning: 'تم تفعيل الـ GPS، جاري التقاط الإشارة...',
          bleWarning: state.bleWarning,
        );
        _startLocationUpdates();
        final quickPos = await locationService.tryGetCurrentPosition();
        if (quickPos != null) _applyValidPosition(quickPos);
      }
    });
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // منطق المسافة والتنبيهات
  // ═══════════════════════════════════════════════════════════════════════════

  void _updateStateAndCheckDistance({
    LatLng? pilgrimLoc,
    LatLng? leaderLoc,
    bool clearWarning = false,
  }) {
    final pLoc = pilgrimLoc ?? state.pilgrimLocation;
    final lLoc = leaderLoc ?? state.leaderLocation;

    if (pLoc == null || lLoc == null) {
      state = PilgrimTrackingState(
        pilgrimLocation: pLoc,
        leaderLocation: lLoc,
        distance: state.distance,
        gpsWarning: clearWarning ? null : state.gpsWarning,
        bleWarning: state.bleWarning,
      );
      return;
    }

    final distance = Geolocator.distanceBetween(
      pLoc.latitude,
      pLoc.longitude,
      lLoc.latitude,
      lLoc.longitude,
    );

    // 🛡️ صك الأمان من البلوتوث يلغي كل الإنذارات
    if (_isSafeByBle) {
      // إذا أرسل المشرف مسافة BLE → نعرضها بدلاً من مسافة GPS المضللة
      final displayedDistance = _currentBleDistance ?? distance;
      debugPrint(
        '🛡️ [الحاج] GPS: ${distance.toStringAsFixed(1)}م | BLE (المعتمد): ${displayedDistance.toStringAsFixed(1)}م — إلغاء الإنذار!',
      );
      _redZoneEntryTime = null;
      _hasWarnedYellow = false;
      stopAlarmManual();
      state = PilgrimTrackingState(
        pilgrimLocation: pLoc,
        leaderLocation: lLoc,
        distance: displayedDistance, // ← مسافة BLE في الواجهة لا GPS
        gpsWarning: clearWarning ? null : state.gpsWarning,
        bleWarning: state.bleWarning,
      );
      return;
    }

    debugPrint(
      '📏 [الحاج] المسافة الحالية بيني وبين المشرف: ${distance.toStringAsFixed(2)} متر',
    );

    state = PilgrimTrackingState(
      pilgrimLocation: pLoc,
      leaderLocation: lLoc,
      distance: distance,
      gpsWarning: clearWarning ? null : state.gpsWarning,
      bleWarning: state.bleWarning,
    );

    if (distance <= _yellowZone) {
      if (_redZoneEntryTime != null || _hasWarnedYellow) {
        debugPrint('🟢 [الحاج] عدت إلى النطاق الآمن!');
      }
      _redZoneEntryTime = null;
      _hasWarnedYellow = false;
      _isMutedManually = false; // إعادة تفعيل الصوت للجولة القادمة
      stopAlarmManual();
      // إلغاء الإشعارات كما يفعل المشرف عند عودة الحاج للأمان
      _notificationsPlugin.cancel(1); // إشعار التحذير
      _notificationsPlugin.cancel(1001); // إشعار الطوارئ
    } else if (distance > _yellowZone && distance <= _redZone) {
      debugPrint('🟡 [الحاج] أنا في النطاق الأصفر (تحذير صامت)');
      _redZoneEntryTime = null;
      _notificationsPlugin.cancel(
        1001,
      ); // إلغاء إشعار الطوارئ عند التحسُّن للأصفر
      stopAlarmManual();
      if (!_hasWarnedYellow) {
        _hasWarnedYellow = true;
        _triggerWarningVibration();
      }
    } else {
      debugPrint('🔴 [الحاج] أنا في النطاق الأحمر!');
      if (_redZoneEntryTime == null) {
        _redZoneEntryTime = DateTime.now();
        debugPrint('⏱️ [الحاج] بدأ عداد الخطر (10 ثواني للإنذار).');
      } else {
        final secondsInRedZone = DateTime.now()
            .difference(_redZoneEntryTime!)
            .inSeconds;
        debugPrint(
          '⏱️ [الحاج] استمرار في الأحمر منذ: $secondsInRedZone ثانية.',
        );
        if (secondsInRedZone >= _alarmDelaySeconds) {
          debugPrint('🚨 [الحاج] إطلاق الإنذار النهائي!');
          _triggerEmergency();
        }
      }
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // مؤقت انقطاع المشرف
  // ═══════════════════════════════════════════════════════════════════════════

  void _resetLeaderTimeoutTimer() {
    _leaderTimeoutTimer?.cancel();
    _leaderTimeoutTimer = Timer(const Duration(minutes: 30), () {
      stopTracking();
      state = PilgrimTrackingState(
        errorMessage:
            'تم إيقاف التتبع لأن المشرف فقد الاتصال لأكثر من 30 دقيقة.',
      );
    });
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // التنبيهات الصوتية والاهتزازية
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _triggerWarningVibration() async {
    if (await Vibration.hasVibrator() == true) {
      Vibration.vibrate(pattern: [0, 200, 100, 200, 100, 200, 100, 200]);
    }
    // إشعار تحذير صامت (مثل المشرف)
    const AndroidNotificationDetails warningDetails =
        AndroidNotificationDetails(
          'warning_channel_pilgrim',
          'تحذير الابتعاد',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          playSound: false,
          enableVibration: false,
        );
    await _notificationsPlugin.show(
      1,
      '🟡 تحذير: أنت تبتعد!',
      'بدأت تبتعد عن مجموعتك. إسرع الخطى للمشرف.',
      const NotificationDetails(android: warningDetails),
    );
  }

  Future<void> _triggerEmergency() async {
    if (_isAlarmActive) return;
    _isAlarmActive = true;

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'emergency_channel_pilgrim',
          'تنبيه الابتعاد',
          importance: Importance.max,
          priority: Priority.high,
        );
    await _notificationsPlugin.show(
      1001, // نفس نمط المشرف: ID مختلف للطوارئ
      '🚨 إنذار خطر!',
      'لقد ابتعدت عن المشرف خارج النطاق المسموح!',
      const NotificationDetails(android: androidDetails),
    );

    if (await Vibration.hasVibrator() == true) {
      Vibration.vibrate(pattern: [500, 1000, 500, 1000]);
    }
    // لا نشغّل الصوت إذا كان الحاج قد كتمه يدوياً
    if (!_isMutedManually) {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(AssetSource('sounds/alarm.mp3'));
    }
  }

  void stopAlarmManual({bool isUserAction = false}) {
    _audioPlayer.stop();
    Vibration.cancel();
    if (isUserAction) {
      _isMutedManually = true; // 🔇 الحاج هو من أوقف — لا يعود تلقائياً
    }
    _isAlarmActive = false;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // إدارة دورة حياة الجلسة
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> rejectSession({required int sessionId}) async {
    state = PilgrimTrackingState(isLoading: true);
    try {
      final trackingApiRepo = ref.read(leaderTrackingApiRepositoryProvider);
      await trackingApiRepo.respondToSession(sessionId, 3);
      final sharedPrefs = ref.read(sharedPreferencesServiceProvider);
      await sharedPrefs.removeInt(SharedPreferencesKeys.sessionId);
      state = PilgrimTrackingState();
    } catch (e) {
      state = PilgrimTrackingState(errorMessage: e.toString());
    }
  }

  void stopTracking() {
    _positionStreamSub?.cancel();
    _leaderStreamSub?.cancel();
    _serviceStatusSub?.cancel();
    _myFirebaseDataSub?.cancel();
    _leaderTimeoutTimer?.cancel();

    _positionStreamSub = null;
    _leaderStreamSub = null;

    stopAlarmManual();

    // 🌟 إيقاف خدمة الفلترة
    _locationFilter.stop();

    // 🌟 إيقاف بث البلوتوث
    ref.read(bleRadarServiceProvider).stopBroadcasting();

    _lastValidPosition = null;
    _lastUpdateTime = null;
    _currentSessionId = null;
    _currentPilgrimId = null;
    _currentPilgrimName = null;

    final sharedPrefs = ref.read(sharedPreferencesServiceProvider);
    sharedPrefs.removeInt(SharedPreferencesKeys.sessionId);

    // 🌟 تصفير المزود التفاعلي ليختفي زر الهيدر فوراً
    ref.read(activeSessionIdProvider.notifier).updateSessionId(0);

    state = PilgrimTrackingState();
  }

  Future<void> leaveAndStopTracking({
    required int sessionId,
    required String pilgrimId,
  }) async {
    try {
      final trackingApiRepo = ref.read(leaderTrackingApiRepositoryProvider);
      await trackingApiRepo.respondToSession(sessionId, 4);

      final trackingRepo = ref.read(trackingRepositoryProvider);
      await trackingRepo.removePilgrimFromSession(
        sessionId: sessionId.toString(),
        pilgrimId: pilgrimId,
      );

      stopTracking();
    } catch (e) {
      state = PilgrimTrackingState(errorMessage: e.toString());
    }
  }
}
