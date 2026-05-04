import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:pedometer/pedometer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vibration/vibration.dart';
import 'package:yusr/core/common/providers/shared_preferences_service_provider.dart';
import 'package:yusr/core/constants/shared_preferences_keys.dart';
import 'package:yusr/features/be_leader/providers/be_leader_repository_provider.dart';
import 'package:yusr/features/be_leader/providers/state/pilgrim_tracking_state.dart';
import 'package:yusr/features/be_leader/providers/tracking_repository_provider.dart';
import 'package:permission_handler/permission_handler.dart' hide ServiceStatus;
import 'package:yusr/core/common/providers/location_service.dart';
// import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';
part 'pilgrim_tracking_controller.g.dart';

// @Riverpod(keepAlive: true)
// class PilgrimTrackingController extends _$PilgrimTrackingController {
//   StreamSubscription<Position>? _positionStreamSub;
//   StreamSubscription<DatabaseEvent>? _leaderStreamSub;
//   Timer? _leaderTimeoutTimer;
//   DateTime? _redZoneEntryTime; // لتتبع متى دخل الحاج النطاق الأحمر
//   bool _hasWarnedYellow = false; // لمنع تكرار اهتزاز التحذير الأصفر
//   final int _alarmDelaySeconds = 10; // 10 ثواني سماحية قبل إطلاق الإنذار
//   StreamSubscription<ServiceStatus>?
//   _serviceStatusSub; // 👈 إضافة مستمع الـ GPS

//   final AudioPlayer _audioPlayer = AudioPlayer();
//   final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   final double _yellowZone = 20;
//   final double _redZone = 40;
//   bool _isAlarmActive = false; // لمنع تكرار تشغيل الصوت

//   @override
//   PilgrimTrackingState build() {
//     ref.onDispose(() {
//       stopTracking();
//     });
//     return PilgrimTrackingState();
//   }

//   // 2. أضف هذه الدالة للتحكم في المؤقت
//   void _resetLeaderTimeoutTimer() {
//     _leaderTimeoutTimer?.cancel();
//     // ضبط المؤقت على 30 دقيقة (للتجربة أثناء البرمجة اجعلها 1 دقيقة)
//     _leaderTimeoutTimer = Timer(const Duration(minutes: 30), () {
//       // 🔴 مرت 30 دقيقة ولم يصل تحديث من المشرف!
//       _handleLeaderDisappearance();
//     });
//   }

//   // 3. دالة التعامل مع اختفاء المشرف
//   void _handleLeaderDisappearance() {
//     // إيقاف التتبع محلياً (هذه الدالة موجودة لديك وتقوم بمسح SharedPreferences وإيقاف Streams)
//     stopTracking();

//     // نغير الحالة لكي تخرج شاشة الخريطة وتظهر رسالة للحاج
//     state = PilgrimTrackingState(
//       errorMessage: 'تم إيقاف التتبع لأن المشرف فقد الاتصال لأكثر من 30 دقيقة.',
//     );
//   }

//   Future<void> acceptAndStartTracking({
//     required int sessionId,
//     required String pilgrimId,
//     required String pilgrimName,
//   }) async {
//     state = PilgrimTrackingState(isLoading: true);

//     try {
//       final trackingApiRepo = ref.read(leaderTrackingApiRepositoryProvider);
//       await trackingApiRepo.respondToSession(sessionId, 2);

//       final trackingRepo = ref.read(trackingRepositoryProvider);
//       final sharedPrefs = ref.read(sharedPreferencesServiceProvider);
//       await sharedPrefs.setInt(SharedPreferencesKeys.sessionId, sessionId);
//       final locationService = ref.read(locationServiceProvider);

