import 'dart:async';
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
  StreamSubscription<DatabaseEvent>? _networkSub;

  int? _currentSessionId;
  Position? _currentLeaderPosition;
  Position? _lastValidLeaderPosition;
  DateTime? _lastLeaderUpdateTime;
  final AudioPlayer _audioPlayer = AudioPlayer()..audioCache = AudioCache(prefix: '');
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final double _yellowZone = 20;
  final double _redZone = 30;

  final Set<String> _alertedPilgrims = {};
  final Map<String, DateTime> _redZoneEntryTimes = {};
  final int _alarmDelaySeconds = 10;
  final Set<String> _yellowWarnedPilgrims = {};

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

  Future<void> startTracking(int sessionId) async {
    if (_currentSessionId == sessionId && _leaderLocationSub != null) {
      return;
    }

    await _leaderLocationSub?.cancel();
    await _pilgrimsSub?.cancel();
    await _serviceStatusSub?.cancel();
    await _networkSub?.cancel();
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
    if (_lastSentBleStatus[pilgrimId] != isSafe) {
      _lastSentBleStatus[pilgrimId] = isSafe;
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
      _processPilgrimsAndAlert(event.snapshot);
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
      gpsWarning: null,
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

      // 🔴 فلتر 1: رفض المواقع ضعيفة الدقة
      // العتبة: kLeaderAccuracyThreshold (20م) — المشرف في مناطق مكشوفة → صرامة أعلى
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
        if (_locationFilter.isSpeedJumpValid(
              distanceMeters: distanceJump,
              timeDiffSeconds: timeDiffSeconds,
              tag: ' [المشرف]',
            ) ==
            false) {
          return;
        }

        // فلتر 3: الخطوات وتصحيح الـ GPS
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
      debugPrint("الموقع اجتاز جميع الفلاتر الان سيتم تحديث الموقع");
      _applyValidPosition(position, repo);
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
        );
      } else {
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
        );
        _startLocationUpdates();
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

  void _processPilgrimsAndAlert(DataSnapshot snapshot) {
    if (_currentLeaderPosition == null) return;

    // ✅ إذا حُذف جميع الحجاج (snapshot فارغ) → امسح الماركرات من الخريطة فوراً
    if (!snapshot.exists || snapshot.value == null) {
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

    final pilgrimsData = snapshot.value as Map<dynamic, dynamic>;

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

      double finalDistance = gpsDistance; // المسافة الافتراضية هي الـ GPS

      bool isSafeByBle = false;
      LatLng displayLocation = LatLng(
        lat,
        lng,
      ); // الموقع الافتراضي للعرض في الخريطة

      int pilgrimMinorId = key.toString().hashCode % 65535;

      final bleService = ref.read(bleRadarServiceProvider);

      double?
      activeBleDistance; // مسافة BLE النشطة — تُرسَل للحاج ليعرضها بدلاً من GPS

      if (bleService.bleDistances.containsKey(pilgrimMinorId) &&
          bleService.lastBleUpdates.containsKey(pilgrimMinorId)) {
        final timeSinceLastBle = DateTime.now()
            .difference(bleService.lastBleUpdates[pilgrimMinorId]!)
            .inSeconds;
        final bleDistance = bleService.bleDistances[pilgrimMinorId]!;

        if (timeSinceLastBle <= 20) {
          if (bleDistance < gpsDistance) {
            debugPrint(
              '🛡️ [تصحيح مسافة للحاج $name] الـ GPS: ${gpsDistance.toStringAsFixed(1)}م | البلوتوث: ${bleDistance.toStringAsFixed(1)}م -> تم اعتماد البلوتوث.',
            );
            finalDistance = bleDistance;
            activeBleDistance = bleDistance; // ← حفظها لإرسالها للحاج
            isSafeByBle = true;
            debugPrint(
              'تم تجاهل المسافة التي حسبها الجيبي إس و تم إعتماد مسافة البلوتوث لأنها الأقصر و الأضمن',
            );
            double ratio = bleDistance / (gpsDistance > 0 ? gpsDistance : 1);
            displayLocation = LatLng(
              _currentLeaderPosition!.latitude +
                  (lat - _currentLeaderPosition!.latitude) * ratio,
              _currentLeaderPosition!.longitude +
                  (lng - _currentLeaderPosition!.longitude) * ratio,
            );
          }
        }
      }

      _updatePilgrimBleStatusInFirebase(
        key.toString(),
        isSafeByBle,
        bleDistance: activeBleDistance,
      );

      final pilgrim = PilgrimMarkerData(
        id: key,
        name: name,
        location: displayLocation,
        distance: finalDistance,
        lastSeen: lastSeen,
        lastHeartbeat: lastHeartbeat,
      );

      if (finalDistance <= _yellowZone) {
        green.add(pilgrim);
        _alertedPilgrims.remove(key);
        _redZoneEntryTimes.remove(key);
        _yellowWarnedPilgrims.remove(key);
        // إلغاء من الشريط
        _notificationsPlugin.cancel(key.hashCode);
        _notificationsPlugin.cancel(key.hashCode + 1000);
        // إزالة من واجهة الإشعارات ← متزامنة مع cancel()
        final store = ref.read(trackingNotificationsStoreProvider.notifier);
        store.removeNotification('leader_warn_$key');
        store.removeNotification('leader_emrg_$key');
      } else if (finalDistance > _yellowZone && finalDistance <= _redZone) {
        yellow.add(pilgrim);
        _alertedPilgrims.remove(key);
        _redZoneEntryTimes.remove(key);
        // إلغاء إشعار الطوارئ من الشريط والواجهة عند التحسّن للأصفر
        _notificationsPlugin.cancel(key.hashCode + 1000);
        ref
            .read(trackingNotificationsStoreProvider.notifier)
            .removeNotification('leader_emrg_$key');
        _triggerWarningVibration(key, name);
      } else {
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
      navigatorKey.currentContext?.locale.leaderPilgrimWarningBody(
            pilgrimName,
          ) ??
          'الحاج "$pilgrimName" بدأ يبتعد عن المجموعة.',
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
                navigatorKey.currentContext?.locale.leaderPilgrimWarningBody(
                  pilgrimName,
                ) ??
                'الحاج "$pilgrimName" بدأ يبتعد عن المجموعة.',
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
      navigatorKey.currentContext?.locale.leaderPilgrimEmergencyBody(
            pilgrimName,
          ) ??
          'الحاج "$pilgrimName" تجاوز النطاق الآمن!',
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
                navigatorKey.currentContext?.locale.leaderPilgrimEmergencyBody(
                  pilgrimName,
                ) ??
                'الحاج "$pilgrimName" تجاوز النطاق الآمن!',
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

      if (_currentSessionId != null) {
        ref.read(trackingNotificationsStoreProvider.notifier).clearBySessionId(_currentSessionId!);
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
