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
  int? _currentSessionId;
  Position? _currentLeaderPosition;
  Position? _lastValidLeaderPosition;
  DateTime? _lastLeaderUpdateTime;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // 🌟 التعديل 1: توحيد المسافات مع كود الحاج لتقليل الإنذارات الكاذبة
  final double _yellowZone = 25; // التحذير الصامت
  final double _redZone = 40; // الخطر المؤكد (الإنذار)

  final Set<String> _alertedPilgrims = {};
  final Map<String, DateTime> _redZoneEntryTimes = {};
  final int _alarmDelaySeconds = 10;
  final Set<String> _yellowWarnedPilgrims = {};

  bool get isCurrentlyTracking => _currentSessionId != null;

  @override
  TrackingState build() {
    return TrackingState();
  }

  Future<void> startTracking(int sessionId) async {
    if (_currentSessionId == sessionId && _leaderLocationSub != null) {
      return;
    }

    await _leaderLocationSub?.cancel();
    await _pilgrimsSub?.cancel();
    await _serviceStatusSub?.cancel();

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
      void startLocationUpdates() {
        _leaderLocationSub?.cancel();
        _leaderLocationSub = locationService.foregroundPositionStream.listen(
          (Position position) {
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
            debugPrint("☁️ [المشرف] تم رفع الموقع الجديد إلى فايربيس بنجاح.");

            state = TrackingState(
              leaderLocation: leaderLatLng,
              greenPilgrims: state.greenPilgrims,
              yellowPilgrims: state.yellowPilgrims,
              redPilgrims: state.redPilgrims,
              isLoading: false,
              gpsWarning: null,
            );
          },
          onError: (e) {
            debugPrint("❌ [المشرف] خطأ في بث الموقع: $e");
          },
        );
      }
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
      debugPrint("خطأ غير متوقع أثناء بدء التتبع: $e");
      state = TrackingState(
        isLoading: false,
        gpsWarning: "حدث خطأ في النظام. يرجى التأكد من الصلاحيات.",
      );
    }
  }

  void _processPilgrimsAndAlert(DataSnapshot snapshot) {
    if (_currentLeaderPosition == null || !snapshot.exists) return;

    final pilgrimsData = snapshot.value as Map<dynamic, dynamic>;
    debugPrint(
      "👥 [المشرف] جاري معالجة بيانات الحجاج... (العدد: ${pilgrimsData.length})",
    );

    List<PilgrimMarkerData> green = [];
    List<PilgrimMarkerData> yellow = [];
    List<PilgrimMarkerData> red = [];
    bool hasRedPilgrims = false;

    pilgrimsData.forEach((key, value) {
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
        debugPrint(
          "🟢 [المشرف] الحاج: $name | المسافة: ${distance.toStringAsFixed(2)} متر -> (نطاق آمن)",
        );
        green.add(pilgrim);
        _alertedPilgrims.remove(key);
        _redZoneEntryTimes.remove(key);
        _yellowWarnedPilgrims.remove(key);
      } else if (distance > _yellowZone && distance <= _redZone) {
        debugPrint(
          "🟡 [المشرف] الحاج: $name | المسافة: ${distance.toStringAsFixed(2)} متر -> (نطاق تحذير)",
        );
        yellow.add(pilgrim);
        _alertedPilgrims.remove(key);
        _redZoneEntryTimes.remove(key);
        _triggerWarningVibration(key, name);
      } else {
        debugPrint(
          "🔴 [المشرف] الحاج: $name | المسافة: ${distance.toStringAsFixed(2)} متر -> (خطر/خارج النطاق)",
        );
        red.add(pilgrim);
        hasRedPilgrims = true;

        if (!_alertedPilgrims.contains(key)) {
          if (!_redZoneEntryTimes.containsKey(key)) {
            _redZoneEntryTimes[key] = DateTime.now();
            debugPrint(
              "⏱️ [المشرف] الحاج $name دخل النطاق الأحمر. يبدأ العد التنازلي للإنذار (10 ثواني).",
            );
          } else {
            final entryTime = _redZoneEntryTimes[key]!;
            final secondsInRedZone = DateTime.now()
                .difference(entryTime)
                .inSeconds;

            debugPrint(
              "⏱️ [المشرف] الحاج $name مستمر في النطاق الأحمر منذ $secondsInRedZone ثانية.",
            );

            if (secondsInRedZone >= _alarmDelaySeconds) {
              debugPrint("🚨 [المشرف] إطلاق الإنذار للحاج $name!");
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
      _lastValidLeaderPosition = null; // أضف هذا
      _lastLeaderUpdateTime = null; // أضف هذا
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