//       // 🌟 1. التحقق من صلاحيات الموقع أولاً (مهم جداً وبدونه لن يعمل التتبع)
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         state = PilgrimTrackingState(
//           pilgrimLocation: null,
//           leaderLocation: state.leaderLocation,
//           gpsWarning: "يرجى تفعيل خدمة الـ GPS (الموقع) في هاتفك.",
//         );
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied ||
//             permission == LocationPermission.deniedForever) {
//           state = PilgrimTrackingState(
//             pilgrimLocation: null,
//             leaderLocation: state.leaderLocation,
//             gpsWarning: "صلاحية الموقع مرفوضة. يرجى تفعيلها من إعدادات الهاتف.",
//           );
//           return; // إيقاف العملية هنا لأنه لا يوجد صلاحية للوصول للموقع
//         }
//       }

//       // 🌟 2. دالة محلية لمحاولة جلب الموقع الفوري وتحديث الواجهة والفايربيس
//       Future<void> tryFetchLocationNow() async {
//         try {
//           Position initialPosition = await Geolocator.getCurrentPosition(
//             locationSettings: const LocationSettings(
//               accuracy: LocationAccuracy.high,
//               timeLimit: Duration(seconds: 10),
//             ),
//           );
//           final initialLatLng = LatLng(
//             initialPosition.latitude,
//             initialPosition.longitude,
//           );

//           // تحديث الفايربيس
//           await trackingRepo.updatePilgrimLocation(
//             sessionId: sessionId,
//             pilgrimId: pilgrimId,
//             pilgrimName: pilgrimName,
//             location: initialLatLng,
//           );

//           // تحديث الواجهة لتصبح "متصل"
//           _updateStateAndCheckDistance(
//             pilgrimLoc: initialLatLng,
//             leaderLoc: state.leaderLocation,
//             clearWarning: true, // إزالة أي تحذير سابق
//           );
//         } catch (e) {
//           debugPrint("فشل في جلب الموقع الأولي: $e");
//           // سيتكفل الـ Stream أدناه بجلب الموقع فور توفره
//         }
//       }

//       // 🌟 3. الاستماع المستمر لتشغيل وإيقاف الـ GPS من شريط الإشعارات
//       _serviceStatusSub?.cancel();
//       _serviceStatusSub = Geolocator.getServiceStatusStream().listen((
//         ServiceStatus status,
//       ) {
//         if (status == ServiceStatus.disabled) {
//           // عندما يغلق الحاج الـ GPS: نحذف موقعه لكي يظهر في الخريط الشريط البرتقالي
//           state = PilgrimTrackingState(
//             pilgrimLocation:
//                 null, // 👈 هذا ما يغير حالة الشريط إلى جاري جلب الموقع
//             leaderLocation: state.leaderLocation,
//             distance: state.distance,
//             gpsWarning: "تم إغلاق خدمة الموقع (GPS) في الهاتف. يرجى تفعيلها.",
//           );
//         } else if (status == ServiceStatus.enabled) {
//           // عندما يفتح الحاج الـ GPS
//           state = PilgrimTrackingState(
//             pilgrimLocation: state.pilgrimLocation,
//             leaderLocation: state.leaderLocation,
//             distance: state.distance,
//             gpsWarning: "تم تفعيل الـ GPS، جاري التقاط الإشارة...",
//           );
//           tryFetchLocationNow(); // محاولة التقاط الموقع فوراً
//         }
//       });

//       // 🌟 4. جلب الموقع الأولي فوراً عند فتح الشاشة والـ GPS يعمل
//       if (serviceEnabled) {
//         await tryFetchLocationNow();
//       }

//       // 🌟 5. تفعيل الاستماع المستمر لموقع الحاج أثناء التحرك
//       await _positionStreamSub?.cancel();
//       _positionStreamSub = locationService.foregroundPositionStream.listen(
//         (Position position) {
//           final currentPos = LatLng(position.latitude, position.longitude);

//           trackingRepo.updatePilgrimLocation(
//             sessionId: sessionId,
//             pilgrimId: pilgrimId,
//             pilgrimName: pilgrimName,
//             location: currentPos,
//           );

//           _updateStateAndCheckDistance(
//             pilgrimLoc: currentPos,
//             leaderLoc: state.leaderLocation,
//             clearWarning: true,
//           );
//         },
//         onError: (error) {
//           debugPrint("خطأ في مستمع الموقع: $error");
//         },
//       );

//       // 🌟 6. الاستماع لموقع المشرف من الفايربيس
//       await _leaderStreamSub?.cancel();
//       _leaderStreamSub = trackingRepo.leaderStream(sessionId.toString()).listen(
//         (DatabaseEvent event) {
//           if (event.snapshot.exists) {
//             final data = event.snapshot.value as Map<dynamic, dynamic>;
//             final lat = data['latitude'];
//             final lng = data['longitude'];

//             if (lat != null && lng != null) {
//               final leaderPos = LatLng(lat, lng);
//               _resetLeaderTimeoutTimer();
//               _updateStateAndCheckDistance(
//                 pilgrimLoc: state.pilgrimLocation,
//                 leaderLoc: leaderPos,
//               );
//             }
//           }
//         },
//       );
//     } catch (e) {
//       state = PilgrimTrackingState(errorMessage: e.toString());
//       final sharedPrefs = ref.read(sharedPreferencesServiceProvider);
//       await sharedPrefs.removeInt(SharedPreferencesKeys.sessionId);
//     }
//   }

//   // 👈 دالة مساعدة لجلب الموقع الأولي لتنظيف الكود
//   Future<void> _tryFetchInitialLocation(
//     int sessionId,
//     String pilgrimId,
//     String pilgrimName,
//     var trackingRepo,
//   ) async {
//     try {
//       final initialPosition = await Geolocator.getCurrentPosition(
//         locationSettings: const LocationSettings(
//           accuracy: LocationAccuracy.high,
//           timeLimit: Duration(seconds: 10),
//         ),
//       );
//       final initialLatLng = LatLng(
//         initialPosition.latitude,
//         initialPosition.longitude,
//       );
//       await trackingRepo.updatePilgrimLocation(
//         sessionId: sessionId,
//         pilgrimId: pilgrimId,
//         pilgrimName: pilgrimName,
//         location: initialLatLng,
//       );
//       state = PilgrimTrackingState(
//         pilgrimLocation: initialLatLng,
//         leaderLocation: state.leaderLocation,
//         distance: state.distance,
//         gpsWarning: null, // إخفاء التحذير
//       );
//     } catch (_) {
//       // تجاهل الخطأ، الـ Stream سيلتقط الموقع لاحقاً
//     }
//   }

//   void _updateStateAndCheckDistance({
//     LatLng? pilgrimLoc,
//     LatLng? leaderLoc,
//     bool clearWarning = false,
//   }) {
//     if (pilgrimLoc == null || leaderLoc == null) {
//       state = PilgrimTrackingState(
//         pilgrimLocation: pilgrimLoc ?? state.pilgrimLocation,
//         leaderLocation: leaderLoc ?? state.leaderLocation,
//         distance: state.distance,
//         gpsWarning: clearWarning ? null : state.gpsWarning, // 👈
//       );
//       return;
//     }

//     final distance = Geolocator.distanceBetween(
//       pilgrimLoc.latitude,
//       pilgrimLoc.longitude,
//       leaderLoc.latitude,
//       leaderLoc.longitude,
//     );

//     state = PilgrimTrackingState(
//       pilgrimLocation: pilgrimLoc,
//       leaderLocation: leaderLoc,
//       distance: distance,
//       gpsWarning: clearWarning ? null : state.gpsWarning, // 👈
//     );
//     // 🟢 النطاق الأخضر
//     if (distance <= _yellowZone) {
//       _redZoneEntryTime = null;
//       _hasWarnedYellow = false; // تصفير التحذير ليعمل مجدداً لو تأخر لاحقاً
//       stopAlarmManual();
//     }
//     // 🟡 النطاق الأصفر (تحذير صامت)
//     else if (distance > _yellowZone && distance <= _redZone) {
//       _redZoneEntryTime = null; // تصفير عداد الخطر لأنه عاد للمنطقة الصفراء
//       stopAlarmManual(); // إيقاف الإنذار العالي إن كان يعمل

//       // إطلاق اهتزاز خفيف مرة واحدة فقط
//       if (!_hasWarnedYellow) {
//         _hasWarnedYellow = true;
//         _triggerWarningVibration();
//       }
//     }
//     // 🔴 النطاق الأحمر (خطر مؤكد)
//     else {
//       if (_redZoneEntryTime == null) {
//         // بدأ للتو في دخول النطاق الأحمر، نبدأ العد
//         _redZoneEntryTime = DateTime.now();
//       } else {
//         // نتحقق من عدد الثواني التي قضاها في الأحمر
//         final secondsInRedZone = DateTime.now()
//             .difference(_redZoneEntryTime!)
//             .inSeconds;

//         if (secondsInRedZone >= _alarmDelaySeconds) {
//           _triggerEmergency(); // إطلاق الإنذار الفعلي
//         }
//       }
//     }
//   }

//   // دالة منفصلة للاهتزاز التحذيري الصامت
//   Future<void> _triggerWarningVibration() async {
//     if (await Vibration.hasVibrator() ?? false) {
//       Vibration.vibrate(pattern: [0, 200, 100, 200]); // نبضتان خفيفتان
//     }
//   }

//   Future<void> _triggerEmergency() async {
//     if (_isAlarmActive) return;
//     _isAlarmActive = true;

//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//           'emergency_channel_pilgrim',
//           'تنبيه الابتعاد',
//           importance: Importance.max,
//           priority: Priority.high,
//         );
//     await _notificationsPlugin.show(
//       1,
//       '🚨 إنذار خطر!',
//       'لقد ابتعدت عن المشرف خارج النطاق المسموح!',
//       const NotificationDetails(android: androidDetails),
//     );

//     if (await Vibration.hasVibrator() ?? false) {
//       Vibration.vibrate(pattern: [500, 1000, 500, 1000]);
//     }
//     await _audioPlayer.setReleaseMode(ReleaseMode.loop);
//     await _audioPlayer.play(AssetSource('sounds/alarm.mp3'));
//   }

//   void stopAlarmManual() {
//     if (_isAlarmActive) {
//       _audioPlayer.stop();
//       Vibration.cancel();
//       _isAlarmActive = false;
//     }
//   }

//   Future<void> rejectSession({required int sessionId}) async {
//     state = PilgrimTrackingState(isLoading: true);
//     try {
//       final trackingApiRepo = ref.read(leaderTrackingApiRepositoryProvider);
//       await trackingApiRepo.respondToSession(sessionId, 3);
//       // 🔥 التعديل 2: التأكد من مسح الجلسة في حالة الرفض
//       final sharedPrefs = ref.read(sharedPreferencesServiceProvider);
//       await sharedPrefs.removeInt(SharedPreferencesKeys.sessionId);
//       state = PilgrimTrackingState(); // إعادة تعيين
//     } catch (e) {
//       state = PilgrimTrackingState(errorMessage: e.toString());
//     }
//   }

//   void stopTracking() {
//     _positionStreamSub?.cancel();
//     _leaderStreamSub?.cancel();
//     _serviceStatusSub?.cancel();
//     _positionStreamSub = null;
//     _leaderStreamSub = null;
//     stopAlarmManual();
//     _leaderTimeoutTimer?.cancel();

//     // 🔥 التعديل 3: مسح الجلسة عند إيقاف التتبع لإخفاء الزر من الواجهة الرئيسية
//     final sharedPrefs = ref.read(sharedPreferencesServiceProvider);
//     sharedPrefs.removeInt(SharedPreferencesKeys.sessionId);
//     state = PilgrimTrackingState();
//   }

//   Future<void> leaveAndStopTracking({
//     required int sessionId,
//     required String pilgrimId,
//   }) async {
//     try {
//       // 1. إرسال طلب للباك إند لتغيير حالة الحاج وإشعار المشرف
//       // افترضنا أن الحالة 3 تعني "تم إيقاف التتبع/إلغاء" بناءً على الكود السابق
//       final trackingApiRepo = ref.read(leaderTrackingApiRepositoryProvider);
//       await trackingApiRepo.respondToSession(sessionId, 4);

//       // 2. حذف الحاج من غرفة الفايربيس لكي يختفي من خريطة المشرف
//       final trackingRepo = ref.read(trackingRepositoryProvider);
//       await trackingRepo.removePilgrimFromSession(
//         sessionId: sessionId.toString(),
//         pilgrimId: pilgrimId,
//       );

//       // 3. إيقاف التتبع المحلي وتنظيف الذاكرة (هذه الدالة موجودة لديك مسبقاً)
//       stopTracking();
//     } catch (e) {
//       // يمكنك التعامل مع الخطأ هنا، مثلاً عرض رسالة للمستخدم
//       state = PilgrimTrackingState(errorMessage: e.toString());
//     }
//   }
// }

// تأكد من بقاء استيرادات مشروعك هنا
// part 'pilgrim_tracking_controller.g.dart';
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@Riverpod(keepAlive: true)
class PilgrimTrackingController extends _$PilgrimTrackingController {
  StreamSubscription<Position>? _positionStreamSub;
  StreamSubscription<DatabaseEvent>? _leaderStreamSub;
  Timer? _leaderTimeoutTimer;
  DateTime? _redZoneEntryTime;
  bool _hasWarnedYellow = false;
  final int _alarmDelaySeconds = 10;
  StreamSubscription<ServiceStatus>? _serviceStatusSub;
  StreamSubscription<StepCount>? _stepCountSub;
  int _currentTotalSteps = 0;
  bool _isSafeByBle = false;
  StreamSubscription<DatabaseEvent>? _myFirebaseDataSub;

  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final double _yellowZone = 20;
  final double _redZone = 30;

  bool _isAlarmActive = false;
  Position? _lastValidPosition;
  DateTime? _lastUpdateTime;

  // 🌟 التعديل: استخدام FlutterBlePeripheral
  // final FlutterBlePeripheral _blePeripheral = FlutterBlePeripheral();

  StreamSubscription<AccelerometerEvent>? _accelSub;
  DateTime _lastStepTime = DateTime.now();
  int _consecutiveSteps = 0;
  double _lastAcc = 0.0;

  int _trustedTotalSteps = 0;
  int _stepsAtLastGpsUpdate = 0;

  @override
  PilgrimTrackingState build() {
    ref.onDispose(() {
      stopTracking();
    });
    return PilgrimTrackingState();
  }

  // 🌟 استخدام مكتبة بث iBeacon
  final BeaconBroadcast _beaconBroadcast = BeaconBroadcast();

  Future<void> _startBleBroadcasting(String pilgrimId) async {
    try {
      // تحويل جزء من ID الحاج إلى رقم ليتم إرساله عبر البلوتوث (حد أقصى 65535)
      int numericId = pilgrimId.hashCode % 65535;

      // 🌟 بدء بث إشارة iBeacon القياسية (تعمل على آيفون وأندرويد بكفاءة)
      _beaconBroadcast
          .setUUID('39ED98FF-2900-441A-802F-9C398FC199D2')
          .setMajorId(1)
          .setMinorId(numericId)
          .start();

      debugPrint(
        "📡 [بلوتوث الحاج] بدأ البث بنجاح كـ iBeacon! رقم الحاج التعريفي: $numericId",
      );
    } catch (e) {
      debugPrint("❌ [بلوتوث الحاج] فشل في بدء البث: $e");
    }
  }

  void _startSmartStepCounting() {
    _accelSub = accelerometerEventStream().listen(
      (AccelerometerEvent event) {
        double acc = math.sqrt(
          event.x * event.x + event.y * event.y + event.z * event.z,
        );

        if (_lastAcc > 2.5 && acc < _lastAcc) {
          final now = DateTime.now();
          int msDiff = now.difference(_lastStepTime).inMilliseconds;

          if (msDiff > 350 && msDiff < 1200) {
            _consecutiveSteps++;
            _lastStepTime = now;

            if (_consecutiveSteps >= 3) {
              int stepIncrement = (_consecutiveSteps == 3) ? 3 : 1;
              _trustedTotalSteps += stepIncrement;
              debugPrint("👣 خطوة موثوقة! الإجمالي: $_trustedTotalSteps");
            }
          } else if (msDiff > 1200) {
            _consecutiveSteps = 0;
          }
        }
        _lastAcc = acc;
      },
      onError: (error) {
        debugPrint("❌ خطأ في مستشعر الحركة: $error");
      },
    );
  }

  bool _isMovementReal(double distanceMeters) {
    if (distanceMeters < 5) return true;

    int stepsTaken = _trustedTotalSteps - _stepsAtLastGpsUpdate;
    double expectedMinSteps = distanceMeters / 1.5;

    debugPrint(
      "🔍 فحص حماية الموقع: المسافة $distanceMeters م | الخطوات الموثوقة: $stepsTaken | المتوقع: $expectedMinSteps",
    );

    if (stepsTaken < expectedMinSteps && distanceMeters > 15) {
      return false;
    }

    _stepsAtLastGpsUpdate = _trustedTotalSteps;
    return true;
  }

  void _resetLeaderTimeoutTimer() {
    _leaderTimeoutTimer?.cancel();
    _leaderTimeoutTimer = Timer(const Duration(minutes: 30), () {
      _handleLeaderDisappearance();
    });
  }

  void _handleLeaderDisappearance() {
    stopTracking();
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

      final trackingRepo = ref.read(trackingRepositoryProvider);
      final sharedPrefs = ref.read(sharedPreferencesServiceProvider);
      await sharedPrefs.setInt(SharedPreferencesKeys.sessionId, sessionId);
      final locationService = ref.read(locationServiceProvider);

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = PilgrimTrackingState(
          pilgrimLocation: null,
          leaderLocation: state.leaderLocation,
          gpsWarning: "يرجى تفعيل خدمة الـ GPS (الموقع) في هاتفك.",
        );
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          state = PilgrimTrackingState(
            pilgrimLocation: null,
            leaderLocation: state.leaderLocation,
            gpsWarning: "صلاحية الموقع مرفوضة. يرجى تفعيلها من إعدادات الهاتف.",
          );
          return;
        }
      }

      // 🌟 طلب صلاحيات البلوتوث للأجهزة الحديثة (أندرويد 12+) قبل بدء البث
      await [
        Permission.bluetooth,
        Permission.bluetoothAdvertise,
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
      ].request();

      _startSmartStepCounting();
      await _startBleBroadcasting(pilgrimId);

      Future<void> tryFetchLocationNow() async {
        try {
          Position initialPosition = await Geolocator.getCurrentPosition(
            locationSettings: locationService.optimalLocationSettings,
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

          _updateStateAndCheckDistance(
            pilgrimLoc: initialLatLng,
            leaderLoc: state.leaderLocation,
            clearWarning: true,
          );
        } catch (e) {
          debugPrint("فشل في جلب الموقع الأولي: $e");
        }
      }

      _serviceStatusSub?.cancel();
      _serviceStatusSub = Geolocator.getServiceStatusStream().listen((
        ServiceStatus status,
      ) {
        if (status == ServiceStatus.disabled) {
          state = PilgrimTrackingState(
            pilgrimLocation: null,
            leaderLocation: state.leaderLocation,
            distance: state.distance,
            gpsWarning: "تم إغلاق خدمة الموقع (GPS) في الهاتف. يرجى تفعيلها.",
          );
        } else if (status == ServiceStatus.enabled) {
          state = PilgrimTrackingState(
            pilgrimLocation: state.pilgrimLocation,
            leaderLocation: state.leaderLocation,
            distance: state.distance,
            gpsWarning: "تم تفعيل الـ GPS، جاري التقاط الإشارة...",
          );
          tryFetchLocationNow();
        }
      });

      if (serviceEnabled) {
        await tryFetchLocationNow();
      }

      await _positionStreamSub?.cancel();
      _positionStreamSub = locationService.foregroundPositionStream.listen(
        (Position position) {
          debugPrint(
            "📍 [الحاج] تم التقاط موقع جديد | الدقة: ${position.accuracy.toStringAsFixed(2)} متر",
          );

          if (position.accuracy > 25) {
            debugPrint(
              "⚠️ [الحاج] ❌ تم تجاهل موقع غير دقيق (الدقة: ${position.accuracy} متر)",
            );
            return;
          }

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

            if (timeDiffSeconds > 0) {
              final speedMetersPerSecond = distanceJump / timeDiffSeconds;
              debugPrint(
                "🏃 [الحاج] المسافة: ${distanceJump.toStringAsFixed(2)}م | الزمن: ${timeDiffSeconds}ث | السرعة: ${speedMetersPerSecond.toStringAsFixed(2)} م/ث",
              );

              if (speedMetersPerSecond > 4.0) {
                debugPrint(
                  "⚠️ [الحاج] ❌ تم تجاهل قفزة GPS وهمية (السرعة: $speedMetersPerSecond م/ث).",
                );
                return;
              }
            }
          }

          if (_lastValidPosition != null) {
            double distance = Geolocator.distanceBetween(
              _lastValidPosition!.latitude,
              _lastValidPosition!.longitude,
              position.latitude,
              position.longitude,
            );

            if (!_isMovementReal(distance)) {
              debugPrint(
                "🛑 [حماية] تم اكتشاف قفزة GPS وهمية: الحاج لم يمشِ خطوات كافية لهذه المسافة!",
              );
              return;
            }
          }

          debugPrint("✅ [الحاج] الموقع سليم، جاري التحديث في فايربيس...");
          _lastValidPosition = position;
          _lastUpdateTime = DateTime.now();
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
            clearWarning: true,
          );
        },
        onError: (error) {
          debugPrint("❌ [الحاج] خطأ في مستمع الموقع: $error");
        },
      );
      await _leaderStreamSub?.cancel();
      _leaderStreamSub = trackingRepo.leaderStream(sessionId.toString()).listen(
        (DatabaseEvent event) {
          if (event.snapshot.exists) {
            final data = event.snapshot.value as Map<dynamic, dynamic>;
            final lat = data['latitude'];
            final lng = data['longitude'];

            if (lat != null && lng != null) {
              final leaderPos = LatLng(lat, lng);
              _resetLeaderTimeoutTimer();
              _updateStateAndCheckDistance(
                pilgrimLoc: state.pilgrimLocation,
                leaderLoc: leaderPos,
              );
            }
          }
        },
      );

      await _myFirebaseDataSub?.cancel();
      _myFirebaseDataSub = trackingRepo
          .pilgrimStream(sessionId.toString(), pilgrimId)
          .listen((DatabaseEvent event) {
            if (event.snapshot.exists) {
              final data = event.snapshot.value as Map<dynamic, dynamic>;
              bool isSafe = data['isSafeByBle'] ?? false;

              if (_isSafeByBle != isSafe) {
                _isSafeByBle = isSafe;
                if (_isSafeByBle) {
                  _updateStateAndCheckDistance(
                    pilgrimLoc: state.pilgrimLocation,
                    leaderLoc: state.leaderLocation,
                  );
                }
              }
            }
          });
    } catch (e) {
      state = PilgrimTrackingState(errorMessage: e.toString());
      final sharedPrefs = ref.read(sharedPreferencesServiceProvider);
      await sharedPrefs.removeInt(SharedPreferencesKeys.sessionId);
    }
  }

  void _updateStateAndCheckDistance({
    LatLng? pilgrimLoc,
    LatLng? leaderLoc,
    bool clearWarning = false,
  }) {
    if (pilgrimLoc == null || leaderLoc == null) {
      state = PilgrimTrackingState(
        pilgrimLocation: pilgrimLoc ?? state.pilgrimLocation,
        leaderLocation: leaderLoc ?? state.leaderLocation,
        distance: state.distance,
        gpsWarning: clearWarning ? null : state.gpsWarning,
      );
      return;
    }

    final distance = Geolocator.distanceBetween(
      pilgrimLoc.latitude,
      pilgrimLoc.longitude,
      leaderLoc.latitude,
      leaderLoc.longitude,
    );

    if (_isSafeByBle) {
      debugPrint(
        "🛡️ [الحاج] الـ GPS يقول المسافة $distance م، لكن المشرف أكد قربي بالبلوتوث. إلغاء الإنذار!",
      );

      _redZoneEntryTime = null;
      _hasWarnedYellow = false;
      stopAlarmManual();

      state = PilgrimTrackingState(
        pilgrimLocation: pilgrimLoc,
        leaderLocation: leaderLoc,
        distance: distance,
        gpsWarning: clearWarning ? null : state.gpsWarning,
      );
      return;
    }

    debugPrint(
      "📏 [الحاج] المسافة الحالية بيني وبين المشرف: ${distance.toStringAsFixed(2)} متر",
    );

    state = PilgrimTrackingState(
      pilgrimLocation: pilgrimLoc,
      leaderLocation: leaderLoc,
      distance: distance,
      gpsWarning: clearWarning ? null : state.gpsWarning,
    );

    if (distance <= _yellowZone) {
      if (_redZoneEntryTime != null || _hasWarnedYellow) {
        debugPrint("🟢 [الحاج] عدت إلى النطاق الآمن!");
      }
      _redZoneEntryTime = null;
      _hasWarnedYellow = false;
      stopAlarmManual();
    } else if (distance > _yellowZone && distance <= _redZone) {
      debugPrint("🟡 [الحاج] أنا في النطاق الأصفر (تحذير صامت)");
      _redZoneEntryTime = null;
      stopAlarmManual();
      if (!_hasWarnedYellow) {
        _hasWarnedYellow = true;
        _triggerWarningVibration();
      }
    } else {
      debugPrint("🔴 [الحاج] أنا في النطاق الأحمر!");
      if (_redZoneEntryTime == null) {
        _redZoneEntryTime = DateTime.now();
        debugPrint("⏱️ [الحاج] بدأ عداد الخطر (10 ثواني للإنذار).");
      } else {
        final secondsInRedZone = DateTime.now()
            .difference(_redZoneEntryTime!)
            .inSeconds;
        debugPrint(
          "⏱️ [الحاج] استمرار في الأحمر منذ: $secondsInRedZone ثانية.",
        );
        if (secondsInRedZone >= _alarmDelaySeconds) {
          debugPrint("🚨 [الحاج] إطلاق الإنذار النهائي!");
          _triggerEmergency();
        }
      }
    }
  }

  Future<void> _triggerWarningVibration() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(pattern: [0, 200, 100, 200]);
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
    _positionStreamSub = null;
    _leaderStreamSub = null;
    stopAlarmManual();
    _leaderTimeoutTimer?.cancel();

    final sharedPrefs = ref.read(sharedPreferencesServiceProvider);
    sharedPrefs.removeInt(SharedPreferencesKeys.sessionId);
    state = PilgrimTrackingState();
    _lastValidPosition = null;
    _lastUpdateTime = null;
    _stepCountSub?.cancel();

    // 🌟 إيقاف البث
    _beaconBroadcast.stop();

    _accelSub?.cancel();
    _accelSub = null;
    _myFirebaseDataSub?.cancel();
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

