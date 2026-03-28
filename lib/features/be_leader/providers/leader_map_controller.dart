// import 'dart:async';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// // استيراد الملفات الخاصة بك
// import 'package:yusr/features/be_leader/data/repositories/tracking_repository.dart';
// import 'package:yusr/features/be_leader/providers/state/alert_event.dart';
// import 'package:yusr/features/be_leader/providers/state/leader_map_state.dart';
// import 'package:yusr/features/be_leader/providers/state/pilgrim_marker_data.dart';
// import 'package:yusr/features/be_leader/providers/tracking_repository_provider.dart';

// // 1. تعريف ملف الـ part الذي سيتم توليده
// part 'leader_map_controller.g.dart';

// // 2. استخدام الأنوتيشن، وسيقوم Riverpod بتوليد الكود كـ AutoDispose تلقائياً
// @riverpod
// class LeaderMapController extends _$LeaderMapController {
//   StreamSubscription? _leaderSub;
//   StreamSubscription? _pilgrimsSub;
//   final Distance _distanceCalc = const Distance();
//   // أضفنا هذه الذاكرة المؤقتة لحفظ مواقع الحجاج محلياً لاستخدامها عند تحرك المشرف
//   final Map<String, PilgrimMarkerData> _allPilgrimsCache = {};

//   // خريطة لتتبع حالة كل حاج حتى لا نكرر الإشعارات المزعجة كل ثانية
//   final Map<String, String> _pilgrimStatusCache = {};

//   @override
//   LeaderMapState build(int sessionId) {
//     // 4. استبدال دالة dispose() بـ ref.onDispose لضمان تنظيف الذاكرة
//     ref.onDispose(() {
//       _leaderSub?.cancel();
//       _pilgrimsSub?.cancel();
//     });

//     // بدء تشغيل الاستماع للبيانات
//     _initStreams(sessionId);
//     // إرجاع الحالة الابتدائية
//     return LeaderMapState();
//   }

//   void _initStreams(int sessionId) {
//     // نستخدم ref.read (أو ref.watch) لجلب الريبوزيتوري
//     final repo = ref.read(trackingRepositoryProvider);
//     final sessionString = sessionId.toString();
//     // 1. الاستماع لموقع المشرف
//     _leaderSub = repo.leaderStream(sessionString).listen((event) {
//       if (event.snapshot.value != null) {
//         final data = Map<String, dynamic>.from(event.snapshot.value as Map);
//         final lat = data['latitude'] as double;
//         final lng = data['longitude'] as double;

//         state = LeaderMapState(
//           leaderLocation: LatLng(lat, lng),
//           greenPilgrims: state.greenPilgrims,
//           yellowPilgrims: state.yellowPilgrims,
//           redPilgrims: state.redPilgrims,
//           isLoading: false,
//         );
//         _recalculateDistances(); // إعادة الحساب إذا تحرك المشرف
//       }
//     });

//     // 2. الاستماع لمواقع الحجاج
//     _pilgrimsSub = repo.pilgrimsStream(sessionString).listen((event) {
//       if (event.snapshot.value != null && state.leaderLocation != null) {
//         final data = Map<String, dynamic>.from(event.snapshot.value as Map);
//         _processPilgrimsData(data);
//       }
//     });
//   }

import 'dart:async';
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:geolocator/geolocator.dart'; // 👈 تمت إضافة هذا الاستيراد للـ GPS
import 'package:yusr/core/common/providers/location_service.dart';

// استيراد الملفات الخاصة بك
import 'package:yusr/features/be_leader/providers/state/alert_event.dart';
import 'package:yusr/features/be_leader/providers/state/leader_map_state.dart';
import 'package:yusr/features/be_leader/providers/state/pilgrim_marker_data.dart';
import 'package:yusr/features/be_leader/providers/tracking_repository_provider.dart';
// تأكد من استيراد LocationService

part 'leader_map_controller.g.dart';

