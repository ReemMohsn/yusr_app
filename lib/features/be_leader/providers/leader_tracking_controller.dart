// import 'dart:async';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:vibration/vibration.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:yusr/core/common/providers/location_service.dart';
// import 'package:yusr/core/common/providers/shared_preferences_service_provider.dart';
// import 'package:yusr/core/constants/shared_preferences_keys.dart';
// import 'package:yusr/features/be_leader/providers/be_leader_repository_provider.dart';
// import 'package:yusr/features/be_leader/providers/state/pilgrim_marker_data.dart';
// import 'package:yusr/features/be_leader/providers/tracking_repository_provider.dart';

// part 'leader_tracking_controller.g.dart';

// class TrackingState {
//   final LatLng? leaderLocation;
//   final List<PilgrimMarkerData> greenPilgrims;
//   final List<PilgrimMarkerData> yellowPilgrims;
//   final List<PilgrimMarkerData> redPilgrims;
//   final bool isLoading;
//   final String? gpsWarning; // 👈 أضفنا هذا المتغير للتنبيهات

//   TrackingState({
//     this.leaderLocation,
//     this.greenPilgrims = const [],
//     this.yellowPilgrims = const [],
//     this.redPilgrims = const [],
//     this.isLoading = true,
//     this.gpsWarning, // 👈
//   });

//   int get totalPilgrims =>
//       greenPilgrims.length + yellowPilgrims.length + redPilgrims.length;
// }

// @Riverpod(keepAlive: true)
// class LeaderTrackingController extends _$LeaderTrackingController {
//   StreamSubscription<Position>? _leaderLocationSub;
//   StreamSubscription<DatabaseEvent>? _pilgrimsSub;
//   StreamSubscription<ServiceStatus>? _serviceStatusSub; // 👈 أضف هذا السطر
//   int? _currentSessionId;
//   Position? _currentLeaderPosition;

//   final AudioPlayer _audioPlayer = AudioPlayer();
//   final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   final double _yellowZone = 20;
//   final double _redZone = 40;
//   final Set<String> _alertedPilgrims = {};
//   // 1. 👈 متغيرات المرشح الزمني الجديدة
//   final Map<String, DateTime> _redZoneEntryTimes =
//       {}; // يحفظ وقت دخول كل حاج للنطاق الأحمر
//   final int _alarmDelaySeconds =
//       10; // عدد الثواني المطلوبة لتأكيد الضياع قبل الإنذار
//   // 👈 القائمة الجديدة: لحفظ الحجاج الذين تم إصدار اهتزاز تحذيري لهم
//   final Set<String> _yellowWarnedPilgrims = {};

//   // 💡 هذا المؤشر يخبرنا إذا كانت الوظيفة تعمل حالياً في الذاكرة أم لا
//   bool get isCurrentlyTracking => _currentSessionId != null;
//   @override
//   TrackingState build() {
//     return TrackingState();
//   }

//   Future<void> startTracking(int sessionId) async {
//     if (_currentSessionId == sessionId && _leaderLocationSub != null) {
//       return;
//     }

//     await _leaderLocationSub?.cancel();

//     await _pilgrimsSub?.cancel();

//     await _serviceStatusSub?.cancel();

//     _currentSessionId = sessionId;

//     state = TrackingState(isLoading: true);

//     try {
//       final repo = ref.read(trackingRepositoryProvider);

//       final locationService = ref.read(locationServiceProvider);

//       // ختم الجلسة في الفايربيس أولاً

//       await repo.initLeaderSession(_currentSessionId.toString());

//       LocationPermission permission = await Geolocator.checkPermission();

//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();

//         if (permission == LocationPermission.denied ||
//             permission == LocationPermission.deniedForever) {
//           state = TrackingState(
//             isLoading: false,

//             gpsWarning:
//                 "لا يمكن بدء التتبع بدون صلاحيات الموقع. يرجى تفعيلها من الإعدادات.",
//           );

//           return;
//         }
//       }

//       // 🌟 دالة داخلية (Local Function) لفتح الاستماع للموقع

//       // وضعناها هنا لكي نستطيع تشغيلها أكثر من مرة دون تكرار الكود

//       void startLocationUpdates() {
//         _leaderLocationSub?.cancel(); // إغلاق أي استماع قديم

//         _leaderLocationSub = locationService.foregroundPositionStream.listen(
//           (Position position) {
//             _currentLeaderPosition = position;

//             final leaderLatLng = LatLng(position.latitude, position.longitude);
//             repo.updateLeaderLocation(
//               sessionId: _currentSessionId.toString(),
//               location: leaderLatLng,
//               heading: position.heading,
//             );
//             state = TrackingState(
//               leaderLocation: leaderLatLng,
//               greenPilgrims: state.greenPilgrims,
//               yellowPilgrims: state.yellowPilgrims,
//               redPilgrims: state.redPilgrims,
//               isLoading: false,
//               gpsWarning: null, // 👈 مسح التحذير فوراً عند التقاط الموقع
//             );
//           },

//           onError: (e) {
//             debugPrint("خطأ في Stream المشرف: $e");
//           },
//         );
//       }

//       // 💡 مراقبة تشغيل/إيقاف زر الـ GPS من إعدادات الهاتف

//       _serviceStatusSub = Geolocator.getServiceStatusStream().listen((
//         ServiceStatus status,
//       ) async {
//         if (status == ServiceStatus.disabled) {
//           state = TrackingState(
//             leaderLocation: state.leaderLocation,

//             greenPilgrims: state.greenPilgrims,

//             yellowPilgrims: state.yellowPilgrims,

//             redPilgrims: state.redPilgrims,

//             isLoading: false,

//             gpsWarning: "تم إغلاق خدمة الموقع (GPS) في الهاتف. يرجى تفعيلها.",
//           );
//         } else {
//           state = TrackingState(
//             leaderLocation: state.leaderLocation,

//             greenPilgrims: state.greenPilgrims,

//             yellowPilgrims: state.yellowPilgrims,

//             redPilgrims: state.redPilgrims,

//             isLoading: false,

//             gpsWarning: "تم تفعيل الـ GPS، جاري التقاط الإشارة...",
//           );

//           // 🚀 [الحل هنا] إعادة إحياء مستمع الموقع لأنه مات عندما كان الـ GPS مغلقاً!

//           startLocationUpdates();

//           // ⚡ محاولة جلب الموقع سريعاً لإنعاش الخريطة فوراً بدون انتظار الـ Stream

//           try {
//             Position quickPos = await Geolocator.getCurrentPosition(
//               locationSettings: const LocationSettings(
//                 accuracy: LocationAccuracy.high,

//                 timeLimit: Duration(seconds: 5),
//               ),
//             );

//             _currentLeaderPosition = quickPos;

//             final quickLatLng = LatLng(quickPos.latitude, quickPos.longitude);

//             repo.updateLeaderLocation(
//               sessionId: _currentSessionId.toString(),

//               location: quickLatLng,

//               heading: quickPos.heading,
//             );

//             state = TrackingState(
//               leaderLocation: quickLatLng,
//               isLoading: false,
//               gpsWarning: null,
//             );
//           } catch (_) {}
//         }
//       });

//       // ⚡ فحص أولي عند الدخول: إذا كان הـ GPS يعمل، جلب الموقع بسرعة

//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

//       if (!serviceEnabled) {
//         state = TrackingState(
//           isLoading: false,

//           gpsWarning: "يرجى تفعيل خدمة الـ GPS (الموقع) في هاتفك.",
//         );
//       } else {
//         try {
//           Position? initialPosition = await Geolocator.getCurrentPosition(
//             locationSettings: const LocationSettings(
//               accuracy: LocationAccuracy.high,

//               timeLimit: Duration(seconds: 10),
//             ),
//           );

//           _currentLeaderPosition = initialPosition;

//           final initialLatLng = LatLng(
//             initialPosition.latitude,
//             initialPosition.longitude,
//           );

//           state = TrackingState(
//             leaderLocation: initialLatLng,
//             isLoading: false,
//           );