// class PilgrimTrackingController extends _$PilgrimTrackingController {
//   StreamSubscription<Position>? _positionStreamSub;
//   StreamSubscription<DatabaseEvent>? _leaderStreamSub;
//   Timer? _leaderTimeoutTimer;
//   DateTime? _redZoneEntryTime; // لتتبع متى دخل الحاج النطاق الأحمر
//   bool _hasWarnedYellow = false; // لمنع تكرار اهتزاز التحذير الأصفر
//   final int _alarmDelaySeconds = 10; // 10 ثواني سماحية قبل إطلاق الإنذار
//   StreamSubscription<ServiceStatus>? _serviceStatusSub;
//   StreamSubscription<StepCount>? _stepCountSub;
//   // int _stepsAtLastGpsUpdate = 0;
//   int _currentTotalSteps = 0;
//   bool _isSafeByBle = false; // يحدد ما إذا كان المشرف قد أرسل صك الأمان
//   StreamSubscription<DatabaseEvent>?
//   _myFirebaseDataSub; // مستمع لبيانات الحاج في فايربيس

//   final AudioPlayer _audioPlayer = AudioPlayer();
//   final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   // 🌟 التعديل 1: توسيع النطاقات لتقليل الإنذارات الكاذبة في الشارع
//   final double _yellowZone = 25; // التحذير يبدأ بعد 35 متر
//   final double _redZone = 50; // الخطر المؤكد بعد 60 متر