@riverpod
class LeaderMapController extends _$LeaderMapController {
  // StreamSubscription? _leaderSub;
  StreamSubscription? _pilgrimsSub;
  StreamSubscription<Position>?
  _leaderLocalGpsSub; // 👈 1. إضافة متغير للاستماع لـ GPS المشرف محلياً

  final Distance _distanceCalc = const Distance();
  final Map<String, PilgrimMarkerData> _allPilgrimsCache = {};
  final Map<String, String> _pilgrimStatusCache = {};

  @override
  LeaderMapState build(int sessionId) {
    ref.onDispose(() {
      // _leaderSub?.cancel();
      _pilgrimsSub?.cancel();
      _leaderLocalGpsSub?.cancel(); // 👈 2. إغلاقه لتنظيف الذاكرة
    });

    // 👈 3. تشغيل دالة رفع موقع المشرف للفايربيس أولاً
    _startPushingLeaderLocation(sessionId);

    _initStreams(sessionId);
    return LeaderMapState();
  }

  // 👈 4. الدالة السحرية التي كانت مفقودة!
  // هذه الدالة تقرأ الـ GPS للمشرف وترفعه للفايربيس
  Future<void> _startPushingLeaderLocation(int sessionId) async {
    try {
      final repo = ref.read(trackingRepositoryProvider);
      final locationService = ref.read(locationServiceProvider);

      // التأكد من الصلاحيات (اختياري هنا لو كنت تأكدت منها في شاشة سابقة)
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      // أخذ الموقع الأولي فوراً (ليكسر شاشة التحميل)
      Position initialPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      // رفعه للفايربيس
      await repo.updateLeaderLocation(
        sessionId: sessionId.toString(),
        location: LatLng(initialPosition.latitude, initialPosition.longitude),
        heading: initialPosition.heading,
      );

      // // الاستماع لحركة المشرف المستقبلية ورفعها باستمرار
      // _leaderLocalGpsSub = locationService.positionStream.listen((
      //   Position position,
      // ) {
      //   repo.updateLeaderLocation(
      //     sessionId: sessionId.toString(),
      //     location: LatLng(position.latitude, position.longitude),
      //     heading: position.heading,
      //   );
      // });
      // الاستماع لحركة المشرف المستقبلية محلياً
      _leaderLocalGpsSub = locationService.positionStream.listen((
        Position position,
      ) {
        final newLocation = LatLng(position.latitude, position.longitude);

        // 1. تحديث شاشة المشرف فوراً (بدون انتظار الفايربيس!)
        state = LeaderMapState(
          leaderLocation: newLocation,
          greenPilgrims: state.greenPilgrims,
          yellowPilgrims: state.yellowPilgrims,
          redPilgrims: state.redPilgrims,
          isLoading: false,
          currentAlert: state.currentAlert,
        );

        // إعادة حساب المسافات لأن المشرف تحرك
        _recalculateDistances();

        // 2. رفع الموقع للفايربيس بصمت ليراه الحجاج
        repo.updateLeaderLocation(
          sessionId: sessionId.toString(),
          location: newLocation,
          heading: position.heading,
        );
      });
    } catch (e) {
      print("❌ خطأ في التقاط أو رفع موقع المشرف: $e");
    }
  }

  void _initStreams(int sessionId) {
    final repo = ref.read(trackingRepositoryProvider);
    final sessionString = sessionId.toString();

    // الاستماع لموقع المشرف
    // _leaderSub = repo.leaderStream(sessionString).listen((event) {
    //   if (event.snapshot.value != null) {
    //     final data = Map<String, dynamic>.from(event.snapshot.value as Map);
    //     final lat = data['latitude'] as double;
    //     final lng = data['longitude'] as double;
    //     state = LeaderMapState(
    //       leaderLocation: LatLng(lat, lng),
    //       greenPilgrims: state.greenPilgrims,
    //       yellowPilgrims: state.yellowPilgrims,
    //       redPilgrims: state.redPilgrims,
    //       isLoading: false, // 👈 هنا ستختفي دائرة التحميل!
    //     );
    //     _recalculateDistances();
    //   }
    // });

    // الاستماع لمواقع الحجاج
    _pilgrimsSub = repo.pilgrimsStream(sessionString).listen((event) {
      if (event.snapshot.value != null && state.leaderLocation != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        _processPilgrimsData(data);
      }
    });
  }

