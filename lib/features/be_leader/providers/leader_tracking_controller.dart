import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/features/be_leader/data/models/tracking_notification_model.dart';
import 'package:yusr/features/be_leader/presentation/services/smart_location_filter_service.dart';
import 'package:yusr/features/be_leader/providers/ble_radar_service_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vibration/vibration.dart';
import 'package:latlong2/latlong.dart';
import 'package:yusr/core/common/providers/location_service.dart';
import 'package:yusr/core/common/providers/shared_preferences_service_provider.dart';
import 'package:yusr/core/constants/shared_preferences_keys.dart';
import 'package:yusr/features/be_leader/data/repositories/tracking_repository.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/be_leader/providers/be_leader_repository_provider.dart';
import 'package:yusr/features/be_leader/providers/state/pilgrim_marker_data.dart';
import 'package:yusr/features/be_leader/providers/state/tracking_state.dart';
import 'package:yusr/features/be_leader/providers/tracking_notifications_store.dart';
import 'package:yusr/features/be_leader/providers/tracking_repository_provider.dart';
import 'package:permission_handler/permission_handler.dart' hide ServiceStatus;
part 'leader_tracking_controller.g.dart';

@Riverpod(keepAlive: true)
class LeaderTrackingController extends _$LeaderTrackingController {
  StreamSubscription<Position>? _leaderLocationSub;
  StreamSubscription<DatabaseEvent>? _pilgrimsSub;
  StreamSubscription<ServiceStatus>? _serviceStatusSub;
  bool _isGpsEnabled = true;
  StreamSubscription<DatabaseEvent>? _networkSub;
  Timer? _evaluationTimer;
  Map<dynamic, dynamic>? _latestPilgrimsData;

  int? _currentSessionId;
  Position? _currentLeaderPosition;
  Position? _lastValidLeaderPosition;
  DateTime? _lastLeaderUpdateTime;
  final AudioPlayer _audioPlayer = AudioPlayer()
    ..audioCache = AudioCache(prefix: '');
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final double _yellowZone = 20;
  final double _redZone = 30;

  final Set<String> _alertedPilgrims = {};
  final Map<String, DateTime> _redZoneEntryTimes = {};
  final int _alarmDelaySeconds = 10;
  final Set<String> _yellowWarnedPilgrims = {};

  /// ذاكرة زمنية: آخر مرة رُصد فيها كل حاج عبر BLE
  /// المفتاح: pilgrimId (نفس key من Firebase)
  final Map<String, DateTime> _bleLastSeenTimes = {};
  
  // 🔵 تنعيم (Debounce) لتقلبات مسافة البلوتوث لمنع تذبذب الحالة
  final Map<String, DateTime> _lastSafeBleTimes = {};

  bool get isCurrentlyTracking => _currentSessionId != null;
  bool _isMutedManually = false; // 🔇 هل قام المشرف بكتم الصوت يدوياً؟

  // 🌟 خدمة فلترة الموقع المشتركة (عدّاد خطوات + حماية GPS)
  final SmartLocationFilterService _locationFilter =
      SmartLocationFilterService();
  @override
  TrackingState build() {
    return TrackingState();
  }

  // يجب إضافة مصفوفة لحفظ الحالة السابقة لتجنب الكتابة المتكررة في فايربيس
  final Map<String, bool> _lastSentBleStatus = {};
  final Map<String, double> _lastSentBleDistance = {};

