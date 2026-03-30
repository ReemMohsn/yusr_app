import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vibration/vibration.dart';
import 'package:yusr/core/common/providers/shared_preferences_service_provider.dart';
import 'package:yusr/core/constants/shared_preferences_keys.dart';
import 'package:yusr/features/be_leader/providers/be_leader_repository_provider.dart';
import 'package:yusr/features/be_leader/providers/state/pilgrim_tracking_state.dart';
import 'package:yusr/features/be_leader/providers/tracking_repository_provider.dart';
import 'package:yusr/core/common/providers/location_service.dart';

part 'pilgrim_tracking_controller.g.dart';

// @Riverpod(keepAlive: true)
// class PilgrimTrackingController extends _$PilgrimTrackingController {
//   StreamSubscription<Position>? _positionStreamSub;

//   @override
//   AsyncValue<void> build() {
//     // إغلاق الاستماع تلقائياً إذا تم تدمير الـ Provider
//     ref.onDispose(() {
//       stopTracking();
//     });
//     return const AsyncData(null);
//   }

//   Future<void> acceptAndStartTracking({
//     required int sessionId,
//     required String pilgrimId,
//     required String pilgrimName,
//   }) async {
//     state = const AsyncLoading();
//     try {
//       final trackingApiRepo = ref.read(leaderTrackingApiRepositoryProvider);

//       print("1️⃣ جاري إرسال الموافقة للـ API...");
//       await trackingApiRepo.respondToSession(sessionId, 2);
//       print("✅ تم الإرسال للـ API بنجاح!");

//       print("2️⃣ جاري فحص حالة خدمة الـ GPS في الهاتف...");
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         state = AsyncError("خدمة الموقع مغلقة في الهاتف.", StackTrace.current);
//         return;
//       }
//       print("✅ خدمة الـ GPS مفعلة.");

//       print("3️⃣ جاري فحص الصلاحيات...");
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           state = AsyncError("صلاحية الموقع مرفوضة.", StackTrace.current);
//           return;
//         }
//       }

//       if (permission == LocationPermission.deniedForever) {
//         state = AsyncError("صلاحية الموقع مرفوضة دائماً.", StackTrace.current);
//         return;
//       }
//       print("✅ الصلاحيات ممنوحة: $permission");

//       final trackingRepo = ref.read(trackingRepositoryProvider);

//       print("4️⃣ جاري جلب الموقع الأولي (مسموح بـ 15 ثانية كحد أقصى)...");
//       // الإضافة الأهم: مهلة زمنية (timeLimit) لمنع التجميد الما لا نهاية
//       final initialPosition = await Geolocator.getCurrentPosition(
//         locationSettings: const LocationSettings(
//           accuracy: LocationAccuracy.high,
//           timeLimit: Duration(seconds: 15),
//         ),
//       );

//       print("✅ تم جلب الموقع! جاري الرفع للفايربيس...");
//       await trackingRepo.updatePilgrimLocation(
//         sessionId: sessionId,
//         pilgrimId: pilgrimId,
//         pilgrimName: pilgrimName,
//         location: LatLng(initialPosition.latitude, initialPosition.longitude),
//       );
//       print("🚀 تم رفع الموقع الأولي للفايربيس بنجاح!");

//       // print("5️⃣ جاري بدء الاستماع للتحركات المستمرة...");
//       // final locationService = ref.read(locationServiceProvider);
//       // _positionStreamSub = locationService.positionStream.listen((
//       //   Position position,
//       // ) {
//       //   final currentPos = LatLng(position.latitude, position.longitude);
//       //   trackingRepo.updatePilgrimLocation(
//       //     sessionId: sessionId,
//       //     pilgrimId: pilgrimId,
//       //     pilgrimName: pilgrimName,
//       //     location: currentPos,
//       //   );
//       //   print("📍 تم تحديث موقع الحاج في الفايربيس بنجاح!");
//       // });
//       print("5️⃣ جاري بدء الاستماع للتحركات المستمرة...");
//       final locationService = ref.read(locationServiceProvider);

//       // 👈 التعديل هنا: إغلاق أي استماع قديم قبل فتح واحد جديد لمنع التكرار
//       await _positionStreamSub?.cancel();

//       _positionStreamSub = locationService.positionStream.listen((
//         Position position,
//       ) {
//         final currentPos = LatLng(position.latitude, position.longitude);
//         trackingRepo.updatePilgrimLocation(
//           sessionId: sessionId,
//           pilgrimId: pilgrimId,
//           pilgrimName: pilgrimName,
//           location: currentPos,
//         );
//         print("📍 تم تحديث موقع الحاج في الفايربيس بنجاح!");
//       });

//       state = const AsyncData(null);
//     } catch (e, st) {
//       print("❌ حدث خطأ (ربما انتهت المهلة أو تعذر الرفع): $e");
//       state = AsyncError(e, st);
//     }
//   }
//   Future<void> rejectSession({required int sessionId}) async {
//     state = const AsyncLoading();
//     try {
//       final trackingApiRepo = ref.read(leaderTrackingApiRepositoryProvider);