//   bool _isAlarmActive = false; // لمنع تكرار تشغيل الصوت
//   Position? _lastValidPosition; // لحفظ آخر موقع سليم
//   DateTime? _lastUpdateTime; // لحفظ وقت آخر موقع سليم
//   final BeaconBroadcast _beaconBroadcast = BeaconBroadcast();
//   // استبدل متغيرات الـ Pedometer القديمة بهذه:
//   StreamSubscription<AccelerometerEvent>? _accelSub;
//   DateTime _lastStepTime = DateTime.now();
//   int _consecutiveSteps = 0;
//   double _lastAcc = 0.0;

//   // هذا المتغير سيحمل عدد الخطوات "الحقيقية والموثوقة"
//   int _trustedTotalSteps = 0;
//   int _stepsAtLastGpsUpdate = 0;
//   @override
//   PilgrimTrackingState build() {
//     ref.onDispose(() {
//       stopTracking();
//     });
//     return PilgrimTrackingState();
//   }

//   Future<void> _startBleBroadcasting(String pilgrimId) async {
//     try {
//       // يجب أن يكون الـ UUID ثابتاً لتطبيقك لكي يتعرف عليه المشرف
//       // سنستخدم UUID ثابت، ونضع ID الحاج في الـ Major أو Minor (أرقام تعريفية للبلوتوث)
//       const String appUuid =
//           '39ED98FF-2900-441A-802F-9C398FC199D2'; // رمز خاص بتطبيقك