  // 1. الدالة الأولى: تستقبل البيانات من الفايربيس وتحدث الذاكرة المؤقتة فقط
  void _processPilgrimsData(Map<String, dynamic> data) {
    if (state.leaderLocation == null) return;

    // تحديث الذاكرة المؤقتة بأحدث بيانات الحجاج
    data.forEach((key, value) {
      final pilgrimData = Map<String, dynamic>.from(value);
      final lat = pilgrimData['latitude'] as double;
      final lng = pilgrimData['longitude'] as double;
      final name = pilgrimData['name'] as String;

      _allPilgrimsCache[key] = PilgrimMarkerData(
        id: key,
        name: name,
        location: LatLng(lat, lng),
      );
    });

    // بعد تحديث مواقعهم، نأمر بتصنيفهم
    _categorizePilgrims();
  }

  // 2. الدالة الثانية: المُزامن (The Synchronizer) الذي سألتِ عنه
  void _recalculateDistances() {
    // إذا لم يكن هناك حجاج في الذاكرة بعد، لا داعي للقيام بشيء
    if (_allPilgrimsCache.isEmpty) return;

    // إعادة فرز الحجاج بناءً على موقع المشرف الجديد
    _categorizePilgrims();
  }

  // 3. الدالة الثالثة: محرك الحسابات (المشترك بين حركة المشرف وحركة الحجاج)
  void _categorizePilgrims() {
    if (state.leaderLocation == null) return;

    List<PilgrimMarkerData> green = [];
    List<PilgrimMarkerData> yellow = [];
    List<PilgrimMarkerData> red = [];

    // نمر على كل الحجاج المحفوظين في الذاكرة المؤقتة
    for (var pData in _allPilgrimsCache.values) {
      // حساب المسافة بين موقع المشرف (الذي قد يكون تغير للتو) وموقع الحاج
      final distance = _distanceCalc.as(
        LengthUnit.Meter,
        state.leaderLocation!,
        pData.location,
      );

      // تصنيف الحجاج وإطلاق التنبيهات
      if (distance <= 75) {
        green.add(pData);
        _pilgrimStatusCache[pData.id] = 'green';
      } else if (distance > 75 && distance <= 150) {
        yellow.add(pData);
        _checkAndAlert(pData.id, pData.name, 'yellow');
      } else {
        red.add(pData);
        _checkAndAlert(pData.id, pData.name, 'red');
      }
    }

    // اللحظة الحاسمة: تحديث الـ State بالألوان الجديدة
    state = LeaderMapState(
      leaderLocation: state.leaderLocation,
      greenPilgrims: green,
      yellowPilgrims: yellow,
      redPilgrims: red,
      isLoading: false,
    );
  }

  // داخل LeaderMapController
  void _checkAndAlert(String id, String name, String newStatus) {
    final oldStatus = _pilgrimStatusCache[id];

    if (oldStatus != newStatus) {
      _pilgrimStatusCache[id] = newStatus;

      // إنشاء الحدث
      final alertEvent = AlertEvent(
        pilgrimId: id,
        pilgrimName: name,
        alertType: newStatus,
        timestamp: DateTime.now(), // الوقت الحالي لضمان عدم تطابق الأحداث
      );

      // تحديث الحالة وإرسال الحدث للواجهة
      state = LeaderMapState(
        leaderLocation: state.leaderLocation,
        greenPilgrims: state.greenPilgrims,
        yellowPilgrims: state.yellowPilgrims,
        redPilgrims: state.redPilgrims,
        isLoading: state.isLoading,
        currentAlert: alertEvent, // 🚨 هنا نطلق الإنذار للواجهة!
      );
    }
  }
}
