import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/features/be_leader/providers/be_leader_repository_provider.dart';
import 'package:yusr/features/be_leader/providers/tracking_repository_provider.dart';
import 'package:yusr/core/common/providers/location_service.dart';

part 'pilgrim_tracking_controller.g.dart';

@Riverpod(keepAlive: true)
class PilgrimTrackingController extends _$PilgrimTrackingController {
  StreamSubscription<Position>? _positionStreamSub;

  @override
  AsyncValue<void> build() {
    // إغلاق الاستماع تلقائياً إذا تم تدمير الـ Provider
    ref.onDispose(() {
      stopTracking();
    });
    return const AsyncData(null);
  }

  Future<void> acceptAndStartTracking({
    required int sessionId,
    required String pilgrimId,
    required String pilgrimName,
  }) async {
    state = const AsyncLoading();
    try {
      final trackingApiRepo = ref.read(leaderTrackingApiRepositoryProvider);

      print("1️⃣ جاري إرسال الموافقة للـ API...");
      await trackingApiRepo.respondToSession(sessionId, 2);
      print("✅ تم الإرسال للـ API بنجاح!");

      print("2️⃣ جاري فحص حالة خدمة الـ GPS في الهاتف...");
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = AsyncError("خدمة الموقع مغلقة في الهاتف.", StackTrace.current);
        return;
      }
      print("✅ خدمة الـ GPS مفعلة.");

      print("3️⃣ جاري فحص الصلاحيات...");
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          state = AsyncError("صلاحية الموقع مرفوضة.", StackTrace.current);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        state = AsyncError("صلاحية الموقع مرفوضة دائماً.", StackTrace.current);
        return;
      }
      print("✅ الصلاحيات ممنوحة: $permission");

      final trackingRepo = ref.read(trackingRepositoryProvider);

      print("4️⃣ جاري جلب الموقع الأولي (مسموح بـ 15 ثانية كحد أقصى)...");
      // الإضافة الأهم: مهلة زمنية (timeLimit) لمنع التجميد الما لا نهاية
      final initialPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      print("✅ تم جلب الموقع! جاري الرفع للفايربيس...");
      await trackingRepo.updatePilgrimLocation(
        sessionId: sessionId,
        pilgrimId: pilgrimId,
        pilgrimName: pilgrimName,
        location: LatLng(initialPosition.latitude, initialPosition.longitude),
      );
      print("🚀 تم رفع الموقع الأولي للفايربيس بنجاح!");