//           repo.updateLeaderLocation(
//             sessionId: _currentSessionId.toString(),

//             location: initialLatLng,

//             heading: initialPosition.heading,
//           );
//         } on TimeoutException {
//           debugPrint("إشارة GPS ضعيفة لجلب الموقع الأولي.");
//         } catch (_) {}
//       }

//       // تشغيل الاستماع للموقع عند الدخول

//       startLocationUpdates();

//       // الاستماع للحجاج

//       _pilgrimsSub = repo.pilgrimsStream(_currentSessionId.toString()).listen((
//         DatabaseEvent event,
//       ) {
//         _processPilgrimsAndAlert(event.snapshot);
//       });
//     } catch (e) {
//       debugPrint("خطأ غير متوقع أثناء بدء التتبع: $e");

//       state = TrackingState(
//         isLoading: false,

//         gpsWarning: "حدث خطأ في النظام. يرجى التأكد من الصلاحيات.",
//       );
//     }
//   }

//   void _processPilgrimsAndAlert(DataSnapshot snapshot) {
//     if (_currentLeaderPosition == null || !snapshot.exists) return;

//     final pilgrimsData = snapshot.value as Map<dynamic, dynamic>;

//     List<PilgrimMarkerData> green = [];
//     List<PilgrimMarkerData> yellow = [];
//     List<PilgrimMarkerData> red = [];
//     bool hasRedPilgrims = false;

//     pilgrimsData.forEach((key, value) {
//       final lat = value['latitude'];
//       final lng = value['longitude'];
//       final name = value['name'] ?? 'أحد الحجاج';

//       if (lat == null || lng == null) return;

//       final distance = Geolocator.distanceBetween(
//         _currentLeaderPosition!.latitude,
//         _currentLeaderPosition!.longitude,
//         lat,
//         lng,
//       );

//       final pilgrim = PilgrimMarkerData(
//         id: key,
//         name: name,
//         location: LatLng(lat, lng),
//       );
//       // 🟢 النطاق الأخضر
//       if (distance <= _yellowZone) {
//         green.add(pilgrim);
//         _alertedPilgrims.remove(key);
//         _redZoneEntryTimes.remove(key);
//         _yellowWarnedPilgrims.remove(
//           key,
//         ); // 👈 تصفير حالة التحذير ليعمل الاهتزاز مجدداً إذا تأخر لاحقاً
//       }
//       // 🟡 النطاق الأصفر
//       else if (distance > _yellowZone && distance <= _redZone) {
//         yellow.add(pilgrim);
//         _alertedPilgrims.remove(key);
//         _redZoneEntryTimes.remove(key);
//         // 👈 استدعاء دالة التحذير مع تمرير الـ ID والاسم
//         _triggerWarningVibration(key, name);
//       } else {
//         red.add(pilgrim);
//         hasRedPilgrims = true;

//         // التحقق من المرشح الزمني قبل إطلاق الإنذار
//         if (!_alertedPilgrims.contains(key)) {
//           // إذا كانت هذه أول مرة نلتقطه في الأحمر، نبدأ العداد
//           if (!_redZoneEntryTimes.containsKey(key)) {
//             _redZoneEntryTimes[key] = DateTime.now();
//           }
//           // إذا كان العداد شغالاً مسبقاً، نتحقق كم ثانية مرت
//           else {
//             final entryTime = _redZoneEntryTimes[key]!;
//             final secondsInRedZone = DateTime.now()
//                 .difference(entryTime)
//                 .inSeconds;

//             // إذا مرت الـ 10 ثواني وهو لا يزال في الأحمر، أطلق الإنذار!
//             if (secondsInRedZone >= _alarmDelaySeconds) {
//               _triggerEmergency(key, name);
//               _redZoneEntryTimes.remove(key); // تنظيف العداد بعد إطلاق الإنذار
//             }
//           }
//         }
//       }
//     });

//     // إيقاف الإنذار إذا عاد جميع الحجاج للوضع الآمن
//     if (!hasRedPilgrims) {
//       stopAlarmManual();
//     }
//     state = TrackingState(
//       leaderLocation: state.leaderLocation,
//       greenPilgrims: green,
//       yellowPilgrims: yellow,
//       redPilgrims: red,
//       isLoading: false,
//     );
//   }

//   Future<void> _triggerWarningVibration(
//     String pilgrimId,
//     String pilgrimName,
//   ) async {
//     // تجنب التكرار إذا تم تحذير المشرف مسبقاً عن هذا الحاج
//     if (_yellowWarnedPilgrims.contains(pilgrimId)) return;

//     _yellowWarnedPilgrims.add(pilgrimId);

//     // 1. الاهتزاز الخفيف المخصص
//     if (await Vibration.hasVibrator() ?? false) {
//       Vibration.vibrate(pattern: [0, 200, 100, 200]);
//     }

//     // 2. إرسال الإشعار الصامت
//     const AndroidNotificationDetails
//     warningDetails = AndroidNotificationDetails(
//       'warning_channel', // 👈 قناة منفصلة عن قناة الطوارئ
//       'تحذيرات الحجاج المتأخرين',
//       importance: Importance.defaultImportance,
//       priority: Priority.defaultPriority,
//       playSound: false, // 👈 إشعار صامت تماماً
//       enableVibration:
//           false, // 👈 ألغينا اهتزاز الإشعار الافتراضي لأننا نستخدم الاهتزاز المخصص أعلاه
//     );

//     await _notificationsPlugin.show(
//       pilgrimId
//           .hashCode, // 👈 استخدام hashCode كـ ID ليتمكن التطبيق من عرض عدة إشعارات إذا تأخر أكثر من حاج
//       '🟡 تنبيه تأخر حاج',
//       'الحاج "$pilgrimName" بدأ يبتعد عن المجموعة.',
//       const NotificationDetails(android: warningDetails),
//       payload: 'warning_notification',
//     );
//   }

//   Future<void> _triggerEmergency(String pilgrimId, String pilgrimName) async {
//     if (_alertedPilgrims.contains(pilgrimId)) return;
//     _alertedPilgrims.add(pilgrimId);

//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//           'emergency_channel',
//           'طوارئ الحجاج',
//           importance: Importance.max,
//           priority: Priority.high,
//         );
//     await _notificationsPlugin.show(
//       0,
//       '🚨 إنذار خطر!',
//       'الحاج $pilgrimName خرج عن النطاق المسموح!',
//       const NotificationDetails(android: androidDetails),
//       payload: 'emergency_alarm', // 👈 أضفنا هذه الكلمة لتمييز إشعار الخطر
//     );

//     if (await Vibration.hasVibrator() ?? false) {
//       Vibration.vibrate(pattern: [500, 1000, 500, 1000]);
//     }
//     await _audioPlayer.setReleaseMode(ReleaseMode.loop);
//     await _audioPlayer.play(AssetSource('sounds/alarm.mp3'));
//   }

//   // دالة لإيقاف الإنذار يدوياً
//   void stopAlarmManual() {
//     _audioPlayer.stop();
//     Vibration.cancel();
//   }

//   // الإيقاف الرسمي
//   Future<void> stopSessionOfficially() async {
//     if (_currentSessionId == null) return;

//     try {
//       state = TrackingState(isLoading: true);

//       // 1. إيقاف الاستماع
//       await _leaderLocationSub?.cancel();
//       await _pilgrimsSub?.cancel();
//       stopAlarmManual();

//       // 2. استخدام Repository لحذف الجلسة
//       final repo = ref.read(trackingRepositoryProvider);
//       await repo.deleteSession(_currentSessionId.toString());

//       // 3. طلب الـ API لإنهاء الجلسة (إذا كان لديك API Repository)
//       final apiRepo = ref.read(leaderTrackingApiRepositoryProvider);
//       await apiRepo.endSession(_currentSessionId!);

//       // د. حذف الـ SessionId من الـ SharedPreferences
//       final sharedPrefs = ref.read(sharedPreferencesServiceProvider);
//       await sharedPrefs.removeInt(SharedPreferencesKeys.currentSessionId);
//       await _serviceStatusSub?.cancel();
//       _currentSessionId = null;
//       _currentLeaderPosition = null;
//     } catch (e) {
//       print("خطأ أثناء إغلاق الجلسة: $e");
//     }
//   }