//       // نرسل رقم 3 (غير موافق)
//       await trackingApiRepo.respondToSession(sessionId, 3);

//       state = const AsyncData(null);
//       print("❌ تم رفض الجلسة بنجاح وإبلاغ الخادم.");
//     } catch (e, st) {
//       state = AsyncError(e, st);
//     }
//   }

//   // دالة لإيقاف التتبع (مثلاً إذا انتهت الجلسة)
//   void stopTracking() {
//     _positionStreamSub?.cancel();
//     _positionStreamSub = null;
//     print("🛑 تم إيقاف تتبع الحاج.");
//   }

// }

@Riverpod(keepAlive: true)
class PilgrimTrackingController extends _$PilgrimTrackingController {
  StreamSubscription<Position>? _positionStreamSub;
  StreamSubscription<DatabaseEvent>? _leaderStreamSub;
  Timer? _leaderTimeoutTimer;

  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final double _yellowZone = 75.0;
  final double _redZone = 150.0;
  bool _isAlarmActive = false; // لمنع تكرار تشغيل الصوت

  @override
  PilgrimTrackingState build() {
    ref.onDispose(() {
      stopTracking();
    });
    return PilgrimTrackingState();
  }

  // 2. أضف هذه الدالة للتحكم في المؤقت
  void _resetLeaderTimeoutTimer() {
    _leaderTimeoutTimer?.cancel();
    // ضبط المؤقت على 30 دقيقة (للتجربة أثناء البرمجة اجعلها 1 دقيقة)
    _leaderTimeoutTimer = Timer(const Duration(minutes: 30), () {
      // 🔴 مرت 30 دقيقة ولم يصل تحديث من المشرف!
      _handleLeaderDisappearance();
    });
  }

  // 3. دالة التعامل مع اختفاء المشرف
  void _handleLeaderDisappearance() {
    // إيقاف التتبع محلياً (هذه الدالة موجودة لديك وتقوم بمسح SharedPreferences وإيقاف Streams)
    stopTracking();

    // نغير الحالة لكي تخرج شاشة الخريطة وتظهر رسالة للحاج
    state = PilgrimTrackingState(
      errorMessage: 'تم إيقاف التتبع لأن المشرف فقد الاتصال لأكثر من 30 دقيقة.',
    );
  }

  Future<void> acceptAndStartTracking({
    required int sessionId,
    required String pilgrimId,
    required String pilgrimName,
  }) async {
    state = PilgrimTrackingState(isLoading: true);

    try {
      final trackingApiRepo = ref.read(leaderTrackingApiRepositoryProvider);
      await trackingApiRepo.respondToSession(sessionId, 2);

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = PilgrimTrackingState(
          errorMessage: "خدمة الموقع مغلقة في الهاتف.",
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          state = PilgrimTrackingState(errorMessage: "صلاحية الموقع مرفوضة.");
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        state = PilgrimTrackingState(
          errorMessage: "صلاحية الموقع مرفوضة دائماً.",
        );
        return;
      }

      final trackingRepo = ref.read(trackingRepositoryProvider);
      // 🔥 التعديل 1: حفظ رقم الجلسة في SharedPreferences لكي يظهر زر الوصول السريع
      final sharedPrefs = ref.read(sharedPreferencesServiceProvider);
      await sharedPrefs.setInt(SharedPreferencesKeys.sessionId, sessionId);

      // 1. جلب الموقع الأولي
      final initialPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      final initialLatLng = LatLng(
        initialPosition.latitude,
        initialPosition.longitude,
      );

      await trackingRepo.updatePilgrimLocation(
        sessionId: sessionId,
        pilgrimId: pilgrimId,
        pilgrimName: pilgrimName,
        location: initialLatLng,
      );

      state = PilgrimTrackingState(pilgrimLocation: initialLatLng);

      // 2. الاستماع المستمر لموقع الحاج (GPS) ورفعه للفايربيس
      final locationService = ref.read(locationServiceProvider);
      await _positionStreamSub?.cancel();
      _positionStreamSub = locationService.positionStream.listen((
        Position position,
      ) {
        final currentPos = LatLng(position.latitude, position.longitude);

        trackingRepo.updatePilgrimLocation(
          sessionId: sessionId,
          pilgrimId: pilgrimId,
          pilgrimName: pilgrimName,
          location: currentPos,
        );

        _updateStateAndCheckDistance(
          pilgrimLoc: currentPos,
          leaderLoc: state.leaderLocation,
        );
      });

      // 3. الاستماع المستمر لموقع المشرف من الفايربيس
      await _leaderStreamSub?.cancel();
      _leaderStreamSub = trackingRepo.leaderStream(sessionId.toString()).listen((
        DatabaseEvent event,
      ) {
        if (event.snapshot.exists) {
          final data = event.snapshot.value as Map<dynamic, dynamic>;
          final lat = data['latitude'];
          final lng = data['longitude'];

          if (lat != null && lng != null) {
            final leaderPos = LatLng(lat, lng);

            // 🌟 السطر السحري: المشرف تحرك! قم بتصفير العداد لتبدأ الـ 30 دقيقة من جديد
            _resetLeaderTimeoutTimer();

            _updateStateAndCheckDistance(
              pilgrimLoc: state.pilgrimLocation,
              leaderLoc: leaderPos,
            );
          }
        }
      });

      // _leaderStreamSub = trackingRepo.leaderStream(sessionId.toString()).listen(
      //   (DatabaseEvent event) {
      //     if (event.snapshot.exists) {
      //       final data = event.snapshot.value as Map<dynamic, dynamic>;
      //       final lat = data['latitude'];
      //       final lng = data['longitude'];

      //       if (lat != null && lng != null) {
      //         final leaderPos = LatLng(lat, lng);
      //         _updateStateAndCheckDistance(
      //           pilgrimLoc: state.pilgrimLocation,
      //           leaderLoc: leaderPos,
      //         );
      //       }
      //     }
      //   },
      // );
    } catch (e) {
      state = PilgrimTrackingState(errorMessage: e.toString());
      final sharedPrefs = ref.read(sharedPreferencesServiceProvider);
      await sharedPrefs.removeInt(SharedPreferencesKeys.sessionId);
    }
  }