  Future<void> startTracking(int sessionId) async {
    if (_currentSessionId == sessionId && _leaderLocationSub != null) {
      return;
    }

    await _leaderLocationSub?.cancel();
    await _pilgrimsSub?.cancel();
    await _serviceStatusSub?.cancel();
    await _networkSub?.cancel();
    _evaluationTimer?.cancel();
    ref.read(bleRadarServiceProvider).stop();
    _locationFilter.stop(); // إيقاف مستشعر الحركة القديم إن وجد

    _currentSessionId = sessionId;
    state = TrackingState(isLoading: true);

    try {
      final repo = ref.read(trackingRepositoryProvider);
      final locationService = ref.read(locationServiceProvider);

      await repo.initLeaderSession(_currentSessionId.toString());

      // 1️⃣ فحص خدمة GPS (انتقل إلى LocationService)
      final serviceEnabled = await locationService.isServiceEnabled();
      if (!serviceEnabled) {
        debugPrint("⚠️ [GPS] الخدمة مطفأة عند بدء التتبع.");
        state = TrackingState(
          isLoading: false,
          gpsWarning:
              navigatorKey.currentContext?.locale.gpsServiceDisabledWarning ??
              'يرجى تفعيل خدمة الـ GPS (الموقع) في هاتفك.',
        );
      }

      // 2️⃣ فحص وطلب الصلاحيات (انتقل إلى LocationService)
      final permissionsGranted = await locationService
          .ensurePermissionsGranted();
      if (!permissionsGranted) {
        state = TrackingState(
          isLoading: false,
          gpsWarning:
              navigatorKey.currentContext?.locale.gpsPermissionDeniedWarning ??
              'لا يمكن بدء التتبع بدون صلاحيات الموقع. يرجى تفعيلها من الإعدادات.',
        );
        return;
      }

      // 🌟 طلب صلاحيات البلوتوث للأجهزة الحديثة (أندرويد 12+) قبل بدء الرادار
      await [
        Permission.bluetooth,
        Permission.bluetoothAdvertise,
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
      ].request();

      // 🌟 تشغيل رادار البلوتوث من خلال الخدمة الجديدة
      ref
          .read(bleRadarServiceProvider)
          .initMonitoring(
            onWarning: (warningMsg) {
              state = TrackingState(
                leaderLocation: state.leaderLocation,
                greenPilgrims: state.greenPilgrims,
                yellowPilgrims: state.yellowPilgrims,
                redPilgrims: state.redPilgrims,
                isLoading: state.isLoading,
                gpsWarning: state.gpsWarning,
                bleWarning: warningMsg,
              );
            },
          );
      _locationFilter.startSmartStepCounting(
        tag: ' [المشرف]',
      ); // 🌟 تشغيل فلتر المشي المشترك
      // 5️⃣ مراقبة تشغيل/إيقاف GPS (عبر الدالة المنفصلة لتخفيف الكود)
      _listenToGpsStatusChanges();

      // 6️⃣ جلب الموقع الأولي (يستخدم tryGetCurrentPosition + _applyValidPosition)
      if (serviceEnabled) {
        final initialPos = await locationService.tryGetCurrentPosition();
        if (initialPos != null) _applyValidPosition(initialPos, repo);
      }
      // 7️⃣ تشغيل Stream الموقع المستمر (دالة منفصلة)
      _startLocationUpdates();
      // 8️⃣ استماع تحديثات مواقع الحجاج (دالة منفصلة)
      _listenToPilgrimsStream();
      // 9️⃣ مراقبة الاتصال بالإنترنت
      _listenToNetworkStatus();
      // 🔟 تشغيل التقييم الدوري للمسافات
      _startPeriodicEvaluation();
    } catch (e) {
      state = TrackingState(
        isLoading: false,
        gpsWarning:
            navigatorKey.currentContext?.locale.gpsSystemError ??
            'حدث خطأ في النظام. يرجى التأكد من الصلاحيات.',
      );
    }
  }

  Future<void> _updatePilgrimBleStatusInFirebase(
    String pilgrimId,
    bool isSafe, {
    double? bleDistance,
  }) async {
    final lastStatus = _lastSentBleStatus[pilgrimId];
    final lastDist = _lastSentBleDistance[pilgrimId];

    bool statusChanged = lastStatus != isSafe;
    // تحديث إذا تغيرت حالة الأمان، أو إذا تغيرت مسافة البلوتوث بأكثر من متر واحد أثناء الأمان
    bool distanceChangedSignificantly = isSafe &&
        bleDistance != null &&
        (lastDist == null || (lastDist - bleDistance).abs() > 1.0);

    if (statusChanged || distanceChangedSignificantly) {
      _lastSentBleStatus[pilgrimId] = isSafe;
      if (bleDistance != null) {
        _lastSentBleDistance[pilgrimId] = bleDistance;
      } else {
        _lastSentBleDistance.remove(pilgrimId);
      }

      try {
        final repo = ref.read(trackingRepositoryProvider);
        await repo.updatePilgrimSafeFlag(
          _currentSessionId.toString(),
          pilgrimId,
          isSafe,
          bleDistance: bleDistance,
        );
      } catch (e) {
        debugPrint('خطأ في تحديث صك الأمان: $e');
      }
    }
  }