//       // تحويل جزء من ID الحاج إلى رقم ليتم إرساله عبر البلوتوث
//       int numericId =
//           pilgrimId.hashCode % 65535; // لضمان ألا يتجاوز الحد المسموح

//       _beaconBroadcast
//           .setUUID(appUuid)
//           .setMajorId(1) // يمكن أن يمثل رقم الحملة
//           .setMinorId(numericId) // يمثل رقم الحاج
//           .setTransmissionPower(-59) // قوة البث القياسية
//           .setLayout(
//             'm:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24',
//           ) // معيار iBeacon
//           .start();

//       debugPrint(
//         "📡 [بلوتوث الحاج] بدأ البث بنجاح! رقم الحاج التعريفي: $numericId",
//       );
//     } catch (e) {
//       debugPrint("❌ [بلوتوث الحاج] فشل في بدء البث: $e");
//     }
//   }

//   void _startSmartStepCounting() {
//     _accelSub = accelerometerEventStream().listen(
//       (AccelerometerEvent event) {
//         // 1. حساب قوة التسارع 3D (Magnitude)
//         double acc = math.sqrt(
//           event.x * event.x + event.y * event.y + event.z * event.z,
//         );

//         // 2. اكتشاف القمة (نزول التسارع بعد ضربة القدم)
//         if (_lastAcc > 2.5 && acc < _lastAcc) {
//           final now = DateTime.now();
//           int msDiff = now.difference(_lastStepTime).inMilliseconds;

//           // 3. فلتر الزمن (بين 350 و 1200 جزء من الثانية للخطوة البشرية)
//           if (msDiff > 350 && msDiff < 1200) {
//             _consecutiveSteps++;
//             _lastStepTime = now;

//             // 4. فلتر التأكيد (نبدأ الحساب الفعلي بعد 3 خطوات متتالية)
//             if (_consecutiveSteps >= 3) {
//               // إذا كانت هذه الخطوة الثالثة، نعوضه عن أول خطوتين لم نحسبهما، وإلا نضيف 1
//               int stepIncrement = (_consecutiveSteps == 3) ? 3 : 1;
//               _trustedTotalSteps += stepIncrement;

//               // سطر مؤقت للتأكد من عملها أثناء التجربة
//               debugPrint("👣 خطوة موثوقة! الإجمالي: $_trustedTotalSteps");
//             }
//           }
//           // إذا كان الفارق الزمني كبير جداً (الشخص وقف)
//           else if (msDiff > 1200) {
//             _consecutiveSteps = 0;
//           }
//         }
//         _lastAcc = acc;
//       },
//       onError: (error) {
//         debugPrint("❌ خطأ في مستشعر الحركة: $error");
//       },
//     );
//   }

//   bool _isMovementReal(double distanceMeters) {
//     if (distanceMeters < 5) return true;

//     // استخدام الخطوات الموثوقة بدلاً من الخطوات الكلية
//     int stepsTaken = _trustedTotalSteps - _stepsAtLastGpsUpdate;
//     double expectedMinSteps =
//         distanceMeters / 1.5; // كل خطوة تقريباً متر ونصف (كمتوسط جري/مشي سريع)

//     debugPrint(
//       "🔍 فحص حماية الموقع: المسافة $distanceMeters م | الخطوات الموثوقة: $stepsTaken | المتوقع: $expectedMinSteps",
//     );

//     if (stepsTaken < expectedMinSteps && distanceMeters > 15) {
//       return false; // اكتشاف تلاعب في الـ GPS أو قفزة وهمية
//     }

//     _stepsAtLastGpsUpdate = _trustedTotalSteps;
//     return true;
//   }

//   void _resetLeaderTimeoutTimer() {
//     _leaderTimeoutTimer?.cancel();
//     _leaderTimeoutTimer = Timer(const Duration(minutes: 30), () {
//       _handleLeaderDisappearance();
//     });
//   }

//   void _handleLeaderDisappearance() {
//     stopTracking();
//     state = PilgrimTrackingState(
//       errorMessage: 'تم إيقاف التتبع لأن المشرف فقد الاتصال لأكثر من 30 دقيقة.',
//     );
//   }

//   Future<void> acceptAndStartTracking({
//     required int sessionId,
//     required String pilgrimId,
//     required String pilgrimName,
//   }) async {
//     state = PilgrimTrackingState(isLoading: true);

//     try {
//       final trackingApiRepo = ref.read(leaderTrackingApiRepositoryProvider);
//       await trackingApiRepo.respondToSession(sessionId, 2);

//       final trackingRepo = ref.read(trackingRepositoryProvider);
//       final sharedPrefs = ref.read(sharedPreferencesServiceProvider);
//       await sharedPrefs.setInt(SharedPreferencesKeys.sessionId, sessionId);
//       final locationService = ref.read(locationServiceProvider);

//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         state = PilgrimTrackingState(
//           pilgrimLocation: null,
//           leaderLocation: state.leaderLocation,
//           gpsWarning: "يرجى تفعيل خدمة الـ GPS (الموقع) في هاتفك.",
//         );
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied ||
//             permission == LocationPermission.deniedForever) {
//           state = PilgrimTrackingState(
//             pilgrimLocation: null,
//             leaderLocation: state.leaderLocation,
//             gpsWarning: "صلاحية الموقع مرفوضة. يرجى تفعيلها من إعدادات الهاتف.",
//           );
//           return;
//         }
//       }
//       // داخل acceptAndStartTracking بعد التأكد من الصلاحيات:
//       _startSmartStepCounting();
//       await _startBleBroadcasting(pilgrimId); // <--- أضف هذا السطر هنا
//       Future<void> tryFetchLocationNow() async {
//         try {
//           // 🌟 التعديل 2: استخدام الإعدادات المثالية لجلب الموقع الفوري
//           Position initialPosition = await Geolocator.getCurrentPosition(
//             locationSettings: locationService.optimalLocationSettings,
//           );

//           final initialLatLng = LatLng(
//             initialPosition.latitude,
//             initialPosition.longitude,
//           );

//           await trackingRepo.updatePilgrimLocation(
//             sessionId: sessionId,
//             pilgrimId: pilgrimId,
//             pilgrimName: pilgrimName,
//             location: initialLatLng,
//           );

//           _updateStateAndCheckDistance(
//             pilgrimLoc: initialLatLng,
//             leaderLoc: state.leaderLocation,
//             clearWarning: true,
//           );
//         } catch (e) {
//           debugPrint("فشل في جلب الموقع الأولي: $e");
//         }
//       }