  // دالة لحساب المسافة وتحديث الحالة وتشغيل الإنذار
  void _updateStateAndCheckDistance({LatLng? pilgrimLoc, LatLng? leaderLoc}) {
    if (pilgrimLoc == null || leaderLoc == null) {
      state = PilgrimTrackingState(
        pilgrimLocation: pilgrimLoc ?? state.pilgrimLocation,
        leaderLocation: leaderLoc ?? state.leaderLocation,
        distance: state.distance,
      );
      return;
    }

    final distance = Geolocator.distanceBetween(
      pilgrimLoc.latitude,
      pilgrimLoc.longitude,
      leaderLoc.latitude,
      leaderLoc.longitude,
    );

    state = PilgrimTrackingState(
      pilgrimLocation: pilgrimLoc,
      leaderLocation: leaderLoc,
      distance: distance,
    );

    if (distance > _redZone) {
      _triggerEmergency();
    } else {
      stopAlarmManual();
    }
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
      1,
      '🚨 إنذار خطر!',
      'لقد ابتعدت عن المشرف خارج النطاق المسموح!',
      const NotificationDetails(android: androidDetails),
    );

    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(pattern: [500, 1000, 500, 1000]);
    }
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('sounds/alarm.mp3'));
  }

  void stopAlarmManual() {
    if (_isAlarmActive) {
      _audioPlayer.stop();
      Vibration.cancel();
      _isAlarmActive = false;
    }
  }

  Future<void> rejectSession({required int sessionId}) async {
    state = PilgrimTrackingState(isLoading: true);
    try {
      final trackingApiRepo = ref.read(leaderTrackingApiRepositoryProvider);
      await trackingApiRepo.respondToSession(sessionId, 3);
      // 🔥 التعديل 2: التأكد من مسح الجلسة في حالة الرفض
      final sharedPrefs = ref.read(sharedPreferencesServiceProvider);
      await sharedPrefs.removeInt(SharedPreferencesKeys.sessionId);
      state = PilgrimTrackingState(); // إعادة تعيين
    } catch (e) {
      state = PilgrimTrackingState(errorMessage: e.toString());
    }
  }

  void stopTracking() {
    _positionStreamSub?.cancel();
    _leaderStreamSub?.cancel();
    _positionStreamSub = null;
    _leaderStreamSub = null;
    stopAlarmManual();
    _leaderTimeoutTimer?.cancel();

    // 🔥 التعديل 3: مسح الجلسة عند إيقاف التتبع لإخفاء الزر من الواجهة الرئيسية
    final sharedPrefs = ref.read(sharedPreferencesServiceProvider);
    sharedPrefs.removeInt(SharedPreferencesKeys.sessionId);
    state = PilgrimTrackingState();
  }
  // أضف هذه الدالة داخل PilgrimTrackingController

  Future<void> leaveAndStopTracking({
    required int sessionId,
    required String pilgrimId,
  }) async {
    try {
      // 1. إرسال طلب للباك إند لتغيير حالة الحاج وإشعار المشرف
      // افترضنا أن الحالة 3 تعني "تم إيقاف التتبع/إلغاء" بناءً على الكود السابق
      final trackingApiRepo = ref.read(leaderTrackingApiRepositoryProvider);
      await trackingApiRepo.respondToSession(sessionId, 4);

      // 2. حذف الحاج من غرفة الفايربيس لكي يختفي من خريطة المشرف
      final trackingRepo = ref.read(trackingRepositoryProvider);
      await trackingRepo.removePilgrimFromSession(
        sessionId: sessionId.toString(),
        pilgrimId: pilgrimId,
      );

      // 3. إيقاف التتبع المحلي وتنظيف الذاكرة (هذه الدالة موجودة لديك مسبقاً)
      stopTracking();
    } catch (e) {
      // يمكنك التعامل مع الخطأ هنا، مثلاً عرض رسالة للمستخدم
      state = PilgrimTrackingState(errorMessage: e.toString());
    }
  }
}
