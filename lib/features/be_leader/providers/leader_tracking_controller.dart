import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:yusr/features/be_leader/providers/be_leader_repository_provider.dart';
import 'package:yusr/features/be_leader/providers/state/pilgrim_marker_data.dart';
import 'package:yusr/features/be_leader/providers/tracking_repository_provider.dart';

part 'leader_tracking_controller.g.dart';

class TrackingState {
  final LatLng? leaderLocation;
  final List<PilgrimMarkerData> greenPilgrims;
  final List<PilgrimMarkerData> yellowPilgrims;
  final List<PilgrimMarkerData> redPilgrims;
  final bool isLoading;

  TrackingState({
    this.leaderLocation,
    this.greenPilgrims = const [],
    this.yellowPilgrims = const [],
    this.redPilgrims = const [],
    this.isLoading = true,
  });

  int get totalPilgrims =>
      greenPilgrims.length + yellowPilgrims.length + redPilgrims.length;
}

@Riverpod(keepAlive: true)
class LeaderTrackingController extends _$LeaderTrackingController {
  StreamSubscription<Position>? _leaderLocationSub;
  StreamSubscription<DatabaseEvent>? _pilgrimsSub;
  int? _currentSessionId;
  Position? _currentLeaderPosition;

  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final double _yellowZone = 75.0;
  final double _redZone = 150.0;
  final Set<String> _alertedPilgrims = {};
  // 💡 هذا المؤشر يخبرنا إذا كانت الوظيفة تعمل حالياً في الذاكرة أم لا
  bool get isCurrentlyTracking =>
      _currentSessionId != null && _leaderLocationSub != null;
  @override
  TrackingState build() {
    return TrackingState();
  }

  Future<void> startTracking(int sessionId) async {
    // 🛑 1. شرط الحماية (يمنع التكرار)
    if (_currentSessionId == sessionId && _leaderLocationSub != null) {
      debugPrint("الجلسة تعمل مسبقاً في الخلفية، لا حاجة لإعادة التشغيل.");
      return;
    }

    // 🧹 2. تنظيف الأمان
    await _leaderLocationSub?.cancel();
    await _pilgrimsSub?.cancel();

    _currentSessionId = sessionId;
    state = TrackingState(isLoading: true);

    try {
      // 🛡️ 3. فحص صلاحيات الموقع (بدونها سيفشل التتبع بصمت)
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint("خدمة الـ GPS مغلقة في هاتف المشرف.");
        state = TrackingState(isLoading: false); // إيقاف التحميل
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          debugPrint("صلاحيات الموقع مرفوضة.");
          state = TrackingState(isLoading: false); // إيقاف التحميل
          return;
        }
      }

      // ⚡ 4. جلب الموقع الأولي بسرعة لكي تختفي دائرة التحميل فوراً!
      final initialPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      _currentLeaderPosition = initialPosition;
      final initialLatLng = LatLng(
        initialPosition.latitude,
        initialPosition.longitude,
      );

      // تحديث الواجهة فوراً لإخفاء مؤشر التحميل
      state = TrackingState(leaderLocation: initialLatLng, isLoading: false);

      // استخدام الـ Providers
      final repo = ref.read(trackingRepositoryProvider);
      final locationService = ref.read(locationServiceProvider);

      // رفع الموقع الأولي للفايربيس
      repo.updateLeaderLocation(
        sessionId: _currentSessionId.toString(),
        location: initialLatLng,
        heading: initialPosition.heading,
      );

      // 5. استماع موقع المشرف المستمر
      _leaderLocationSub = locationService.foregroundPositionStream.listen(
        (Position position) {
          _currentLeaderPosition = position;
          final leaderLatLng = LatLng(position.latitude, position.longitude);

          repo.updateLeaderLocation(
            sessionId: _currentSessionId.toString(),
            location: leaderLatLng,
            heading: position.heading,
          );

          state = TrackingState(
            leaderLocation: leaderLatLng,
            greenPilgrims: state.greenPilgrims,
            yellowPilgrims: state.yellowPilgrims,
            redPilgrims: state.redPilgrims,
            isLoading: false,
          );
        },
        onError: (e) {
          debugPrint("خطأ في Stream المشرف: $e");
        },
      );