//       _serviceStatusSub?.cancel();
//       _serviceStatusSub = Geolocator.getServiceStatusStream().listen((
//         ServiceStatus status,
//       ) {
//         if (status == ServiceStatus.disabled) {
//           state = PilgrimTrackingState(
//             pilgrimLocation: null,
//             leaderLocation: state.leaderLocation,
//             distance: state.distance,
//             gpsWarning: "تم إغلاق خدمة الموقع (GPS) في الهاتف. يرجى تفعيلها.",
//           );
//         } else if (status == ServiceStatus.enabled) {
//           state = PilgrimTrackingState(
//             pilgrimLocation: state.pilgrimLocation,
//             leaderLocation: state.leaderLocation,
//             distance: state.distance,
//             gpsWarning: "تم تفعيل الـ GPS، جاري التقاط الإشارة...",
//           );
//           tryFetchLocationNow();
//         }
//       });

//       if (serviceEnabled) {
//         await tryFetchLocationNow();
//       }

//       // داخل دالة acceptAndStartTracking
//       await _positionStreamSub?.cancel();
//       _positionStreamSub = locationService.foregroundPositionStream.listen(
//         (Position position) {
//           debugPrint(
//             "📍 [الحاج] تم التقاط موقع جديد | الدقة: ${position.accuracy.toStringAsFixed(2)} متر",
//           );

//           // 🛑 1. فلتر الدقة:
//           if (position.accuracy > 25) {
//             debugPrint(
//               "⚠️ [الحاج] ❌ تم تجاهل موقع غير دقيق (الدقة: ${position.accuracy} متر)",
//             );
//             return;
//           }

//           // 🛑 2. فلتر القفزات الوهمية:
//           if (_lastValidPosition != null && _lastUpdateTime != null) {
//             final distanceJump = Geolocator.distanceBetween(
//               _lastValidPosition!.latitude,
//               _lastValidPosition!.longitude,
//               position.latitude,
//               position.longitude,
//             );
//             final timeDiffSeconds = DateTime.now()
//                 .difference(_lastUpdateTime!)
//                 .inSeconds;

//             if (timeDiffSeconds > 0) {
//               final speedMetersPerSecond = distanceJump / timeDiffSeconds;
//               debugPrint(
//                 "🏃 [الحاج] المسافة: ${distanceJump.toStringAsFixed(2)}م | الزمن: ${timeDiffSeconds}ث | السرعة: ${speedMetersPerSecond.toStringAsFixed(2)} م/ث",
//               );

//               if (speedMetersPerSecond > 4.0) {
//                 debugPrint(
//                   "⚠️ [الحاج] ❌ تم تجاهل قفزة GPS وهمية (السرعة: $speedMetersPerSecond م/ث).",
//                 );
//                 return;
//               }
//             }
//           }

//           // 3. الفلتر الجديد: دمج الخطوات (Sensor Fusion)
//           if (_lastValidPosition != null) {
//             double distance = Geolocator.distanceBetween(
//               _lastValidPosition!.latitude,
//               _lastValidPosition!.longitude,
//               position.latitude,
//               position.longitude,
//             );

//             if (!_isMovementReal(distance)) {
//               debugPrint(
//                 "🛑 [حماية] تم اكتشاف قفزة GPS وهمية: الحاج لم يمشِ خطوات كافية لهذه المسافة!",
//               );
//               return; // تجاهل الموقع كلياً
//             }
//           }

//           // إذا نجح في كل الفلاتر، نعتمد الموقع
//           debugPrint("✅ [الحاج] الموقع سليم، جاري التحديث في فايربيس...");
//           _lastValidPosition = position;
//           _lastUpdateTime = DateTime.now();
//           final currentPos = LatLng(position.latitude, position.longitude);

//           trackingRepo.updatePilgrimLocation(
//             sessionId: sessionId,
//             pilgrimId: pilgrimId,
//             pilgrimName: pilgrimName,
//             location: currentPos,
//           );
//           _updateStateAndCheckDistance(
//             pilgrimLoc: currentPos,
//             leaderLoc: state.leaderLocation,
//             clearWarning: true,
//           );
//         },
//         onError: (error) {
//           debugPrint("❌ [الحاج] خطأ في مستمع الموقع: $error");
//         },
//       );
//       await _leaderStreamSub?.cancel();
//       _leaderStreamSub = trackingRepo.leaderStream(sessionId.toString()).listen(
//         (DatabaseEvent event) {
//           if (event.snapshot.exists) {
//             final data = event.snapshot.value as Map<dynamic, dynamic>;
//             final lat = data['latitude'];
//             final lng = data['longitude'];

//             if (lat != null && lng != null) {
//               final leaderPos = LatLng(lat, lng);
//               _resetLeaderTimeoutTimer();
//               _updateStateAndCheckDistance(
//                 pilgrimLoc: state.pilgrimLocation,
//                 leaderLoc: leaderPos,
//               );
//             }
//           }
//         },
//       );
//       // 🌟 مستمع جديد لقراءة "صك الأمان" الخاص بي من فايربيس
//       await _myFirebaseDataSub?.cancel();
//       _myFirebaseDataSub = trackingRepo
//           .pilgrimStream(sessionId.toString(), pilgrimId)
//           .listen((DatabaseEvent event) {
//             if (event.snapshot.exists) {
//               final data = event.snapshot.value as Map<dynamic, dynamic>;
//               bool isSafe = data['isSafeByBle'] ?? false;

//               if (_isSafeByBle != isSafe) {
//                 _isSafeByBle = isSafe;
//                 // إذا تغيرت الحالة (أصبح آمناً فجأة)، نقوم بتحديث المسافة لإلغاء أي إنذار شغال
//                 if (_isSafeByBle) {
//                   _updateStateAndCheckDistance(
//                     pilgrimLoc: state.pilgrimLocation,
//                     leaderLoc: state.leaderLocation,
//                   );
//                 }
//               }
//             }
//           });
//     } catch (e) {
//       state = PilgrimTrackingState(errorMessage: e.toString());
//       final sharedPrefs = ref.read(sharedPreferencesServiceProvider);
//       await sharedPrefs.removeInt(SharedPreferencesKeys.sessionId);
//     }
//   }

//   void _updateStateAndCheckDistance({
//     LatLng? pilgrimLoc,
//     LatLng? leaderLoc,
//     bool clearWarning = false,
//   }) {
//     if (pilgrimLoc == null || leaderLoc == null) {
//       state = PilgrimTrackingState(
//         pilgrimLocation: pilgrimLoc ?? state.pilgrimLocation,
//         leaderLocation: leaderLoc ?? state.leaderLocation,
//         distance: state.distance,
//         gpsWarning: clearWarning ? null : state.gpsWarning,
//       );
//       return;
//     }

//     final distance = Geolocator.distanceBetween(
//       pilgrimLoc.latitude,
//       pilgrimLoc.longitude,
//       leaderLoc.latitude,
//       leaderLoc.longitude,
//     );

//     // 🌟 التعديل الجديد: التحقق من صك الأمان قبل أي شيء 🌟
//     if (_isSafeByBle) {
//       debugPrint(
//         "🛡️ [الحاج] الـ GPS يقول المسافة $distance م، لكن المشرف أكد قربي بالبلوتوث. إلغاء الإنذار!",
//       );

//       _redZoneEntryTime = null;
//       _hasWarnedYellow = false;
//       stopAlarmManual();

//       state = PilgrimTrackingState(
//         pilgrimLocation: pilgrimLoc,
//         leaderLocation: leaderLoc,
//         distance: distance, // نعرض المسافة ولكن لا نطلق إنذار
//         gpsWarning: clearWarning ? null : state.gpsWarning,
//       );
//       return; // 🌟 نخرج من الدالة لكي لا يكمل قراءة النطاقات الحمراء والصفراء
//     }
//     // 🌟 انتهى التعديل الجديد 🌟

//     debugPrint(
//       "📏 [الحاج] المسافة الحالية بيني وبين المشرف: ${distance.toStringAsFixed(2)} متر",
//     );