  /// يُشغِّل مستمع تحديثات مواقع الحجاج من Firebase.
  /// مُستخرَجة لتوحيد النمط مع [_startLocationUpdates] و[_listenToGpsStatusChanges].
  void _listenToPilgrimsStream() {
    final repo = ref.read(trackingRepositoryProvider);
    _pilgrimsSub?.cancel();
    _pilgrimsSub = repo.pilgrimsStream(_currentSessionId.toString()).listen((
      DatabaseEvent event,
    ) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        _latestPilgrimsData = event.snapshot.value as Map<dynamic, dynamic>;
      } else {
        _latestPilgrimsData = null;
      }
      _processPilgrimsAndAlert();
    });
  }

  void _startPeriodicEvaluation() {
    _evaluationTimer?.cancel();
    _evaluationTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _processPilgrimsAndAlert();
    });
  }

  void _applyValidPosition(Position pos, TrackingRepository repo) {
    _lastValidLeaderPosition = pos;
    _lastLeaderUpdateTime = DateTime.now();
    _currentLeaderPosition = pos;
    final latLng = LatLng(pos.latitude, pos.longitude);
    repo.updateLeaderLocation(
      sessionId: _currentSessionId.toString(),
      location: latLng,
      heading: pos.heading,
    );
    state = TrackingState(
      leaderLocation: latLng,
      greenPilgrims: state.greenPilgrims,
      yellowPilgrims: state.yellowPilgrims,
      redPilgrims: state.redPilgrims,
      isLoading: false,
      gpsWarning: state.gpsWarning,
      bleWarning: state.bleWarning,
    );
  }

  void _startLocationUpdates() {
    final repo = ref.read(trackingRepositoryProvider);
    final locationService = ref.read(locationServiceProvider);

    _leaderLocationSub?.cancel();
    _leaderLocationSub = locationService.foregroundPositionStream.listen((
      Position position,
    ) {
      debugPrint(
        "📍 [المشرف] موقع جديد | دقة: ${position.accuracy.toStringAsFixed(1)} م | ${position.latitude}, ${position.longitude}",
      );

      if (!_isGpsEnabled) return; // 🌟 تجاهل أي إحداثيات متأخرة إذا كان الـ GPS مغلقاً

      // 🔴 فلتر 1: رفض المواقع ضعيفة الدقة
      // العتبة: kLeaderAccuracyThreshold (35م) — المشرف في مناطق مكشوفة -> صرامة معتدلة
      // راجع: SmartLocationFilterService.kLeaderAccuracyThreshold
      if (position.accuracy >
          SmartLocationFilterService.kLeaderAccuracyThreshold) {
        debugPrint(
          '⚠️ [المشرف] ❌ دقة ضعيفة (${position.accuracy.toStringAsFixed(1)} م > ${SmartLocationFilterService.kLeaderAccuracyThreshold} م) — رفض وإرسال نبضة حياة...',
        );

        // نبضة الحياة: نرسل آخر موقع صالح لفايربيس لإبقاء الجلسة حية دون تحريك الخريطة
        if (_lastValidLeaderPosition != null) {
          final lastLatLng = LatLng(
            _lastValidLeaderPosition!.latitude,
            _lastValidLeaderPosition!.longitude,
          );
          repo.updateLeaderLocation(
            sessionId: _currentSessionId.toString(),
            location: lastLatLng,
            heading: _lastValidLeaderPosition!.heading,
          );
        }
        return;
      }

      // 🔴 فلتر 2 + 3: رفض القفزات الوهمية (سرعة و خطوات)
      if (_lastValidLeaderPosition != null && _lastLeaderUpdateTime != null) {
        final distanceJump = Geolocator.distanceBetween(
          _lastValidLeaderPosition!.latitude,
          _lastValidLeaderPosition!.longitude,
          position.latitude,
          position.longitude,
        );
        final timeDiffSeconds = DateTime.now()
            .difference(_lastLeaderUpdateTime!)
            .inSeconds;

        // فلتر 2: السرعة
        final bool? isSpeedValid = _locationFilter.isSpeedJumpValid(
          distanceMeters: distanceJump,
          timeDiffSeconds: timeDiffSeconds,
          tag: ' [المشرف]',
        );

        if (isSpeedValid == false) {
          // 💡 حل مشكلة الفخ الأولي (Initial GPS Trap):
          // إذا كانت الدقة الجديدة ممتازة (أقل من أو تساوي 15 متراً) والدقة السابقة كانت أضعف،
          // فهذا يعني أن الـ GPS التقط إشارة قوية وحقيقية أخيراً وصحح موقعه.
          if (position.accuracy <= 15.0 && _lastValidLeaderPosition!.accuracy > position.accuracy) {
            debugPrint(
              '🚨 [تصحيح ذاتي المشرف] قفزة كبيرة ولكن دقة الـ GPS ممتازة (${position.accuracy.toStringAsFixed(1)}م). كسر الفخ وقبول الموقع!',
            );
          } else {
            return;
          }
        } else {
          // فلتر 3: الخطوات وتصحيح الـ GPS (يُفحص فقط إذا كانت السرعة منطقية)
          if (!_locationFilter.isMovementReal(
            distanceMeters: distanceJump,
            currentAccuracy: position.accuracy,
            previousAccuracy: _lastValidLeaderPosition!.accuracy,
            tag: ' [المشرف]',
          )) {
            debugPrint(
              '🛑 [حماية] قفزة GPS وهمية — لا خطوات كافية والمسافة خارج هامش الخطأ!',
            );
            return;
          }
        }
      }
      debugPrint("الموقع اجتاز جميع الفلاتر الان سيتم تحديث الموقع");
      _applyValidPosition(position, repo);
      _processPilgrimsAndAlert();
    });
  }

  void _listenToGpsStatusChanges() {
    final locationService = ref.read(locationServiceProvider);
    final repo = ref.read(trackingRepositoryProvider);

    _serviceStatusSub?.cancel();
    _serviceStatusSub = locationService.serviceStatusStream.listen((
      ServiceStatus status,
    ) async {
      if (status == ServiceStatus.disabled) {
        _isGpsEnabled = false;
        debugPrint("⚠️ [GPS] تم إغلاق مفتاح GPS!");
        state = TrackingState(
          leaderLocation: state.leaderLocation,
          greenPilgrims: state.greenPilgrims,
          yellowPilgrims: state.yellowPilgrims,
          redPilgrims: state.redPilgrims,
          isLoading: false,
          gpsWarning:
              navigatorKey.currentContext?.locale.gpsDisabledWarning ??
              'تم إغلاق خدمة الموقع (GPS) في الهاتف. يرجى تفعيلها.',
          bleWarning: state.bleWarning,
          isNetworkConnected: state.isNetworkConnected,
        );
      } else {
        _isGpsEnabled = true;
        debugPrint("✅ [GPS] تم تفعيل GPS — إعادة تشغيل المستمع...");
        state = TrackingState(
          leaderLocation: state.leaderLocation,
          greenPilgrims: state.greenPilgrims,
          yellowPilgrims: state.yellowPilgrims,
          redPilgrims: state.redPilgrims,
          isLoading: false,
          gpsWarning:
              navigatorKey.currentContext?.locale.gpsReenabledLeaderWarning ??
              'الـ GPS مفعل، جاري تحديث الموقع (قد يكون في مكان مغلق)...',
          bleWarning: state.bleWarning,
          isNetworkConnected: state.isNetworkConnected,
        );
        _startLocationUpdates();
        
        // 🌟 إضافة مهمة: إعادة تشغيل الرادار لأن الرادار يتوقف تلقائياً إذا فُتحت الجلسة و الـ GPS مغلق
        ref.read(bleRadarServiceProvider).initMonitoring(
          onWarning: (warningMsg) {
            state = TrackingState(
              leaderLocation: state.leaderLocation,
              greenPilgrims: state.greenPilgrims,
              yellowPilgrims: state.yellowPilgrims,
              redPilgrims: state.redPilgrims,
              isLoading: state.isLoading,
              gpsWarning: state.gpsWarning,
              bleWarning: warningMsg,
              isNetworkConnected: state.isNetworkConnected,
            );
          },
        );

        // جلب موقع فوري لإنعاش الخريطة
        final quickPos = await locationService.tryGetCurrentPosition();
        if (quickPos != null) _applyValidPosition(quickPos, repo);
      }
    });
  }

  void _listenToNetworkStatus() {
    _networkSub?.cancel();
    _networkSub = FirebaseDatabase.instance
        .ref('.info/connected')
        .onValue
        .listen((event) {
          final isConnected = event.snapshot.value as bool? ?? false;
          state = TrackingState(
            leaderLocation: state.leaderLocation,
            greenPilgrims: state.greenPilgrims,
            yellowPilgrims: state.yellowPilgrims,
            redPilgrims: state.redPilgrims,
            isLoading: state.isLoading,
            gpsWarning: state.gpsWarning,
            bleWarning: state.bleWarning,
            isNetworkConnected: isConnected,
          );
        });
  }
  // ═══════════════════════════════════════════════════════════════════════════
  // BLE-First: منطق تقييم سلامة الحجاج
  // ═══════════════════════════════════════════════════════════════════════════

  /// مدة السماح قبل إعلان غياب البلوتوث والاعتماد الكلي على GPS
  static const int _bleGracePeriodSeconds = 30;

  /// يُقيِّم حالة الحاج بناءً على BLE أولاً، ثم GPS عند الضرورة.
  ({String status, bool isStrongBle}) _evaluatePilgrimSafety({
    required bool bleSignalPresent,
    required double bleDistance,
    required double gpsDistance,
    required dynamic key,
  }) {
    bool isStrongBle = false;

    // ── القاعدة 1: BLE يرى الحاج في النطاق الآمن → آمن قطعياً ────────────
    if (bleSignalPresent) {
      if (bleDistance <= _yellowZone) {
        _lastSafeBleTimes[key.toString()] = DateTime.now();
        isStrongBle = true;
      } else {
        // المسافة المُقدرة أكبر من 20 متراً، قد يكون تذبذباً (Jitter).
        // نعطيه مهلة 10 ثوانٍ (Grace Period) قبل أن نحكم عليه بأنه في خطر/تحذير.
        final lastSafe = _lastSafeBleTimes[key.toString()];
        if (lastSafe != null && DateTime.now().difference(lastSafe).inSeconds <= 10) {
          isStrongBle = true; // استمرار حالة الأمان مؤقتاً لامتصاص التذبذب
        }
      }
    }

    if (isStrongBle) {
      return (status: 'safe', isStrongBle: true);
    }

    // ── القاعدة 2: BLE ضعيف أو غائب → الاعتماد الكلي على GPS ──────────────
    if (gpsDistance > _redZone) {
      return (status: 'danger', isStrongBle: false);
    } else if (gpsDistance > _yellowZone) {
      return (status: 'warning', isStrongBle: false);
    } else {
      return (status: 'safe', isStrongBle: false);
    }
  }

  /// تُمسح جميع إنذارات وتحذيرات حاج محدد دفعة واحدة.
  /// تُستدعى فوراً عندما يعود الحاج للنطاق الآمن (تأكيد BLE).
  void _clearPilgrimAlerts(dynamic key) {
    _alertedPilgrims.remove(key);
    _redZoneEntryTimes.remove(key);
    _yellowWarnedPilgrims.remove(key);
    _notificationsPlugin.cancel(key.hashCode);
    _notificationsPlugin.cancel(key.hashCode + 1000);
    final store = ref.read(trackingNotificationsStoreProvider.notifier);
    store.removeNotification('leader_warn_$key');
    store.removeNotification('leader_emrg_$key');
  }

  void _processPilgrimsAndAlert() {

    if (_currentLeaderPosition == null) return;

    // ✅ إذا حُذف جميع الحجاج (snapshot فارغ) → امسح الماركرات من الخريطة فوراً
    if (_latestPilgrimsData == null) {
      stopAlarmManual();
      _alertedPilgrims.clear();
      _redZoneEntryTimes.clear();
      _yellowWarnedPilgrims.clear();
      state = TrackingState(
        leaderLocation: state.leaderLocation,
        greenPilgrims: [],
        yellowPilgrims: [],
        redPilgrims: [],
        isLoading: false,
        isNetworkConnected: state.isNetworkConnected,
      );
      return;
    }

    final pilgrimsData = _latestPilgrimsData!;

    List<PilgrimMarkerData> green = [];
    List<PilgrimMarkerData> yellow = [];
    List<PilgrimMarkerData> red = [];
    bool hasRedPilgrims = false;

    pilgrimsData.forEach((key, value) {
      final lat = value['latitude'];
      final lng = value['longitude'];
      final name =
          value['name'] ??
          navigatorKey.currentContext?.locale.unknownPilgrim ??
          'أحد الحجاج';
      // lastPositionUpdate: آخر تحرك فعلي للحاج (يتجاهل نبضات الحياة)
      // lastUpdate: heartbeat — هاتف الحاج متصل (يتحدث مع كل إرسال)
      final rawPositionUpdate = value['lastPositionUpdate'];
      final rawHeartbeat = value['lastUpdate'];
      final lastSeen = rawPositionUpdate != null
          ? DateTime.fromMillisecondsSinceEpoch((rawPositionUpdate as int))
          : rawHeartbeat != null
          ? DateTime.fromMillisecondsSinceEpoch((rawHeartbeat as int))
          : DateTime.now();
      final lastHeartbeat = rawHeartbeat != null
          ? DateTime.fromMillisecondsSinceEpoch((rawHeartbeat as int))
          : null;
      if (lat == null || lng == null) return;
      final gpsDistance = Geolocator.distanceBetween(
        _currentLeaderPosition!.latitude,
        _currentLeaderPosition!.longitude,
        lat,
        lng,
      );

      // ── استخراج بيانات BLE لهذا الحاج ──────────────────────────────────────
      final int pilgrimMinorId =
          (int.tryParse(key.toString()) ?? key.toString().hashCode) % 65535;
      final bleService = ref.read(bleRadarServiceProvider);

      bool bleSignalPresent = false;
      double activeBleDistance = double.infinity;

      final bool hasBleEntry = bleService.bleDistances.containsKey(pilgrimMinorId);
      final bool hasBleTimestamp = bleService.lastBleUpdates.containsKey(pilgrimMinorId);

      if (hasBleEntry && hasBleTimestamp) {
        final timeSinceLastBle = DateTime.now()
            .difference(bleService.lastBleUpdates[pilgrimMinorId]!)
            .inSeconds;

        if (timeSinceLastBle <= 10) {
          bleSignalPresent = true;
          activeBleDistance = bleService.bleDistances[pilgrimMinorId]!;
          debugPrint(
            '🟣 [BLE-TRACE] [$name | MinorId:$pilgrimMinorId] '
            'GPS=${gpsDistance.toStringAsFixed(1)}م | BLE=${activeBleDistance.toStringAsFixed(1)}م '
            '| عمر الإشارة=$timeSinceLastBle ث',
          );
        } else {
          debugPrint(
            '🟠 [BLE-TRACE] [$name | MinorId:$pilgrimMinorId] إشارة BLE قديمة ($timeSinceLastBle ث) — تجاهل.',
          );
        }
      } else {
        debugPrint(
          '⚫ [BLE-TRACE] [$name | MinorId:$pilgrimMinorId] لا توجد إشارة BLE مسجلة.',
        );
      }

      // ── خطوة 0: تحديث ذاكرة غياب BLE ─────────────────────────────────────
      if (bleSignalPresent) {
        _bleLastSeenTimes[key.toString()] = DateTime.now();
      }

      // ── خطوة 1: الحكم على حالة الحاج (BLE-First) ─────────────────────────
      final evaluation = _evaluatePilgrimSafety(
        bleSignalPresent: bleSignalPresent,
        bleDistance: activeBleDistance,
        gpsDistance: gpsDistance,
        key: key,
      );
      
      final safetyStatus = evaluation.status;
      final isStrongBle = evaluation.isStrongBle;

      debugPrint(
        '📊 [BLE-FIRST] [$name] '
        'BLE=${isStrongBle ? "${activeBleDistance.toStringAsFixed(1)}م" : "ضعيف/غائب"} '
        '| GPS=${gpsDistance.toStringAsFixed(1)}م '
        '| الحكم=$safetyStatus',
      );

      // ── خطوة 2: حساب المسافة المعروضة في الواجهة ─────────────────────────
      // BLE قوي ومؤكد → نعرض مسافة BLE
      // إشارة ضعيفة أو غائبة → نعرض مسافة GPS
      final double displayDistance = isStrongBle ? activeBleDistance : gpsDistance;

      LatLng displayLocation = LatLng(lat, lng);

      // ── Sensor Fusion: تحديث موقع الخريطة بناءً على البلوتوث ─────────────
      // بناءً على اقتراحك: نثبت الماركر فقط عندما يكون البلوتوث قوياً ومؤكداً
      if (isStrongBle && _currentLeaderPosition != null) {
        // نستخدم زاوية ثابتة لكل حاج بناءً على الـ ID لتوزيع الحجاج حول المشرف بشكل دائري ثابت
        final double bearing = (pilgrimMinorId.toDouble() * 45.0) % 360.0;
        
        // تثبيت المسافة البصرية لكي لا يتدبدب المؤشر أبداً: 5 أمتار للآمن
        final double visualDistance = 5.0;

        final double bearingRadian = bearing * math.pi / 180.0;
        // تقريب: 1 درجة خط عرض = 111320 متر
        final double latOffset = (visualDistance * math.cos(bearingRadian)) / 111320.0;
        final double lngOffset = (visualDistance * math.sin(bearingRadian)) / (111320.0 * math.cos(_currentLeaderPosition!.latitude * math.pi / 180.0));

        displayLocation = LatLng(
          _currentLeaderPosition!.latitude + latOffset,
          _currentLeaderPosition!.longitude + lngOffset,
        );
        
        debugPrint('📍 [Sensor Fusion] تثبيت موقع الحاج [$name] بالبلوتوث (مسافة بصرية: ${visualDistance}م)');
      }

      // ── خطوة 3: إرسال حالة BLE لـ Firebase (للحاج ليُطفئ إنذاره) ─────────
      final bool isSafeByBle = activeBleDistance != null;
      _updatePilgrimBleStatusInFirebase(
        key.toString(),
        isSafeByBle,
        bleDistance: activeBleDistance,
      );

      // ── خطوة 4: بناء PilgrimMarkerData ───────────────────────────────────
      final pilgrim = PilgrimMarkerData(
        id: key,
        name: name,
        location: displayLocation,
        distance: displayDistance,
        lastSeen: lastSeen,
        lastHeartbeat: lastHeartbeat,
        isSafeByBle: isSafeByBle,
      );

      // ── خطوة 5: تصنيف الحاج وإدارة الإنذارات ─────────────────────────────
      switch (safetyStatus) {
        case 'safe':
          // BLE يؤكد القُرب → أخضر فوري + مسح كل الإنذارات + إطفاء الصوت
          debugPrint('✅ [BLE-FIRST] [$name] → أخضر (BLE يؤكد القُرب).');
          green.add(pilgrim);
          _clearPilgrimAlerts(key);
          stopAlarmManual(); // إطفاء فوري — BLE عاد

        case 'warning':
          // تحذير: BLE غاب مؤقتاً أو GPS قريب — لا إنذار صوتي
          debugPrint('🟡 [BLE-FIRST] [$name] → أصفر (تحذير).');
          yellow.add(pilgrim);
          _alertedPilgrims.remove(key);
          _redZoneEntryTimes.remove(key);
          _notificationsPlugin.cancel(key.hashCode + 1000);
          ref
              .read(trackingNotificationsStoreProvider.notifier)
              .removeNotification('leader_emrg_$key');
          _triggerWarningVibration(key, name);

        case 'danger':
          // BLE غاب > 60 ثانية + GPS بعيد → خطر حقيقي
          debugPrint('🔴 [BLE-FIRST] [$name] → أحمر (BLE غاب + GPS بعيد).');
          red.add(pilgrim);
          hasRedPilgrims = true;

          if (!_alertedPilgrims.contains(key)) {
            if (!_redZoneEntryTimes.containsKey(key)) {
              _redZoneEntryTimes[key] = DateTime.now();
            } else {
              final secondsInRedZone = DateTime.now()
                  .difference(_redZoneEntryTimes[key]!)
                  .inSeconds;
              if (secondsInRedZone >= _alarmDelaySeconds) {
                _triggerEmergency(key, name);
                _redZoneEntryTimes.remove(key);
              }
            }
          }
      }
    });


    if (!hasRedPilgrims) {
      stopAlarmManual();
      _isMutedManually =
          false; // 🌟 إعادة تفعيل الصوت آلياً للجولة القادمة لأن الجميع بأمان الآن
    }
    state = TrackingState(
      leaderLocation: state.leaderLocation,
      greenPilgrims: green,
      yellowPilgrims: yellow,
      redPilgrims: red,
      isLoading: false,
    );
  }

  Future<void> _triggerWarningVibration(
    String pilgrimId,
    String pilgrimName,
  ) async {
    if (_yellowWarnedPilgrims.contains(pilgrimId)) return;
    _yellowWarnedPilgrims.add(pilgrimId);
    if ((await Vibration.hasVibrator()) == true) {
      Vibration.vibrate(pattern: [0, 200, 100, 200, 100, 200, 100, 200]);
    }
    final AndroidNotificationDetails warningDetails =
        AndroidNotificationDetails(
          'warning_channel',
          navigatorKey.currentContext?.locale.leaderWarningChannelName ??
              'تحذيرات الحجاج المتأخرين',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          playSound: false,
          enableVibration: false,
        );
    await _notificationsPlugin.show(
      pilgrimId.hashCode,
      navigatorKey.currentContext?.locale.leaderPilgrimWarningTitle ??
          '🟡 تنبيه تأخر حاج',
      navigatorKey.currentContext?.locale.leaderPilgrimWarningBleBody(
            pilgrimName,
          ) ??
          'الحاج "$pilgrimName" لم يُرصد بالبلوتوث منذ قليل — ترقَّب',
      NotificationDetails(android: warningDetails),
      payload: 'warning_notification',
    );
    // حفظ في الواجهة ← متزامن مع show()
    ref
        .read(trackingNotificationsStoreProvider.notifier)
        .addNotification(
          TrackingNotificationModel(
            id: 'leader_warn_$pilgrimId',
            title:
                navigatorKey.currentContext?.locale.leaderPilgrimWarningTitle ??
                '🟡 تنبيه تأخر حاج',
            body:
                navigatorKey.currentContext?.locale.leaderPilgrimWarningBleBody(
                  pilgrimName,
                ) ??
                'الحاج "$pilgrimName" لم يُرصد بالبلوتوث منذ قليل — ترقَّب',
            timestamp: DateTime.now().toIso8601String(),
            type: TrackingNotificationType.leaderWarning,
            sessionId: _currentSessionId,
            pilgrimName: pilgrimName,
          ),
        );
  }

  Future<void> _triggerEmergency(String pilgrimId, String pilgrimName) async {
    if (_alertedPilgrims.contains(pilgrimId)) return;
    _alertedPilgrims.add(pilgrimId);
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'emergency_channel',
          navigatorKey.currentContext?.locale.leaderEmergencyChannelName ??
              'طوارئ الحجاج',
          importance: Importance.max,
          priority: Priority.high,
        );
    await _notificationsPlugin.show(
      pilgrimId.hashCode + 1000,
      navigatorKey.currentContext?.locale.leaderPilgrimEmergencyTitle ??
          '🚨 خطر: ضياع حاج!',
      navigatorKey.currentContext?.locale.leaderPilgrimEmergencyBleBody(
            pilgrimName,
          ) ??
          '⚠️ الحاج "$pilgrimName" خارج النطاق ولم يُرصد بالبلوتوث منذ دقيقة',
      NotificationDetails(android: androidDetails),
      payload: 'emergency_notification',
    );
    // حفظ في الواجهة ← متزامن مع show()
    ref
        .read(trackingNotificationsStoreProvider.notifier)
        .addNotification(
          TrackingNotificationModel(
            id: 'leader_emrg_$pilgrimId',
            title:
                navigatorKey
                    .currentContext
                    ?.locale
                    .leaderPilgrimEmergencyTitle ??
                '🚨 خطر: ضياع حاج!',
            body:
                navigatorKey.currentContext?.locale.leaderPilgrimEmergencyBleBody(
                  pilgrimName,
                ) ??
                '⚠️ الحاج "$pilgrimName" خارج النطاق ولم يُرصد بالبلوتوث منذ دقيقة',
            timestamp: DateTime.now().toIso8601String(),
            type: TrackingNotificationType.leaderEmergency,
            sessionId: _currentSessionId,
            pilgrimName: pilgrimName,
          ),
        );
    if ((await Vibration.hasVibrator()) == true) {
      Vibration.vibrate(pattern: [500, 1000, 500, 1000]);
    }
    if (!_isMutedManually) {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(AssetSource('asset/sounds/alarm.mp3'));
    }
  }

  void stopAlarmManual({bool isUserAction = false}) {
    _audioPlayer.stop();
    Vibration.cancel();
    if (isUserAction) {
      _isMutedManually = true; // 🔇 تذكر أن المشرف هو من أوقف الصوت
    }
  }

  Future<void> stopSessionOfficially() async {
    if (_currentSessionId == null) return;
    try {
      state = TrackingState(isLoading: true);

      await _leaderLocationSub?.cancel();
      await _pilgrimsSub?.cancel();
      await _serviceStatusSub?.cancel();
      await _networkSub?.cancel();
      _evaluationTimer?.cancel();
      ref.read(bleRadarServiceProvider).stop(); // 🌟 إيقاف الرادار
      _locationFilter.stop(); // 🌟 إيقاف مستشعر الحركة وتصفير العدادات
      stopAlarmManual();

      for (var key in _alertedPilgrims) {
        _notificationsPlugin.cancel(key.hashCode + 1000);
      }
      for (var key in _yellowWarnedPilgrims) {
        _notificationsPlugin.cancel(key.hashCode);
      }
      _alertedPilgrims.clear();
      _yellowWarnedPilgrims.clear();
      _redZoneEntryTimes.clear();
      _bleLastSeenTimes.clear(); // 🔵 تنظيف ذاكرة غياب BLE
      _lastSafeBleTimes.clear(); // 🔵 تنظيف ذاكرة التذبذب


      if (_currentSessionId != null) {
        ref
            .read(trackingNotificationsStoreProvider.notifier)
            .clearBySessionId(_currentSessionId!);
      }

      final repo = ref.read(trackingRepositoryProvider);
      await repo.deleteSession(_currentSessionId.toString());

      final apiRepo = ref.read(leaderTrackingApiRepositoryProvider);
      await apiRepo.endSession(_currentSessionId!);

      final sharedPrefs = ref.read(sharedPreferencesServiceProvider);
      await sharedPrefs.removeInt(SharedPreferencesKeys.currentSessionId);
      _currentSessionId = null;
      _currentLeaderPosition = null;
      _lastValidLeaderPosition = null;
    } catch (e) {
      debugPrint("خطأ أثناء إغلاق الجلسة: $e");
      throw Exception(
        navigatorKey.currentContext?.locale.endSessionError ??
            'حدث خطأ أثناء إنهاء الجلسة، يرجى المحاولة مرة أخرى.',
      );
    }
  }

  Future<void> cleanUpGhostSession(int oldSessionId) async {
    try {
      final repo = ref.read(trackingRepositoryProvider);
      await repo.deleteSession(oldSessionId.toString());

      final apiRepo = ref.read(leaderTrackingApiRepositoryProvider);
      await apiRepo.endSession(oldSessionId);

      final sharedPrefs = ref.read(sharedPreferencesServiceProvider);
      await sharedPrefs.removeInt(SharedPreferencesKeys.currentSessionId);

      debugPrint("🧹 تم تنظيف الجلسة القديمة $oldSessionId بنجاح");
    } catch (e) {
      debugPrint("⚠️ خطأ أثناء تنظيف الجلسة القديمة: $e");
    }
  }
}

@riverpod
class StopLeaderSessionController extends _$StopLeaderSessionController {
  @override
  FutureOr<void> build() {}

  Future<void> stopSession() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(leaderTrackingControllerProvider.notifier)
          .stopSessionOfficially();
    });
  }
}