      // 6. استماع مواقع الحجاج
      _pilgrimsSub = repo
          .pilgrimsStream(_currentSessionId.toString())
          .listen(
            (DatabaseEvent event) {
              _processPilgrimsAndAlert(event.snapshot);
            },
            onError: (e) {
              debugPrint("خطأ في Stream الحجاج: $e");
            },
          );
    } catch (e) {
      debugPrint("خطأ غير متوقع أثناء بدء التتبع: $e");
      state = TrackingState(isLoading: false); // إيقاف التحميل عند حدوث أي خطأ
    }
  }

  // Future<void> startTracking(int sessionId) async {
  //   // 🛑 1. شرط الحماية (الذي سيمنع التكرار الذي قلقت أنت منه)
  //   // إذا كان الكنترولر يعمل بالفعل لنفس الجلسة، لا تفعل أي شيء واخرج من الدالة فوراً!
  //   if (_currentSessionId == sessionId && _leaderLocationSub != null) {
  //     debugPrint("الجلسة تعمل مسبقاً في الخلفية، لا حاجة لإعادة التشغيل.");
  //     return;
  //   }

  //   // 🧹 2. تنظيف الأمان (إذا كان هناك جلسة قديمة معلقة، نغلقها قبل فتح الجديدة)
  //   await _leaderLocationSub?.cancel();
  //   await _pilgrimsSub?.cancel();

  //   _currentSessionId = sessionId;
  //   state = TrackingState(isLoading: true);

  //   // استخدام الـ Providers الخاصة بك
  //   final repo = ref.read(trackingRepositoryProvider);
  //   final locationService = ref.read(locationServiceProvider);

  //   // 1. استماع موقع المشرف باستخدام الـ Service الخاص بك
  //   _leaderLocationSub = locationService.foregroundPositionStream.listen((
  //     Position position,
  //   ) {
  //     _currentLeaderPosition = position;

  //     final leaderLatLng = LatLng(position.latitude, position.longitude);

  //     // رفع الموقع للفايربيس باستخدام الـ Repository
  //     repo.updateLeaderLocation(
  //       sessionId: _currentSessionId.toString(),
  //       location: leaderLatLng,
  //       heading: position.heading,
  //     );

  //     // تحديث حالة الواجهة
  //     state = TrackingState(
  //       leaderLocation: leaderLatLng,
  //       greenPilgrims: state.greenPilgrims,
  //       yellowPilgrims: state.yellowPilgrims,
  //       redPilgrims: state.redPilgrims,
  //       isLoading: false,
  //     );
  //   });

  //   // 2. استماع مواقع الحجاج باستخدام الـ Repository
  //   _pilgrimsSub = repo.pilgrimsStream(_currentSessionId.toString()).listen((
  //     DatabaseEvent event,
  //   ) {
  //     _processPilgrimsAndAlert(event.snapshot);
  //   });
  // }

  void _processPilgrimsAndAlert(DataSnapshot snapshot) {
    if (_currentLeaderPosition == null || !snapshot.exists) return;

    final pilgrimsData = snapshot.value as Map<dynamic, dynamic>;

    List<PilgrimMarkerData> green = [];
    List<PilgrimMarkerData> yellow = [];
    List<PilgrimMarkerData> red = [];
    bool hasRedPilgrims = false;

    pilgrimsData.forEach((key, value) {
      // ⚠️ استخدمنا latitude و longitude لتطابق بياناتك في TrackingRepository
      final lat = value['latitude'];
      final lng = value['longitude'];
      final name = value['name'] ?? 'أحد الحجاج';

      if (lat == null || lng == null) return;

      final distance = Geolocator.distanceBetween(
        _currentLeaderPosition!.latitude,
        _currentLeaderPosition!.longitude,
        lat,
        lng,
      );

      final pilgrim = PilgrimMarkerData(
        id: key,
        name: name,
        location: LatLng(lat, lng),
      );

      if (distance <= _yellowZone) {
        green.add(pilgrim);
        _alertedPilgrims.remove(key);
      } else if (distance > _yellowZone && distance <= _redZone) {
        yellow.add(pilgrim);
      } else {
        red.add(pilgrim);
        hasRedPilgrims = true;
        _triggerEmergency(key, name);
      }
    });

    // إيقاف الإنذار إذا عاد جميع الحجاج للوضع الآمن
    if (!hasRedPilgrims) {
      stopAlarmManual();
    }

    state = TrackingState(
      leaderLocation: state.leaderLocation,
      greenPilgrims: green,
      yellowPilgrims: yellow,
      redPilgrims: red,
      isLoading: false,
    );
  }

  Future<void> _triggerEmergency(String pilgrimId, String pilgrimName) async {
    if (_alertedPilgrims.contains(pilgrimId)) return;
    _alertedPilgrims.add(pilgrimId);

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'emergency_channel',
          'طوارئ الحجاج',
          importance: Importance.max,
          priority: Priority.high,
        );
    await _notificationsPlugin.show(
      0,
      '🚨 إنذار خطر!',
      'الحاج $pilgrimName خرج عن النطاق المسموح!',
      const NotificationDetails(android: androidDetails),
      payload: 'emergency_alarm', // 👈 أضفنا هذه الكلمة لتمييز إشعار الخطر
    );

    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(pattern: [500, 1000, 500, 1000]);
    }
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('sounds/alarm.mp3'));
  }

  // دالة لإيقاف الإنذار يدوياً
  void stopAlarmManual() {
    _audioPlayer.stop();
    Vibration.cancel();
  }

  // الإيقاف الرسمي
  Future<void> stopSessionOfficially() async {
    if (_currentSessionId == null) return;

    try {
      state = TrackingState(isLoading: true);

      // 1. إيقاف الاستماع
      await _leaderLocationSub?.cancel();
      await _pilgrimsSub?.cancel();
      stopAlarmManual();

      // 2. استخدام Repository لحذف الجلسة
      final repo = ref.read(trackingRepositoryProvider);
      await repo.deleteSession(_currentSessionId.toString());

      // 3. طلب الـ API لإنهاء الجلسة (إذا كان لديك API Repository)
      final apiRepo = ref.read(leaderTrackingApiRepositoryProvider);
      await apiRepo.endSession(_currentSessionId!);

      // د. حذف الـ SessionId من الـ SharedPreferences
      final sharedPrefs = ref.read(sharedPreferencesServiceProvider);
      await sharedPrefs.removeInt(SharedPreferencesKeys.currentSessionId);

      _currentSessionId = null;
      _currentLeaderPosition = null;
    } catch (e) {
      print("خطأ أثناء إغلاق الجلسة: $e");
    }
  }

  // دالة تنظيف الجلسات الشبحية (تُستدعى من التوجيه)
  Future<void> cleanUpGhostSession(int oldSessionId) async {
    try {
      // 1. حذف الجلسة من الفايربيس
      final repo = ref.read(trackingRepositoryProvider);
      await repo.deleteSession(oldSessionId.toString());

      // 2. إنهاء الجلسة في الباك إند
      final apiRepo = ref.read(leaderTrackingApiRepositoryProvider);
      await apiRepo.endSession(oldSessionId);

      // 3. مسح الذاكرة المحلية
      final sharedPrefs = ref.read(sharedPreferencesServiceProvider);
      await sharedPrefs.removeInt(SharedPreferencesKeys.currentSessionId);

      debugPrint("🧹 تم تنظيف الجلسة القديمة $oldSessionId بنجاح");
    } catch (e) {
      debugPrint("⚠️ خطأ أثناء تنظيف الجلسة القديمة: $e");
    }
  }
}