//     state = PilgrimTrackingState(
//       pilgrimLocation: pilgrimLoc,
//       leaderLocation: leaderLoc,
//       distance: distance,
//       gpsWarning: clearWarning ? null : state.gpsWarning,
//     );

//     if (distance <= _yellowZone) {
//       if (_redZoneEntryTime != null || _hasWarnedYellow) {
//         debugPrint("🟢 [الحاج] عدت إلى النطاق الآمن!");
//       }
//       _redZoneEntryTime = null;
//       _hasWarnedYellow = false;
//       stopAlarmManual();
//     } else if (distance > _yellowZone && distance <= _redZone) {
//       debugPrint("🟡 [الحاج] أنا في النطاق الأصفر (تحذير صامت)");
//       _redZoneEntryTime = null;
//       stopAlarmManual();
//       if (!_hasWarnedYellow) {
//         _hasWarnedYellow = true;
//         _triggerWarningVibration();
//       }
//     } else {
//       debugPrint("🔴 [الحاج] أنا في النطاق الأحمر!");
//       if (_redZoneEntryTime == null) {
//         _redZoneEntryTime = DateTime.now();
//         debugPrint("⏱️ [الحاج] بدأ عداد الخطر (10 ثواني للإنذار).");
//       } else {
//         final secondsInRedZone = DateTime.now()
//             .difference(_redZoneEntryTime!)
//             .inSeconds;
//         debugPrint(
//           "⏱️ [الحاج] استمرار في الأحمر منذ: $secondsInRedZone ثانية.",
//         );
//         if (secondsInRedZone >= _alarmDelaySeconds) {
//           debugPrint("🚨 [الحاج] إطلاق الإنذار النهائي!");
//           _triggerEmergency();
//         }
//       }
//     }
//   }
//   Future<void> _triggerWarningVibration() async {
//     if (await Vibration.hasVibrator() ?? false) {
//       Vibration.vibrate(pattern: [0, 200, 100, 200]);
//     }
//   }

//   Future<void> _triggerEmergency() async {
//     if (_isAlarmActive) return;
//     _isAlarmActive = true;

//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//           'emergency_channel_pilgrim',
//           'تنبيه الابتعاد',
//           importance: Importance.max,
//           priority: Priority.high,
//         );
//     await _notificationsPlugin.show(
//       1,
//       '🚨 إنذار خطر!',
//       'لقد ابتعدت عن المشرف خارج النطاق المسموح!',
//       const NotificationDetails(android: androidDetails),
//     );

//     if (await Vibration.hasVibrator() ?? false) {
//       Vibration.vibrate(pattern: [500, 1000, 500, 1000]);
//     }
//     await _audioPlayer.setReleaseMode(ReleaseMode.loop);
//     await _audioPlayer.play(AssetSource('sounds/alarm.mp3'));
//   }

//   void stopAlarmManual() {
//     if (_isAlarmActive) {
//       _audioPlayer.stop();
//       Vibration.cancel();
//       _isAlarmActive = false;
//     }
//   }

//   Future<void> rejectSession({required int sessionId}) async {
//     state = PilgrimTrackingState(isLoading: true);
//     try {
//       final trackingApiRepo = ref.read(leaderTrackingApiRepositoryProvider);
//       await trackingApiRepo.respondToSession(sessionId, 3);
//       final sharedPrefs = ref.read(sharedPreferencesServiceProvider);
//       await sharedPrefs.removeInt(SharedPreferencesKeys.sessionId);
//       state = PilgrimTrackingState();
//     } catch (e) {
//       state = PilgrimTrackingState(errorMessage: e.toString());
//     }
//   }

//   void stopTracking() {
//     _positionStreamSub?.cancel();
//     _leaderStreamSub?.cancel();
//     _serviceStatusSub?.cancel();
//     _positionStreamSub = null;
//     _leaderStreamSub = null;
//     stopAlarmManual();
//     _leaderTimeoutTimer?.cancel();

//     final sharedPrefs = ref.read(sharedPreferencesServiceProvider);
//     sharedPrefs.removeInt(SharedPreferencesKeys.sessionId);
//     state = PilgrimTrackingState();
//     _lastValidPosition = null; // أضف هذا
//     _lastUpdateTime = null; // أضف هذا
//     _stepCountSub?.cancel();
//     _beaconBroadcast.stop();
//     _accelSub?.cancel();
//     _accelSub = null;
//     _myFirebaseDataSub?.cancel();
//   }

//   Future<void> leaveAndStopTracking({
//     required int sessionId,
//     required String pilgrimId,
//   }) async {
//     try {
//       final trackingApiRepo = ref.read(leaderTrackingApiRepositoryProvider);
//       await trackingApiRepo.respondToSession(sessionId, 4);

//       final trackingRepo = ref.read(trackingRepositoryProvider);
//       await trackingRepo.removePilgrimFromSession(
//         sessionId: sessionId.toString(),
//         pilgrimId: pilgrimId,
//       );