//   // دالة تنظيف الجلسات الشبحية (تُستدعى من التوجيه)
//   Future<void> cleanUpGhostSession(int oldSessionId) async {
//     try {
//       // 1. حذف الجلسة من الفايربيس
//       final repo = ref.read(trackingRepositoryProvider);
//       await repo.deleteSession(oldSessionId.toString());

//       // 2. إنهاء الجلسة في الباك إند
//       final apiRepo = ref.read(leaderTrackingApiRepositoryProvider);
//       await apiRepo.endSession(oldSessionId);

//       // 3. مسح الذاكرة المحلية
//       final sharedPrefs = ref.read(sharedPreferencesServiceProvider);
//       await sharedPrefs.removeInt(SharedPreferencesKeys.currentSessionId);

//       debugPrint("🧹 تم تنظيف الجلسة القديمة $oldSessionId بنجاح");
//     } catch (e) {
//       debugPrint("⚠️ خطأ أثناء تنظيف الجلسة القديمة: $e");
//     }
//   }
// }

// void startLocationUpdates() {
//   _leaderLocationSub?.cancel();
//   _leaderLocationSub = locationService.foregroundPositionStream.listen(
//     (Position position) {
//       // 🛑 1. فلتر الدقة:
//       if (position.accuracy > 25) {
//         debugPrint(
//           "⚠️ تم تجاهل موقع المشرف لضعف الدقة (${position.accuracy} م)",
//         );
//         return;
//       }
//       // 🛑 2. فلتر القفزات الوهمية (السرعة المنطقية):
//       if (_lastValidLeaderPosition != null &&
//           _lastLeaderUpdateTime != null) {
//         final distanceJump = Geolocator.distanceBetween(
//           _lastValidLeaderPosition!.latitude,
//           _lastValidLeaderPosition!.longitude,
//           position.latitude,
//           position.longitude,
//         );
//         final timeDiffSeconds = DateTime.now()
//             .difference(_lastLeaderUpdateTime!)
//             .inSeconds;
//         if (timeDiffSeconds > 0) {
//           final speedMetersPerSecond = distanceJump / timeDiffSeconds;
//           if (speedMetersPerSecond > 4.0) {
//             debugPrint(
//               "⚠️ تم تجاهل قفزة GPS وهمية للمشرف (السرعة $speedMetersPerSecond م/ث)",
//             );
//             return;
//           }
//         }
//       }
//       // ✅ اعتماد الموقع السليم
//       _lastValidLeaderPosition = position;
//       _lastLeaderUpdateTime = DateTime.now();
//       _currentLeaderPosition = position;
//       final leaderLatLng = LatLng(position.latitude, position.longitude);
//       repo.updateLeaderLocation(
//         sessionId: _currentSessionId.toString(),
//         location: leaderLatLng,
//         heading: position.heading,
//       );
//       state = TrackingState(
//         leaderLocation: leaderLatLng,
//         greenPilgrims: state.greenPilgrims,
//         yellowPilgrims: state.yellowPilgrims,
//         redPilgrims: state.redPilgrims,
//         isLoading: false,
//         gpsWarning: null,
//       );
//     },
//     onError: (e) {
//       debugPrint("خطأ في Stream المشرف: $e");
//     },
//   );
// }

// void startLocationUpdates() {
//   _leaderLocationSub?.cancel();
//   _leaderLocationSub = locationService.foregroundPositionStream.listen(
//     (Position position) {
//       // 🌟 التعديل 2: فلتر الدقة لتجاهل قراءات المشرف المشوشة (GPS يقفز)
//       if (position.accuracy > 25) {
//         debugPrint(
//           "⚠️ تم تجاهل موقع المشرف لضعف الدقة (${position.accuracy} م)",
//         );
//         return;
//       }
//       _currentLeaderPosition = position;
//       final leaderLatLng = LatLng(position.latitude, position.longitude);
//       repo.updateLeaderLocation(
//         sessionId: _currentSessionId.toString(),
//         location: leaderLatLng,
//         heading: position.heading,
//       );
//       state = TrackingState(
//         leaderLocation: leaderLatLng,
//         greenPilgrims: state.greenPilgrims,
//         yellowPilgrims: state.yellowPilgrims,
//         redPilgrims: state.redPilgrims,
//         isLoading: false,
//         gpsWarning: null,
//       );
//     },
//     onError: (e) {
//       debugPrint("خطأ في Stream المشرف: $e");
//     },
//   );
// }

import 'dart:async';
import 'dart:math';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vibration/vibration.dart';
import 'package:latlong2/latlong.dart';
import 'package:yusr/core/common/providers/location_service.dart';
import 'package:yusr/core/common/providers/shared_preferences_service_provider.dart';
import 'package:yusr/core/constants/shared_preferences_keys.dart';
import 'package:yusr/features/be_leader/providers/be_leader_repository_provider.dart';
import 'package:yusr/features/be_leader/providers/state/pilgrim_marker_data.dart';
import 'package:yusr/features/be_leader/providers/tracking_repository_provider.dart';
import 'package:permission_handler/permission_handler.dart' hide ServiceStatus;
// //////////////////////////////////////////////////////////
part 'leader_tracking_controller.g.dart';

class TrackingState {
  final LatLng? leaderLocation;
  final List<PilgrimMarkerData> greenPilgrims;
  final List<PilgrimMarkerData> yellowPilgrims;
  final List<PilgrimMarkerData> redPilgrims;
  final bool isLoading;
  final String? gpsWarning;

  TrackingState({
    this.leaderLocation,
    this.greenPilgrims = const [],
    this.yellowPilgrims = const [],
    this.redPilgrims = const [],
    this.isLoading = true,
    this.gpsWarning,
  });

  int get totalPilgrims =>
      greenPilgrims.length + yellowPilgrims.length + redPilgrims.length;
}

@Riverpod(keepAlive: true)
class LeaderTrackingController extends _$LeaderTrackingController {
  StreamSubscription<Position>? _leaderLocationSub;
  StreamSubscription<DatabaseEvent>? _pilgrimsSub;
  StreamSubscription<ServiceStatus>? _serviceStatusSub;

  // 🌟 إضافة البلوتوث: مستمع الرادار ومتغيرات التخزين
  StreamSubscription<List<ScanResult>>? _bleScanSub;
  final Map<int, double> _bleDistances = {}; // تحويل إلى int
  final Map<int, DateTime> _lastBleUpdates = {}; // تحويل إلى int
  int? _currentSessionId;
  Position? _currentLeaderPosition;
  Position? _lastValidLeaderPosition;
  DateTime? _lastLeaderUpdateTime;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final double _yellowZone = 25; // التحذير الصامت
  final double _redZone = 40; // الخطر المؤكد (الإنذار)

  final Set<String> _alertedPilgrims = {};
  final Map<String, DateTime> _redZoneEntryTimes = {};
  final int _alarmDelaySeconds = 10;
  final Set<String> _yellowWarnedPilgrims = {};

  bool get isCurrentlyTracking => _currentSessionId != null;
  // --- متغيرات مستشعر الحركة (فلتر المشي) للمشرف ---
  StreamSubscription<AccelerometerEvent>? _accelSub;
  DateTime _lastStepTime = DateTime.now();
  int _consecutiveSteps = 0;
  double _lastAcc = 0.0;
  int _trustedTotalSteps = 0;
  int _stepsAtLastGpsUpdate = 0;
  // ------------------------------------------------
  @override
  TrackingState build() {
    return TrackingState();
  }

  // يجب إضافة مصفوفة لحفظ الحالة السابقة لتجنب الكتابة المتكررة في فايربيس
  final Map<String, bool> _lastSentBleStatus = {};

