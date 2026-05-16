import 'dart:async';
import 'package:flutter/foundation.dart';
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
import 'package:yusr/features/be_leader/presentation/services/tracking_strings.dart';
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
  final AudioPlayer _audioPlayer = AudioPlayer();
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
          gpsWarning: TrackingStrings.gpsServiceDisabled,
        );
      }

      // 2️⃣ فحص وطلب الصلاحيات (انتقل إلى LocationService)
      final permissionsGranted = await locationService
          .ensurePermissionsGranted();
      if (!permissionsGranted) {
        state = TrackingState(
          isLoading: false,
          gpsWarning: TrackingStrings.gpsPermissionDenied,
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
        gpsWarning: TrackingStrings.gpsSystemError,
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
      if (position.accuracy > 25) {
        debugPrint(
          "⚠️ [المشرف] ❌ دقة ضعيفة (${position.accuracy}  م).فقط وعدم الإعتماد و أخد هذه القراءة  إرسال نبضة حياة...",
        );

        // 🌟 الحل (نبضة الحياة): نرسل آخر موقع معروف للفايربيس لكي لا تنغلق الجلسة!
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
        return; // نوقف الكود هنا لكي لا نحدث الخريطة بالموقع المشوش
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
            false)
          return;

        // فلتر 3: الخطوات
        if (!_locationFilter.isMovementReal(distanceJump, tag: ' [المشرف]')) {
          debugPrint(
            '🛑 [حماية] قفزة GPS وهمية — لا خطوات كافية للمسافة المقطوعة!',
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
          gpsWarning: TrackingStrings.gpsDisabled,
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
          gpsWarning: TrackingStrings.gpsReenabledLeader,
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
    if (_currentLeaderPosition == null || !snapshot.exists) return;

    final pilgrimsData = snapshot.value as Map<dynamic, dynamic>;

    List<PilgrimMarkerData> green = [];
    List<PilgrimMarkerData> yellow = [];
    List<PilgrimMarkerData> red = [];
    bool hasRedPilgrims = false;

    pilgrimsData.forEach((key, value) {
      final lat = value['latitude'];
      final lng = value['longitude'];
      final name = value['name'] ?? TrackingStrings.unknownPilgrim;
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
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(pattern: [0, 200, 100, 200, 100, 200, 100, 200]);
    }
    final AndroidNotificationDetails warningDetails =
        AndroidNotificationDetails(
          'warning_channel',
          TrackingStrings.leaderWarningChannelName,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          playSound: false,
          enableVibration: false,
        );
    await _notificationsPlugin.show(
      pilgrimId.hashCode,
      TrackingStrings.leaderPilgrimWarningTitle,
      TrackingStrings.leaderPilgrimWarningBody(pilgrimName),
      NotificationDetails(android: warningDetails),
      payload: 'warning_notification',
    );
    // حفظ في الواجهة ← متزامن مع show()
    ref
        .read(trackingNotificationsStoreProvider.notifier)
        .addNotification(
          TrackingNotificationModel(
            id: 'leader_warn_$pilgrimId',
            title: TrackingStrings.leaderPilgrimWarningTitle,
            body: TrackingStrings.leaderPilgrimWarningBody(pilgrimName),
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
          TrackingStrings.leaderEmergencyChannelName,
          importance: Importance.max,
          priority: Priority.high,
        );
    await _notificationsPlugin.show(
      pilgrimId.hashCode + 1000,
      TrackingStrings.leaderPilgrimEmergencyTitle,
      TrackingStrings.leaderPilgrimEmergencyBody(pilgrimName),
      NotificationDetails(android: androidDetails),
      payload: 'emergency_notification',
    );
    // حفظ في الواجهة ← متزامن مع show()
    ref
        .read(trackingNotificationsStoreProvider.notifier)
        .addNotification(
          TrackingNotificationModel(
            id: 'leader_emrg_$pilgrimId',
            title: TrackingStrings.leaderPilgrimEmergencyTitle,
            body: TrackingStrings.leaderPilgrimEmergencyBody(pilgrimName),
            timestamp: DateTime.now().toIso8601String(),
            type: TrackingNotificationType.leaderEmergency,
            sessionId: _currentSessionId,
            pilgrimName: pilgrimName,
          ),
        );
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(pattern: [500, 1000, 500, 1000]);
    }
    if (!_isMutedManually) {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(AssetSource('sounds/alarm.mp3'));
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
      throw Exception(TrackingStrings.endSessionError);
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