//       stopTracking();
//     } catch (e) {
//       state = PilgrimTrackingState(errorMessage: e.toString());
//     }
//   }
// }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // void _updateStateAndCheckDistance({
  //   LatLng? pilgrimLoc,
  //   LatLng? leaderLoc,
  //   bool clearWarning = false,
  // }) {
  //   if (pilgrimLoc == null || leaderLoc == null) {
  //     state = PilgrimTrackingState(
  //       pilgrimLocation: pilgrimLoc ?? state.pilgrimLocation,
  //       leaderLocation: leaderLoc ?? state.leaderLocation,
  //       distance: state.distance,
  //       gpsWarning: clearWarning ? null : state.gpsWarning,
  //     );
  //     return;
  //   }
  //   final distance = Geolocator.distanceBetween(
  //     pilgrimLoc.latitude,
  //     pilgrimLoc.longitude,
  //     leaderLoc.latitude,
  //     leaderLoc.longitude,
  //   );
  //   state = PilgrimTrackingState(
  //     pilgrimLocation: pilgrimLoc,
  //     leaderLocation: leaderLoc,
  //     distance: distance,
  //     gpsWarning: clearWarning ? null : state.gpsWarning,
  //   );
  //   if (distance <= _yellowZone) {
  //     _redZoneEntryTime = null;
  //     _hasWarnedYellow = false;
  //     stopAlarmManual();
  //   } else if (distance > _yellowZone && distance <= _redZone) {
  //     _redZoneEntryTime = null;
  //     stopAlarmManual();
  //     if (!_hasWarnedYellow) {
  //       _hasWarnedYellow = true;
  //       _triggerWarningVibration();
  //     }
  //   } else {
  //     if (_redZoneEntryTime == null) {
  //       _redZoneEntryTime = DateTime.now();
  //     } else {
  //       final secondsInRedZone = DateTime.now()
  //           .difference(_redZoneEntryTime!)
  //           .inSeconds;
  //       if (secondsInRedZone >= _alarmDelaySeconds) {
  //         _triggerEmergency();
  //       }
  //     }
  //   }
  // }

  // Future<void> _tryFetchInitialLocation(
  //   int sessionId,
  //   String pilgrimId,
  //   String pilgrimName,
  //   var trackingRepo,
  // ) async {
  //   try {
  //     final locationService = ref.read(locationServiceProvider);
  //     final initialPosition = await Geolocator.getCurrentPosition(
  //       locationSettings: locationService.optimalLocationSettings,
  //     );
  //     final initialLatLng = LatLng(
  //       initialPosition.latitude,
  //       initialPosition.longitude,
  //     );
  //     await trackingRepo.updatePilgrimLocation(
  //       sessionId: sessionId,
  //       pilgrimId: pilgrimId,
  //       pilgrimName: pilgrimName,
  //       location: initialLatLng,
  //     );
  //     state = PilgrimTrackingState(
  //       pilgrimLocation: initialLatLng,
  //       leaderLocation: state.leaderLocation,
  //       distance: state.distance,
  //       gpsWarning: null,
  //     );
  //   } catch (_) {}
  // }

  // --- المنطق الجوهري: دمج الخطوات مع الموقع ---
  // bool _isMovementReal(double distanceMeters) {
  //   // إذا تحرك الحاج أقل من 5 أمتار، نعتبرها حركة طبيعية ولا نحتاج لتدقيق
  //   if (distanceMeters < 5) return true;
  //   // حساب عدد الخطوات التي مشاها الحاج منذ آخر تحديث سليم للموقع
  //   int stepsTaken = _currentTotalSteps - _stepsAtLastGpsUpdate;
  //   // القاعدة الهندسية: لقطع 10 أمتار، يحتاج الإنسان لـ 12 خطوة على الأقل (في الزحام)
  //   // سنضع حداً أدنى مرناً: خطوة واحدة لكل 1.5 متر
  //   double expectedMinSteps = distanceMeters / 1.5;
  //   debugPrint(
  //     "🔍 فحص المنطق: المسافة $distanceMeters م | الخطوات المسجلة: $stepsTaken | المتوقع: $expectedMinSteps",
  //   );
  //   if (stepsTaken < expectedMinSteps && distanceMeters > 15) {
  //     // إذا قفز الـ GPS أكثر من 15 متر بينما الخطوات قليلة جداً، فهذه قفزة وهمية!
  //     return false;
  //   }
  //   // إذا كانت الحركة منطقية، نحدث عداد الخطوات المرجعي
  //   _stepsAtLastGpsUpdate = _currentTotalSteps;
  //   return true;
  // }
 
   // دالة لبدء الاستماع لعداد الخطوات
  // void _startStepCounting() {
  //   _stepCountSub = Pedometer.stepCountStream.listen((StepCount event) {
  //     _currentTotalSteps = event.steps;
  //     debugPrint("👣 عدد الخطوات الكلي المكتشف: $_currentTotalSteps");
  //   }, onError: (error) => debugPrint("❌ خطأ في مستشعر الخطوات: $error"));
  // }
  
      // await _positionStreamSub?.cancel();
      // _positionStreamSub = locationService.foregroundPositionStream.listen(
      //   (Position position) {
      //     // 🛑 فلتر الدقة: إذا كان احتمال الخطأ أكبر من 25 متر، نتجاهل هذه النقطة تماماً!
      //     if (position.accuracy > 25) {
      //       debugPrint(
      //         "⚠️ تم تجاهل موقع غير دقيق (نسبة الخطأ: ${position.accuracy} م)",
      //       );
      //       return;
      //     }
      //     final currentPos = LatLng(position.latitude, position.longitude);
      //     trackingRepo.updatePilgrimLocation(
      //       sessionId: sessionId,
      //       pilgrimId: pilgrimId,
      //       pilgrimName: pilgrimName,
      //       location: currentPos,
      //     );
      //     _updateStateAndCheckDistance(
      //       pilgrimLoc: currentPos,
      //       leaderLoc: state.leaderLocation,
      //       clearWarning: true,
      //     );
      //   },
      //   onError: (error) {
      //     debugPrint("خطأ في مستمع الموقع: $error");
      //   },
      // );
      // await _positionStreamSub?.cancel();
      // _positionStreamSub = locationService.foregroundPositionStream.listen(
      //   (Position position) {
      //     // 🛑 1. فلتر الدقة:
      //     if (position.accuracy > 25) {
      //       debugPrint(
      //         "⚠️ تم تجاهل موقع غير دقيق (نسبة الخطأ: ${position.accuracy} م)",
      //       );
      //       return;
      //     }
      //     // 🛑 2. فلتر القفزات الوهمية (السرعة المنطقية):
      //     if (_lastValidPosition != null && _lastUpdateTime != null) {
      //       final distanceJump = Geolocator.distanceBetween(
      //         _lastValidPosition!.latitude,
      //         _lastValidPosition!.longitude,
      //         position.latitude,
      //         position.longitude,
      //       );
      //       final timeDiffSeconds = DateTime.now()
      //           .difference(_lastUpdateTime!)
      //           .inSeconds;
      //       if (timeDiffSeconds > 0) {
      //         final speedMetersPerSecond = distanceJump / timeDiffSeconds;
      //         // إذا كانت السرعة أكبر من 4 متر/ثانية (حوالي 14 كم/ساعة)، نتجاهل النقطة!
      //         if (speedMetersPerSecond > 4.0) {
      //           debugPrint(
      //             "⚠️ تم تجاهل قفزة GPS وهمية للحاج (السرعة $speedMetersPerSecond م/ث)",
      //           );
      //           return; // نوقف التنفيذ ولا نحدث الموقع
      //         }
      //       }
      //     }
      //     // ✅ إذا تجاوز الفلاتر، نعتمد الموقع كـ "موقع سليم"
      //     _lastValidPosition = position;
      //     _lastUpdateTime = DateTime.now();
      //     final currentPos = LatLng(position.latitude, position.longitude);
      //     // تحديث الفايربيس والحالة
      //     trackingRepo.updatePilgrimLocation(
      //       sessionId: sessionId,
      //       pilgrimId: pilgrimId,
      //       pilgrimName: pilgrimName,
      //       location: currentPos,
      //     );
      //     _updateStateAndCheckDistance(
      //       pilgrimLoc: currentPos,
      //       leaderLoc: state.leaderLocation,
      //       clearWarning: true,
      //     );
      //   },
      //   onError: (error) {
      //     debugPrint("خطأ في مستمع الموقع: $error");
      //   },
      // );

  // void _updateStateAndCheckDistance({
  //   LatLng? pilgrimLoc,
  //   LatLng? leaderLoc,
  //   bool clearWarning = false,
  // }) {
  //   if (pilgrimLoc == null || leaderLoc == null) {
  //     state = PilgrimTrackingState(
  //       pilgrimLocation: pilgrimLoc ?? state.pilgrimLocation,
  //       leaderLocation: leaderLoc ?? state.leaderLocation,
  //       distance: state.distance,
  //       gpsWarning: clearWarning ? null : state.gpsWarning,
  //     );
  //     return;
  //   }
  //   final distance = Geolocator.distanceBetween(
  //     pilgrimLoc.latitude,
  //     pilgrimLoc.longitude,
  //     leaderLoc.latitude,
  //     leaderLoc.longitude,
  //   );
  //   debugPrint(
  //     "📏 [الحاج] المسافة الحالية بيني وبين المشرف: ${distance.toStringAsFixed(2)} متر",
  //   );
  //   state = PilgrimTrackingState(
  //     pilgrimLocation: pilgrimLoc,
  //     leaderLocation: leaderLoc,
  //     distance: distance,
  //     gpsWarning: clearWarning ? null : state.gpsWarning,
  //   );
  //   if (distance <= _yellowZone) {
  //     if (_redZoneEntryTime != null || _hasWarnedYellow) {
  //       debugPrint("🟢 [الحاج] عدت إلى النطاق الآمن!");
  //     }
  //     _redZoneEntryTime = null;
  //     _hasWarnedYellow = false;
  //     stopAlarmManual();
  //   } else if (distance > _yellowZone && distance <= _redZone) {
  //     debugPrint("🟡 [الحاج] أنا في النطاق الأصفر (تحذير صامت)");
  //     _redZoneEntryTime = null;
  //     stopAlarmManual();
  //     if (!_hasWarnedYellow) {
  //       _hasWarnedYellow = true;
  //       _triggerWarningVibration();
  //     }
  //   } else {
  //     debugPrint("🔴 [الحاج] أنا في النطاق الأحمر!");
  //     if (_redZoneEntryTime == null) {
  //       _redZoneEntryTime = DateTime.now();
  //       debugPrint("⏱️ [الحاج] بدأ عداد الخطر (10 ثواني للإنذار).");
  //     } else {
  //       final secondsInRedZone = DateTime.now()
  //           .difference(_redZoneEntryTime!)
  //           .inSeconds;
  //       debugPrint(
  //         "⏱️ [الحاج] استمرار في الأحمر منذ: $secondsInRedZone ثانية.",
  //       );
  //       if (secondsInRedZone >= _alarmDelaySeconds) {
  //         debugPrint("🚨 [الحاج] إطلاق الإنذار النهائي!");
  //         _triggerEmergency();
  //       }
  //     }
  //   }
  // }