      print("5️⃣ جاري بدء الاستماع للتحركات المستمرة...");
      final locationService = ref.read(locationServiceProvider);
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
        print("📍 تم تحديث موقع الحاج في الفايربيس بنجاح!");
      });

      state = const AsyncData(null);
    } catch (e, st) {
      print("❌ حدث خطأ (ربما انتهت المهلة أو تعذر الرفع): $e");
      state = AsyncError(e, st);
    }
  }
  // Future<void> acceptAndStartTracking({
  //   required int sessionId,
  //   required String pilgrimId,
  //   required String pilgrimName,
  // }) async {
  //   state = const AsyncLoading();
  //   try {
  //     final trackingApiRepo = ref.read(leaderTrackingApiRepositoryProvider);
  //     // 1. نرسل رقم 2 (موافق)
  //     await trackingApiRepo.respondToSession(sessionId, 2);

  //     // --- التعديل هنا: فحص الصلاحية ثم طلبها إن لزم الأمر ---
  //     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //     if (!serviceEnabled) {
  //       state = AsyncError("خدمة الموقع مغلقة في الهاتف.", StackTrace.current);
  //       return;
  //     }

  //     LocationPermission permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.denied) {
  //       permission = await Geolocator.requestPermission();
  //       if (permission == LocationPermission.denied) {
  //         state = AsyncError("صلاحية الموقع مرفوضة.", StackTrace.current);
  //         return;
  //       }
  //     }

  //     if (permission == LocationPermission.deniedForever) {
  //       state = AsyncError("صلاحية الموقع مرفوضة دائماً.", StackTrace.current);
  //       return;
  //     }
  //     // -----------------------------------------------------

  //     final trackingRepo = ref.read(trackingRepositoryProvider);

  //     // جلب الموقع الأولي ورفعه فوراً
  //     final initialPosition = await Geolocator.getCurrentPosition(
  //       locationSettings: const LocationSettings(
  //         accuracy: LocationAccuracy.high,
  //       ),
  //     );
  //     await trackingRepo.updatePilgrimLocation(
  //       sessionId: sessionId,
  //       pilgrimId: pilgrimId,
  //       pilgrimName: pilgrimName,
  //       location: LatLng(initialPosition.latitude, initialPosition.longitude),
  //     );
  //     print("🚀 تم رفع الموقع الأولي للفايربيس بنجاح!");

  //     // 3. بدء الاستماع لموقع الحاج والرفع للفايربيس عند التحرك
  //     final locationService = ref.read(locationServiceProvider);
  //     _positionStreamSub = locationService.positionStream.listen((
  //       Position position,
  //     ) {
  //       final currentPos = LatLng(position.latitude, position.longitude);

  //       trackingRepo.updatePilgrimLocation(
  //         sessionId: sessionId,
  //         pilgrimId: pilgrimId,
  //         pilgrimName: pilgrimName,
  //         location: currentPos,
  //       );
  //       print("📍 تم تحديث موقع الحاج في الفايربيس بنجاح!");
  //     });

  //     state = const AsyncData(null);
  //   } catch (e, st) {
  //     print("❌ حدث خطأ أثناء جلب الموقع أو الرفع لفايربيس: $e");
  //     state = AsyncError(e, st);
  //   }
  // }

  // 1. دالة الموافقة (نرسل رقم 2)
  // Future<void> acceptAndStartTracking({
  //   required int sessionId,
  //   required String pilgrimId,
  //   required String pilgrimName,
  // }) async {
  //   state = const AsyncLoading();
  //   try {
  //     final trackingApiRepo = ref.read(leaderTrackingApiRepositoryProvider);
  //     // نرسل رقم 2 (موافق)
  //     await trackingApiRepo.respondToSession(sessionId, 2);

  //     final locationService = ref.read(locationServiceProvider);
  //     final permission = await locationService.requestPermission();

  //     if (permission == LocationPermission.denied ||
  //         permission == LocationPermission.deniedForever) {
  //       state = AsyncError(
  //         "صلاحية الموقع مرفوضة، لا يمكن بدء التتبع.",
  //         StackTrace.current,
  //       );
  //       return;
  //     }
  //     final trackingRepo = ref.read(trackingRepositoryProvider);

  //     // --- الإضافة الجديدة: جلب الموقع الأولي ورفعه فوراً ---
  //     final initialPosition = await Geolocator.getCurrentPosition(
  //       locationSettings: const LocationSettings(
  //         accuracy: LocationAccuracy.high,
  //       ),
  //     );
  //     await trackingRepo.updatePilgrimLocation(
  //       sessionId: sessionId,
  //       pilgrimId: pilgrimId,
  //       pilgrimName: pilgrimName,
  //       location: LatLng(initialPosition.latitude, initialPosition.longitude),
  //     );
  //     print("🚀 تم رفع الموقع الأولي للفايربيس بنجاح!");
  //     // ----------------------------------------------------

  //     // 3. بدء الاستماع لموقع الحاج والرفع للفايربيس عند التحرك
  //     _positionStreamSub = locationService.positionStream.listen((
  //       Position position,
  //     ) {
  //       final currentPos = LatLng(position.latitude, position.longitude);

  //       trackingRepo.updatePilgrimLocation(
  //         sessionId: sessionId,
  //         pilgrimId: pilgrimId,
  //         pilgrimName: pilgrimName,
  //         location: currentPos,
  //       );
  //       print("📍 تم تحديث موقع الحاج في الفايربيس بنجاح!");
  //     });

  //     state = const AsyncData(null);
  //   } catch (e, st) {
  //     print(
  //       "❌ حدث خطأ أثناء جلب الموقع أو الرفع لفايربيس: $e",
  //     ); // أضفنا هذا السطر
  //     state = AsyncError(e, st);
  //   }
  // }

  // 2. دالة الرفض (نرسل رقم 3)
  Future<void> rejectSession({required int sessionId}) async {
    state = const AsyncLoading();
    try {
      final trackingApiRepo = ref.read(leaderTrackingApiRepositoryProvider);

      // نرسل رقم 3 (غير موافق)
      await trackingApiRepo.respondToSession(sessionId, 3);

      state = const AsyncData(null);
      print("❌ تم رفض الجلسة بنجاح وإبلاغ الخادم.");
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  // دالة لإيقاف التتبع (مثلاً إذا انتهت الجلسة)
  void stopTracking() {
    _positionStreamSub?.cancel();
    _positionStreamSub = null;
    print("🛑 تم إيقاف تتبع الحاج.");
  }
}