  Future<void> _updatePilgrimBleStatusInFirebase(
    String pilgrimId,
    bool isSafe,
  ) async {
    if (_lastSentBleStatus[pilgrimId] != isSafe) {
      _lastSentBleStatus[pilgrimId] = isSafe;
      try {
        final repo = ref.read(trackingRepositoryProvider);
        // تقوم هذه الدالة بتحديث حقل 'isSafeByBle' داخل بيانات الحاج في الجلسة
        await repo.updatePilgrimSafeFlag(
          _currentSessionId.toString(),
          pilgrimId,
          isSafe,
        );
      } catch (e) {
        debugPrint("خطأ في تحديث صك الأمان: $e");
      }
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
            }
          } else if (msDiff > 1200) {
            _consecutiveSteps = 0;
          }
        }
        _lastAcc = acc;
      },
      onError: (error) {
        debugPrint("❌ خطأ في مستشعر الحركة للمشرف: $error");
      },
    );
  }

  bool _isMovementReal(double distanceMeters) {
    if (distanceMeters < 5) return true; // مسافات صغيرة جداً نتجاوزها

    int stepsTaken = _trustedTotalSteps - _stepsAtLastGpsUpdate;
    double expectedMinSteps = distanceMeters / 1.5;

    debugPrint(
      "🔍 [المشرف] حماية الموقع: المسافة $distanceMeters م | خطوات فعلية: $stepsTaken | المتوقع: $expectedMinSteps",
    );

    // إذا كانت المسافة كبيرة ولم يمشِ المشرف خطوات كافية، نرفض التحديث
    if (stepsTaken < expectedMinSteps && distanceMeters > 15) {
      return false;
    }

    _stepsAtLastGpsUpdate = _trustedTotalSteps;
    return true;
  }

  // -----------------------------------------
  // 🌟 إضافة البلوتوث: دالة بدء الرادار للاستماع لنبضات الحجاج
  void _startBleScanning() {
    try {
      FlutterBluePlus.startScan(continuousUpdates: true);
      _bleScanSub = FlutterBluePlus.scanResults.listen((results) {
        for (ScanResult r in results) {
          int? extractedMinorId = _extractMinorIdFromBeacon(r); // استخراج الرقم

          if (extractedMinorId != null) {
            int rssi = r.rssi;
            double estimatedDistance = pow(10, (-59 - rssi) / 20.0).toDouble();

            _bleDistances[extractedMinorId] = estimatedDistance;
            _lastBleUpdates[extractedMinorId] = DateTime.now();
          }
        }
      });
      debugPrint("📡 [بلوتوث المشرف] الرادار يعمل ويستمع للحجاج...");
    } catch (e) {
      debugPrint("❌ [بلوتوث المشرف] فشل تشغيل الرادار: $e");
    }
  }

  int? _extractMinorIdFromBeacon(ScanResult result) {
    final manufacturerData = result.advertisementData.manufacturerData;
    // 76 هو المعرف القياسي لنظام iBeacon (يعمل حتى لو كان الحاج أندرويد)
    if (manufacturerData.containsKey(76)) {
      final data = manufacturerData[76]!;
      // حزمة iBeacon القياسية طولها دائماً 23 بايت
      if (data.length >= 23) {
        // رقم الحاج (Minor) موجود دائماً في البايت 20 و 21
        int minorId = (data[20] << 8) + data[21];
        return minorId;
      }
    }
    return null;
  }

  Future<void> startTracking(int sessionId) async {
    if (_currentSessionId == sessionId && _leaderLocationSub != null) {
      return;
    }

    await _leaderLocationSub?.cancel();
    await _pilgrimsSub?.cancel();
    await _serviceStatusSub?.cancel();
    await _bleScanSub?.cancel(); // 🌟 إيقاف الرادار القديم إن وجد
    await _accelSub?.cancel(); // إيقاف مستشعر الحركة القديم إن وجد

    _currentSessionId = sessionId;
    state = TrackingState(isLoading: true);

    try {
      final repo = ref.read(trackingRepositoryProvider);
      final locationService = ref.read(locationServiceProvider);

      await repo.initLeaderSession(_currentSessionId.toString());

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = TrackingState(
          isLoading: false,
          gpsWarning: "يرجى تفعيل خدمة الـ GPS (الموقع) في هاتفك.",
        );
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          state = TrackingState(
            isLoading: false,
            gpsWarning:
                "لا يمكن بدء التتبع بدون صلاحيات الموقع. يرجى تفعيلها من الإعدادات.",
          );
          return;
        }
      }

      // 🌟 طلب صلاحيات البلوتوث للأجهزة الحديثة (أندرويد 12+) قبل بدء الرادار
      await [
        Permission.bluetooth,
        Permission.bluetoothAdvertise,
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
      ].request();

      // 🌟 تشغيل رادار البلوتوث تزامناً مع الـ GPS
      _startBleScanning();
      _startSmartStepCounting(); // 🌟 تشغيل فلتر المشي الخاص بالمشرف
      void startLocationUpdates() {
        _leaderLocationSub?.cancel();
        _leaderLocationSub = locationService.foregroundPositionStream.listen((
          Position position,
        ) {
          debugPrint(
            "📍 [المشرف] تم التقاط موقع جديد | الدقة: ${position.accuracy.toStringAsFixed(2)} متر | الإحداثيات: ${position.latitude}, ${position.longitude}",
          );

          if (position.accuracy > 25) {
            debugPrint(
              "⚠️ [المشرف] ❌ تم تجاهل الموقع لضعف الدقة (${position.accuracy} متر).",
            );
            return;
          }
          if (_lastValidLeaderPosition != null &&
              _lastLeaderUpdateTime != null) {
            final distanceJump = Geolocator.distanceBetween(
              _lastValidLeaderPosition!.latitude,
              _lastValidLeaderPosition!.longitude,
              position.latitude,
              position.longitude,
            );
            final timeDiffSeconds = DateTime.now()
                .difference(_lastLeaderUpdateTime!)
                .inSeconds;

            if (timeDiffSeconds > 0) {
              final speedMetersPerSecond = distanceJump / timeDiffSeconds;
              debugPrint(
                "🏃 [المشرف] المسافة المقطوعة: ${distanceJump.toStringAsFixed(2)} متر | خلال: $timeDiffSeconds ثانية | السرعة: ${speedMetersPerSecond.toStringAsFixed(2)} م/ث",
              );

              if (speedMetersPerSecond > 4.0) {
                debugPrint(
                  "⚠️ [المشرف] ❌ تم تجاهل قفزة GPS وهمية (السرعة عالية جداً: $speedMetersPerSecond م/ث).",
                );
                return;
              } else {
                debugPrint("✅ [المشرف] الموقع منطقي واجتاز فلتر السرعة.");
              }
            }
            // 🌟 هنا نطبق حماية فلتر المشي للمشرف قبل تحديث الفايربيس
            if (!_isMovementReal(distanceJump)) {
              debugPrint(
                "🛑 [حماية] تم اكتشاف قفزة GPS وهمية للمشرف: المشرف لم يمشِ مسافة كافية لهذه القفزة!",
              );
              return;
            }
          }

          _lastValidLeaderPosition = position;
          _lastLeaderUpdateTime = DateTime.now();
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
            gpsWarning: null,
          );
        });
      }

      _serviceStatusSub = Geolocator.getServiceStatusStream().listen((
        ServiceStatus status,
      ) async {
        if (status == ServiceStatus.disabled) {
          state = TrackingState(
            leaderLocation: state.leaderLocation,
            greenPilgrims: state.greenPilgrims,
            yellowPilgrims: state.yellowPilgrims,
            redPilgrims: state.redPilgrims,
            isLoading: false,
            gpsWarning: "تم إغلاق خدمة الموقع (GPS) في الهاتف. يرجى تفعيلها.",
          );
        } else {
          state = TrackingState(
            leaderLocation: state.leaderLocation,
            greenPilgrims: state.greenPilgrims,
            yellowPilgrims: state.yellowPilgrims,
            redPilgrims: state.redPilgrims,
            isLoading: false,
            gpsWarning: "تم تفعيل الـ GPS، جاري التقاط الإشارة...",
          );
          startLocationUpdates();

          try {
            Position quickPos = await Geolocator.getCurrentPosition(
              locationSettings: locationService
                  .optimalLocationSettings, // استخدام الإعدادات المدمجة الجديدة
            );

            _currentLeaderPosition = quickPos;
            final quickLatLng = LatLng(quickPos.latitude, quickPos.longitude);

            repo.updateLeaderLocation(
              sessionId: _currentSessionId.toString(),
              location: quickLatLng,
              heading: quickPos.heading,
            );
            // لا ننسى إعادة تهيئة مرجعيات الحماية عند تحديث الموقع قسرياً
            _lastValidLeaderPosition = quickPos;
            _lastLeaderUpdateTime = DateTime.now();
            _stepsAtLastGpsUpdate = _trustedTotalSteps;

            state = TrackingState(
              leaderLocation: quickLatLng,
              greenPilgrims: state.greenPilgrims,
              yellowPilgrims: state.yellowPilgrims,
              redPilgrims: state.redPilgrims,
              isLoading: false,
              gpsWarning: null,
            );
          } catch (_) {}
        }
      });

      if (serviceEnabled) {
        try {
          Position? initialPosition = await Geolocator.getCurrentPosition(
            locationSettings: locationService
                .optimalLocationSettings, // استخدام الإعدادات المدمجة الجديدة
          );

          _currentLeaderPosition = initialPosition;

          // تهيئة المرجعيات الابتدائية
          _lastValidLeaderPosition = initialPosition;
          _lastLeaderUpdateTime = DateTime.now();
          _stepsAtLastGpsUpdate = _trustedTotalSteps;

          final initialLatLng = LatLng(
            initialPosition.latitude,
            initialPosition.longitude,
          );

          state = TrackingState(
            leaderLocation: initialLatLng,
            isLoading: false,
          );

          repo.updateLeaderLocation(
            sessionId: _currentSessionId.toString(),
            location: initialLatLng,
            heading: initialPosition.heading,
          );
        } on TimeoutException {
          debugPrint("إشارة GPS ضعيفة لجلب الموقع الأولي.");
        } catch (_) {}
      }
      startLocationUpdates();

      _pilgrimsSub = repo.pilgrimsStream(_currentSessionId.toString()).listen((
        DatabaseEvent event,
      ) {
        _processPilgrimsAndAlert(event.snapshot);
      });
    } catch (e) {
      state = TrackingState(
        isLoading: false,
        gpsWarning: "حدث خطأ في النظام. يرجى التأكد من الصلاحيات.",
      );
    }
  }

  // void _processPilgrimsAndAlert(DataSnapshot snapshot) {
  //   if (_currentLeaderPosition == null || !snapshot.exists) return;
  //   final pilgrimsData = snapshot.value as Map<dynamic, dynamic>;
  //   List<PilgrimMarkerData> green = [];
  //   List<PilgrimMarkerData> yellow = [];
  //   List<PilgrimMarkerData> red = [];
  //   bool hasRedPilgrims = false;
  //   pilgrimsData.forEach((key, value) {
  //     final lat = value['latitude'];
  //     final lng = value['longitude'];
  //     final name = value['name'] ?? 'أحد الحجاج';
  //     if (lat == null || lng == null) return;
  //     final gpsDistance = Geolocator.distanceBetween(
  //       _currentLeaderPosition!.latitude,
  //       _currentLeaderPosition!.longitude,
  //       lat,
  //       lng,
  //     );
  //     double finalDistance = gpsDistance; // المسافة الافتراضية هي الـ GPS
  //     // 🌟 تطبيق دمج المستشعرات (Sensor Fusion) هنا 🌟
  //     // نحول الـ key (وهو pilgrimId النصي) إلى رقم minorId لمطابقته مع رادار البلوتوث
  //     int pilgrimMinorId = key.toString().hashCode % 65535;
  //     if (_bleDistances.containsKey(pilgrimMinorId) &&
  //         _lastBleUpdates.containsKey(pilgrimMinorId)) {
  //       final timeSinceLastBle = DateTime.now()
  //           .difference(_lastBleUpdates[pilgrimMinorId]!)
  //           .inSeconds;
  //       final bleDistance = _bleDistances[pilgrimMinorId]!;
  //       if (timeSinceLastBle <= 20) {
  //         // إذا كان البلوتوث يقول أن الحاج أقرب من ما يقوله الـ GPS، صدق البلوتوث فوراً!
  //         if (bleDistance < gpsDistance) {
  //           debugPrint(
  //             "🛡️ [تصحيح مسافة للحاج $name] الـ GPS: ${gpsDistance.toStringAsFixed(1)}م | البلوتوث: ${bleDistance.toStringAsFixed(1)}م -> تم اعتماد البلوتوث.",
  //           );
  //           finalDistance = bleDistance;
  //         }
  //       }
  //     }
  //     // 🌟 انتهى التعديل 🌟
  //     final pilgrim = PilgrimMarkerData(
  //       id: key,
  //       name: name,
  //       location: LatLng(lat, lng),
  //     );
  //     // نستخدم FinalDistance بدلاً من مسافة الـ GPS فقط
  //     if (finalDistance <= _yellowZone) {
  //       green.add(pilgrim);
  //       _alertedPilgrims.remove(key);
  //       _redZoneEntryTimes.remove(key);
  //       _yellowWarnedPilgrims.remove(key);
  //     } else if (finalDistance > _yellowZone && finalDistance <= _redZone) {
  //       yellow.add(pilgrim);
  //       _alertedPilgrims.remove(key);
  //       _redZoneEntryTimes.remove(key);
  //       _triggerWarningVibration(key, name);
  //     } else {
  //       red.add(pilgrim);
  //       hasRedPilgrims = true;
  //       if (!_alertedPilgrims.contains(key)) {
  //         if (!_redZoneEntryTimes.containsKey(key)) {
  //           _redZoneEntryTimes[key] = DateTime.now();
  //         } else {
  //           final secondsInRedZone = DateTime.now()
  //               .difference(_redZoneEntryTimes[key]!)
  //               .inSeconds;
  //           if (secondsInRedZone >= _alarmDelaySeconds) {
  //             _triggerEmergency(key, name);
  //             _redZoneEntryTimes.remove(key);
  //           }
  //         }
  //       }
  //     }
  //   });
  //   if (!hasRedPilgrims) {
  //     stopAlarmManual();
  //   }
  //   state = TrackingState(
  //     leaderLocation: state.leaderLocation,
  //     greenPilgrims: green,
  //     yellowPilgrims: yellow,
  //     redPilgrims: red,
  //     isLoading: false,
  //   );
  // }

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
      final name = value['name'] ?? 'أحد الحجاج';
      if (lat == null || lng == null) return;

      final gpsDistance = Geolocator.distanceBetween(
        _currentLeaderPosition!.latitude,
        _currentLeaderPosition!.longitude,
        lat,
        lng,
      );

      double finalDistance = gpsDistance; // المسافة الافتراضية هي الـ GPS

      // 🌟 التعديلات الجديدة تبدأ هنا 🌟
      bool isSafeByBle = false;
      LatLng displayLocation = LatLng(
        lat,
        lng,
      ); // الموقع الافتراضي للعرض في الخريطة

      int pilgrimMinorId = key.toString().hashCode % 65535;

      if (_bleDistances.containsKey(pilgrimMinorId) &&
          _lastBleUpdates.containsKey(pilgrimMinorId)) {
        final timeSinceLastBle = DateTime.now()
            .difference(_lastBleUpdates[pilgrimMinorId]!)
            .inSeconds;
        final bleDistance = _bleDistances[pilgrimMinorId]!;

        if (timeSinceLastBle <= 20) {
          if (bleDistance < gpsDistance) {
            debugPrint(
              "🛡️ [تصحيح مسافة للحاج $name] الـ GPS: ${gpsDistance.toStringAsFixed(1)}م | البلوتوث: ${bleDistance.toStringAsFixed(1)}م -> تم اعتماد البلوتوث.",
            );
            finalDistance = bleDistance;
            isSafeByBle = true; // إعطاء صك الأمان

            // الخدعة البصرية: سحب إحداثيات الحاج ليكون بجوار المشرف في الخريطة
            displayLocation = LatLng(
              _currentLeaderPosition!.latitude + 0.0001,
              _currentLeaderPosition!.longitude + 0.0001,
            );
          }
        }
      }

      // إرسال صك الأمان لفايربيس (تأكد من وجود الدالة _updatePilgrimBleStatusInFirebase في ملفك)
      _updatePilgrimBleStatusInFirebase(key.toString(), isSafeByBle);

      // 🌟 انتهت التعديلات الجديدة 🌟

      final pilgrim = PilgrimMarkerData(
        id: key,
        name: name,
        location:
            displayLocation, // 🌟 استخدمنا الموقع المعدل هنا بدلاً من LatLng(lat, lng)
      );

      if (finalDistance <= _yellowZone) {
        green.add(pilgrim);
        _alertedPilgrims.remove(key);
        _redZoneEntryTimes.remove(key);
        _yellowWarnedPilgrims.remove(key);
      } else if (finalDistance > _yellowZone && finalDistance <= _redZone) {
        yellow.add(pilgrim);
        _alertedPilgrims.remove(key);
        _redZoneEntryTimes.remove(key);
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
      Vibration.vibrate(pattern: [0, 200, 100, 200]);
    }
    const AndroidNotificationDetails warningDetails =
        AndroidNotificationDetails(
          'warning_channel',
          'تحذيرات الحجاج المتأخرين',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          playSound: false,
          enableVibration: false,
        );
    await _notificationsPlugin.show(
      pilgrimId.hashCode,
      '🟡 تنبيه تأخر حاج',
      'الحاج "$pilgrimName" بدأ يبتعد عن المجموعة.',
      const NotificationDetails(android: warningDetails),
      payload: 'warning_notification',
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
      payload: 'emergency_alarm',
    );
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(pattern: [500, 1000, 500, 1000]);
    }
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('sounds/alarm.mp3'));
  }

  void stopAlarmManual() {
    _audioPlayer.stop();
    Vibration.cancel();
  }

  Future<void> stopSessionOfficially() async {
    if (_currentSessionId == null) return;
    try {
      state = TrackingState(isLoading: true);

      await _leaderLocationSub?.cancel();
      await _pilgrimsSub?.cancel();
      await _bleScanSub?.cancel(); // 🌟 إيقاف الرادار
      FlutterBluePlus.stopScan(); // 🌟 إيقاف الاستماع للبلوتوث
      await _accelSub?.cancel(); // 🌟 إيقاف مستشعر الحركة
      stopAlarmManual();

      final repo = ref.read(trackingRepositoryProvider);
      await repo.deleteSession(_currentSessionId.toString());

      final apiRepo = ref.read(leaderTrackingApiRepositoryProvider);
      await apiRepo.endSession(_currentSessionId!);

      final sharedPrefs = ref.read(sharedPreferencesServiceProvider);
      await sharedPrefs.removeInt(SharedPreferencesKeys.currentSessionId);
      await _serviceStatusSub?.cancel();
      _currentSessionId = null;
      _currentLeaderPosition = null;
      _lastValidLeaderPosition = null;
      _lastLeaderUpdateTime = null;
      _bleDistances.clear(); // 🌟 تصفية ذاكرة الرادار
      _lastBleUpdates.clear();
      // 🌟 تصفية عدادات المشي
      _trustedTotalSteps = 0;
      _stepsAtLastGpsUpdate = 0;
      _consecutiveSteps = 0;
    } catch (e) {
      print("خطأ أثناء إغلاق الجلسة: $e");
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

  // void _processPilgrimsAndAlert(DataSnapshot snapshot) {
  //   if (_currentLeaderPosition == null || !snapshot.exists) return;
  //   final pilgrimsData = snapshot.value as Map<dynamic, dynamic>;
  //   List<PilgrimMarkerData> green = [];
  //   List<PilgrimMarkerData> yellow = [];
  //   List<PilgrimMarkerData> red = [];
  //   bool hasRedPilgrims = false;
  //   pilgrimsData.forEach((key, value) {
  //     final lat = value['latitude'];
  //     final lng = value['longitude'];
  //     final name = value['name'] ?? 'أحد الحجاج';
  //     if (lat == null || lng == null) return;
  //     // 1. حساب مسافة الـ GPS (الطريقة القديمة)
  //     final gpsDistance = Geolocator.distanceBetween(
  //       _currentLeaderPosition!.latitude,
  //       _currentLeaderPosition!.longitude,
  //       lat,
  //       lng,
  //     );
  //     double finalDistance = gpsDistance; // المسافة التي سنعتمدها
  //     // 🌟 2. دمج البلوتوث (Sensor Fusion): القاضي الذي يكشف كذب الـ GPS!
  //     if (_bleDistances.containsKey(key) && _lastBleUpdates.containsKey(key)) {
  //       final timeSinceLastBle = DateTime.now()
  //           .difference(_lastBleUpdates[key]!)
  //           .inSeconds;
  //       final bleDistance = _bleDistances[key]!;
  //       // إذا التقطنا إشارة بلوتوث حديثة للحاج (في آخر 20 ثانية)
  //       if (timeSinceLastBle <= 20) {
  //         // حالة الخداع: الـ GPS يقول أن الحاج بعيد (أحمر)، لكن البلوتوث يقول أنه قريب!
  //         if (gpsDistance >= _redZone && bleDistance <= _yellowZone) {
  //           debugPrint(
  //             "🛡️ [حماية GPS كاذب] الـ GPS يعطي مسافة ($gpsDistance م) للحاج $name، ولكن البلوتوث يؤكد أنه بجوارك ($bleDistance م)!",
  //           );
  //           finalDistance = bleDistance; // تجاهل الـ GPS واعتمد البلوتوث!
  //         }
  //       }
  //     }
 
// @Riverpod(keepAlive: true)
// class LeaderTrackingController extends _$LeaderTrackingController {
//   StreamSubscription<Position>? _leaderLocationSub;
//   StreamSubscription<DatabaseEvent>? _pilgrimsSub;
//   StreamSubscription<ServiceStatus>? _serviceStatusSub;
//   int? _currentSessionId;
//   Position? _currentLeaderPosition;
//   Position? _lastValidLeaderPosition;
//   DateTime? _lastLeaderUpdateTime;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   // 🌟 التعديل 1: توحيد المسافات مع كود الحاج لتقليل الإنذارات الكاذبة
//   final double _yellowZone = 25; // التحذير الصامت
//   final double _redZone = 40; // الخطر المؤكد (الإنذار)

//   final Set<String> _alertedPilgrims = {};
//   final Map<String, DateTime> _redZoneEntryTimes = {};
//   final int _alarmDelaySeconds = 10;
//   final Set<String> _yellowWarnedPilgrims = {};

//   bool get isCurrentlyTracking => _currentSessionId != null;

//   @override
//   TrackingState build() {
//     return TrackingState();
//   }

//   Future<void> startTracking(int sessionId) async {
//     if (_currentSessionId == sessionId && _leaderLocationSub != null) {
//       return;
//     }

//     await _leaderLocationSub?.cancel();
//     await _pilgrimsSub?.cancel();
//     await _serviceStatusSub?.cancel();

//     _currentSessionId = sessionId;
//     state = TrackingState(isLoading: true);

//     try {
//       final repo = ref.read(trackingRepositoryProvider);
//       final locationService = ref.read(locationServiceProvider);

//       await repo.initLeaderSession(_currentSessionId.toString());

//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         state = TrackingState(
//           isLoading: false,
//           gpsWarning: "يرجى تفعيل خدمة الـ GPS (الموقع) في هاتفك.",
//         );
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied ||
//             permission == LocationPermission.deniedForever) {
//           state = TrackingState(
//             isLoading: false,
//             gpsWarning:
//                 "لا يمكن بدء التتبع بدون صلاحيات الموقع. يرجى تفعيلها من الإعدادات.",
//           );
//           return;
//         }
//       }
//       void startLocationUpdates() {
//         _leaderLocationSub?.cancel();
//         _leaderLocationSub = locationService.foregroundPositionStream.listen(
//           (Position position) {
//             debugPrint(
//               "📍 [المشرف] تم التقاط موقع جديد | الدقة: ${position.accuracy.toStringAsFixed(2)} متر | الإحداثيات: ${position.latitude}, ${position.longitude}",
//             );

//             if (position.accuracy > 25) {
//               debugPrint(
//                 "⚠️ [المشرف] ❌ تم تجاهل الموقع لضعف الدقة (${position.accuracy} متر).",
//               );
//               return;
//             }

//             if (_lastValidLeaderPosition != null &&
//                 _lastLeaderUpdateTime != null) {
//               final distanceJump = Geolocator.distanceBetween(
//                 _lastValidLeaderPosition!.latitude,
//                 _lastValidLeaderPosition!.longitude,
//                 position.latitude,
//                 position.longitude,
//               );
//               final timeDiffSeconds = DateTime.now()
//                   .difference(_lastLeaderUpdateTime!)
//                   .inSeconds;

//               if (timeDiffSeconds > 0) {
//                 final speedMetersPerSecond = distanceJump / timeDiffSeconds;
//                 debugPrint(
//                   "🏃 [المشرف] المسافة المقطوعة: ${distanceJump.toStringAsFixed(2)} متر | خلال: $timeDiffSeconds ثانية | السرعة: ${speedMetersPerSecond.toStringAsFixed(2)} م/ث",
//                 );

//                 if (speedMetersPerSecond > 4.0) {
//                   debugPrint(
//                     "⚠️ [المشرف] ❌ تم تجاهل قفزة GPS وهمية (السرعة عالية جداً: $speedMetersPerSecond م/ث).",
//                   );
//                   return;
//                 } else {
//                   debugPrint("✅ [المشرف] الموقع منطقي واجتاز فلتر السرعة.");
//                 }
//               }
//             }

//             _lastValidLeaderPosition = position;
//             _lastLeaderUpdateTime = DateTime.now();
//             _currentLeaderPosition = position;

//             final leaderLatLng = LatLng(position.latitude, position.longitude);
//             repo.updateLeaderLocation(
//               sessionId: _currentSessionId.toString(),
//               location: leaderLatLng,
//               heading: position.heading,
//             );
//             debugPrint("☁️ [المشرف] تم رفع الموقع الجديد إلى فايربيس بنجاح.");

//             state = TrackingState(
//               leaderLocation: leaderLatLng,
//               greenPilgrims: state.greenPilgrims,
//               yellowPilgrims: state.yellowPilgrims,
//               redPilgrims: state.redPilgrims,
//               isLoading: false,
//               gpsWarning: null,
//             );
//           },
//           onError: (e) {
//             debugPrint("❌ [المشرف] خطأ في بث الموقع: $e");
//           },
//         );
//       }

//       _serviceStatusSub = Geolocator.getServiceStatusStream().listen((
//         ServiceStatus status,
//       ) async {
//         if (status == ServiceStatus.disabled) {
//           state = TrackingState(
//             leaderLocation: state.leaderLocation,
//             greenPilgrims: state.greenPilgrims,
//             yellowPilgrims: state.yellowPilgrims,
//             redPilgrims: state.redPilgrims,
//             isLoading: false,
//             gpsWarning: "تم إغلاق خدمة الموقع (GPS) في الهاتف. يرجى تفعيلها.",
//           );
//         } else {
//           state = TrackingState(
//             leaderLocation: state.leaderLocation,
//             greenPilgrims: state.greenPilgrims,
//             yellowPilgrims: state.yellowPilgrims,
//             redPilgrims: state.redPilgrims,
//             isLoading: false,
//             gpsWarning: "تم تفعيل الـ GPS، جاري التقاط الإشارة...",
//           );
//           startLocationUpdates();

//           try {
//             Position quickPos = await Geolocator.getCurrentPosition(
//               locationSettings: locationService
//                   .optimalLocationSettings, // استخدام الإعدادات المدمجة الجديدة
//             );

//             _currentLeaderPosition = quickPos;
//             final quickLatLng = LatLng(quickPos.latitude, quickPos.longitude);

//             repo.updateLeaderLocation(
//               sessionId: _currentSessionId.toString(),
//               location: quickLatLng,
//               heading: quickPos.heading,
//             );

//             state = TrackingState(
//               leaderLocation: quickLatLng,
//               greenPilgrims: state.greenPilgrims,
//               yellowPilgrims: state.yellowPilgrims,
//               redPilgrims: state.redPilgrims,
//               isLoading: false,
//               gpsWarning: null,
//             );
//           } catch (_) {}
//         }
//       });

//       if (serviceEnabled) {
//         try {
//           Position? initialPosition = await Geolocator.getCurrentPosition(
//             locationSettings: locationService
//                 .optimalLocationSettings, // استخدام الإعدادات المدمجة الجديدة
//           );

//           _currentLeaderPosition = initialPosition;
//           final initialLatLng = LatLng(
//             initialPosition.latitude,
//             initialPosition.longitude,
//           );

//           state = TrackingState(
//             leaderLocation: initialLatLng,
//             isLoading: false,
//           );

//           repo.updateLeaderLocation(
//             sessionId: _currentSessionId.toString(),
//             location: initialLatLng,
//             heading: initialPosition.heading,
//           );
//         } on TimeoutException {
//           debugPrint("إشارة GPS ضعيفة لجلب الموقع الأولي.");
//         } catch (_) {}
//       }

//       startLocationUpdates();

//       _pilgrimsSub = repo.pilgrimsStream(_currentSessionId.toString()).listen((
//         DatabaseEvent event,
//       ) {
//         _processPilgrimsAndAlert(event.snapshot);
//       });
//     } catch (e) {
//       debugPrint("خطأ غير متوقع أثناء بدء التتبع: $e");
//       state = TrackingState(
//         isLoading: false,
//         gpsWarning: "حدث خطأ في النظام. يرجى التأكد من الصلاحيات.",
//       );
//     }
//   }

//   void _processPilgrimsAndAlert(DataSnapshot snapshot) {
//     if (_currentLeaderPosition == null || !snapshot.exists) return;

//     final pilgrimsData = snapshot.value as Map<dynamic, dynamic>;
//     debugPrint(
//       "👥 [المشرف] جاري معالجة بيانات الحجاج... (العدد: ${pilgrimsData.length})",
//     );

//     List<PilgrimMarkerData> green = [];
//     List<PilgrimMarkerData> yellow = [];
//     List<PilgrimMarkerData> red = [];
//     bool hasRedPilgrims = false;

//     pilgrimsData.forEach((key, value) {
//       final lat = value['latitude'];
//       final lng = value['longitude'];
//       final name = value['name'] ?? 'أحد الحجاج';

//       if (lat == null || lng == null) return;

//       final distance = Geolocator.distanceBetween(
//         _currentLeaderPosition!.latitude,
//         _currentLeaderPosition!.longitude,
//         lat,
//         lng,
//       );

//       final pilgrim = PilgrimMarkerData(
//         id: key,
//         name: name,
//         location: LatLng(lat, lng),
//       );

//       if (distance <= _yellowZone) {
//         debugPrint(
//           "🟢 [المشرف] الحاج: $name | المسافة: ${distance.toStringAsFixed(2)} متر -> (نطاق آمن)",
//         );
//         green.add(pilgrim);
//         _alertedPilgrims.remove(key);
//         _redZoneEntryTimes.remove(key);
//         _yellowWarnedPilgrims.remove(key);
//       } else if (distance > _yellowZone && distance <= _redZone) {
//         debugPrint(
//           "🟡 [المشرف] الحاج: $name | المسافة: ${distance.toStringAsFixed(2)} متر -> (نطاق تحذير)",
//         );
//         yellow.add(pilgrim);
//         _alertedPilgrims.remove(key);
//         _redZoneEntryTimes.remove(key);
//         _triggerWarningVibration(key, name);
//       } else {
//         debugPrint(
//           "🔴 [المشرف] الحاج: $name | المسافة: ${distance.toStringAsFixed(2)} متر -> (خطر/خارج النطاق)",
//         );
//         red.add(pilgrim);
//         hasRedPilgrims = true;

//         if (!_alertedPilgrims.contains(key)) {
//           if (!_redZoneEntryTimes.containsKey(key)) {
//             _redZoneEntryTimes[key] = DateTime.now();
//             debugPrint(
//               "⏱️ [المشرف] الحاج $name دخل النطاق الأحمر. يبدأ العد التنازلي للإنذار (10 ثواني).",
//             );
//           } else {
//             final entryTime = _redZoneEntryTimes[key]!;
//             final secondsInRedZone = DateTime.now()
//                 .difference(entryTime)
//                 .inSeconds;

//             debugPrint(
//               "⏱️ [المشرف] الحاج $name مستمر في النطاق الأحمر منذ $secondsInRedZone ثانية.",
//             );

//             if (secondsInRedZone >= _alarmDelaySeconds) {
//               debugPrint("🚨 [المشرف] إطلاق الإنذار للحاج $name!");
//               _triggerEmergency(key, name);
//               _redZoneEntryTimes.remove(key);
//             }
//           }
//         }
//       }
//     });

//     if (!hasRedPilgrims) {
//       stopAlarmManual();
//     }
//     state = TrackingState(
//       leaderLocation: state.leaderLocation,
//       greenPilgrims: green,
//       yellowPilgrims: yellow,
//       redPilgrims: red,
//       isLoading: false,
//     );
//   }

//   Future<void> _triggerWarningVibration(
//     String pilgrimId,
//     String pilgrimName,
//   ) async {
//     if (_yellowWarnedPilgrims.contains(pilgrimId)) return;
//     _yellowWarnedPilgrims.add(pilgrimId);
//     if (await Vibration.hasVibrator() ?? false) {
//       Vibration.vibrate(pattern: [0, 200, 100, 200]);
//     }
//     const AndroidNotificationDetails warningDetails =
//         AndroidNotificationDetails(
//           'warning_channel',
//           'تحذيرات الحجاج المتأخرين',
//           importance: Importance.defaultImportance,
//           priority: Priority.defaultPriority,
//           playSound: false,
//           enableVibration: false,
//         );
//     await _notificationsPlugin.show(
//       pilgrimId.hashCode,
//       '🟡 تنبيه تأخر حاج',
//       'الحاج "$pilgrimName" بدأ يبتعد عن المجموعة.',
//       const NotificationDetails(android: warningDetails),
//       payload: 'warning_notification',
//     );
//   }

//   Future<void> _triggerEmergency(String pilgrimId, String pilgrimName) async {
//     if (_alertedPilgrims.contains(pilgrimId)) return;
//     _alertedPilgrims.add(pilgrimId);
//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//           'emergency_channel',
//           'طوارئ الحجاج',
//           importance: Importance.max,
//           priority: Priority.high,
//         );
//     await _notificationsPlugin.show(
//       0,
//       '🚨 إنذار خطر!',
//       'الحاج $pilgrimName خرج عن النطاق المسموح!',
//       const NotificationDetails(android: androidDetails),
//       payload: 'emergency_alarm',
//     );
//     if (await Vibration.hasVibrator() ?? false) {
//       Vibration.vibrate(pattern: [500, 1000, 500, 1000]);
//     }
//     await _audioPlayer.setReleaseMode(ReleaseMode.loop);
//     await _audioPlayer.play(AssetSource('sounds/alarm.mp3'));
//   }

//   void stopAlarmManual() {
//     _audioPlayer.stop();
//     Vibration.cancel();
//   }

//   Future<void> stopSessionOfficially() async {
//     if (_currentSessionId == null) return;

//     try {
//       state = TrackingState(isLoading: true);

//       await _leaderLocationSub?.cancel();
//       await _pilgrimsSub?.cancel();
//       stopAlarmManual();

//       final repo = ref.read(trackingRepositoryProvider);
//       await repo.deleteSession(_currentSessionId.toString());

//       final apiRepo = ref.read(leaderTrackingApiRepositoryProvider);
//       await apiRepo.endSession(_currentSessionId!);

//       final sharedPrefs = ref.read(sharedPreferencesServiceProvider);
//       await sharedPrefs.removeInt(SharedPreferencesKeys.currentSessionId);
//       await _serviceStatusSub?.cancel();
//       _currentSessionId = null;
//       _currentLeaderPosition = null;
//       _lastValidLeaderPosition = null; // أضف هذا
//       _lastLeaderUpdateTime = null; // أضف هذا
//     } catch (e) {
//       print("خطأ أثناء إغلاق الجلسة: $e");
//     }
//   }

//   Future<void> cleanUpGhostSession(int oldSessionId) async {
//     try {
//       final repo = ref.read(trackingRepositoryProvider);
//       await repo.deleteSession(oldSessionId.toString());

//       final apiRepo = ref.read(leaderTrackingApiRepositoryProvider);
//       await apiRepo.endSession(oldSessionId);

//       final sharedPrefs = ref.read(sharedPreferencesServiceProvider);
//       await sharedPrefs.removeInt(SharedPreferencesKeys.currentSessionId);

//       debugPrint("🧹 تم تنظيف الجلسة القديمة $oldSessionId بنجاح");
//     } catch (e) {
//       debugPrint("⚠️ خطأ أثناء تنظيف الجلسة القديمة: $e");
//     }
//   }
// }
// // /////////////////////////////////////////////////////////////////////
  // void _processPilgrimsAndAlert(DataSnapshot snapshot) {
  //   if (_currentLeaderPosition == null || !snapshot.exists) return;
  //   final pilgrimsData = snapshot.value as Map<dynamic, dynamic>;
  //   List<PilgrimMarkerData> green = [];
  //   List<PilgrimMarkerData> yellow = [];
  //   List<PilgrimMarkerData> red = [];
  //   bool hasRedPilgrims = false;
  //   pilgrimsData.forEach((key, value) {
  //     final lat = value['latitude'];
  //     final lng = value['longitude'];
  //     final name = value['name'] ?? 'أحد الحجاج';
  //     if (lat == null || lng == null) return;
  //     final distance = Geolocator.distanceBetween(
  //       _currentLeaderPosition!.latitude,
  //       _currentLeaderPosition!.longitude,
  //       lat,
  //       lng,
  //     );
  //     final pilgrim = PilgrimMarkerData(
  //       id: key,
  //       name: name,
  //       location: LatLng(lat, lng),
  //     );
  //     if (distance <= _yellowZone) {
  //       green.add(pilgrim);
  //       _alertedPilgrims.remove(key);
  //       _redZoneEntryTimes.remove(key);
  //       _yellowWarnedPilgrims.remove(key);
  //     } else if (distance > _yellowZone && distance <= _redZone) {
  //       yellow.add(pilgrim);
  //       _alertedPilgrims.remove(key);
  //       _redZoneEntryTimes.remove(key);
  //       _triggerWarningVibration(key, name);
  //     } else {
  //       red.add(pilgrim);
  //       hasRedPilgrims = true;
  //       if (!_alertedPilgrims.contains(key)) {
  //         if (!_redZoneEntryTimes.containsKey(key)) {
  //           _redZoneEntryTimes[key] = DateTime.now();
  //         } else {
  //           final entryTime = _redZoneEntryTimes[key]!;
  //           final secondsInRedZone = DateTime.now()
  //               .difference(entryTime)
  //               .inSeconds;
  //           if (secondsInRedZone >= _alarmDelaySeconds) {
  //             _triggerEmergency(key, name);
  //             _redZoneEntryTimes.remove(key);
  //           }
  //         }
  //       }
  //     }
  //   });
  //   if (!hasRedPilgrims) {
  //     stopAlarmManual();
  //   }
  //   state = TrackingState(
  //     leaderLocation: state.leaderLocation,
  //     greenPilgrims: green,
  //     yellowPilgrims: yellow,
  //     redPilgrims: red,
  //     isLoading: false,
  //   );
  // }

