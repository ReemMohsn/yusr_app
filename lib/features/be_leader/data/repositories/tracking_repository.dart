import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

class TrackingRepository {
  final Ref ref;
  // final FirebaseDatabase _db = FirebaseDatabase.instance;
  final FirebaseDatabase _db = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://yusr-applicatin-default-rtdb.europe-west1.firebasedatabase.app',
  );
  TrackingRepository(this.ref);

  // ==========================================
  // دوال الكتابة (Write Methods) - لا تحتاج إلى Stream
  // ==========================================

  /// 1. تحديث موقع المشرف
  Future<void> updateLeaderLocation({
    required String sessionId,
    required LatLng location,
    required double heading,
  }) async {
    try {
      await _db.ref('TrackingSessions/$sessionId/leaderLocation').update({
        'latitude': location.latitude,
        'longitude': location.longitude,
        'heading': heading,
        'lastUpdate': ServerValue.timestamp,
      });
    } catch (e) {
      // هنا يمكنك تسجيل الخطأ أو إرساله لخدمة تتبع الأخطاء
      throw Exception("فشل في تحديث موقع المشرف: $e");
    }
  }

  // 2. دالة جديدة صغيرة: لختم الجلسة فوراً عند البدء
  Future<void> initLeaderSession(String sessionId) async {
    try {
      // 🌟 التعديل هنا: استخدام المسار العميق من العقدة الأب مباشرة
      await _db.ref('TrackingSessions/$sessionId').update({
        'leaderLocation/lastUpdate': ServerValue.timestamp,
      });

      debugPrint(
        "✅ تم إرسال وقت المشرف  الأولي قبل البدأ في إرسال موقعه بنجاح للفايربيس!",
      );
    } catch (e) {
      debugPrint(" ❌ فشل إرسال وقت المشرف للفايربيس: $e");
    }
  }

  /// 2. تحديث موقع الحاج.
  /// [isRealMove] — إذا true: موقع جديد فعلي → يُحدِّث lastPositionUpdate.
  ///                إذا false: نبضة حياة بالموقع القديم → يُحدِّث lastUpdate فقط (heartbeat).
  Future<void> updatePilgrimLocation({
    required int sessionId,
    required String pilgrimId,
    required String pilgrimName,
    required LatLng location,
    bool isRealMove = false,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'name': pilgrimName,
        'latitude': location.latitude,
        'longitude': location.longitude,
        'lastUpdate': ServerValue.timestamp, // ← heartbeat: هاتف الحاج متصل
      };
      if (isRealMove) {
        // موقع جديد فعلي → أخبر المشرف بآخر حركة حقيقية
        data['lastPositionUpdate'] = ServerValue.timestamp;
      }
      await _db.ref('TrackingSessions/$sessionId/pilgrims/$pilgrimId').update(
        data,
      );
    } catch (e) {
      throw Exception('فشل في تحديث موقع الحاج: $e');
    }
  }

  /// تحديث "صك الأمان" للحاج + مسافة BLE (يُستدعى بواسطة المشرف عندما يلتقط الحاج عبر البلوتوث).
  /// [bleDistance] — المسافة المقدَّرة بالمتر من البلوتوث، تُعرض في واجهة الحاج بدلاً من GPS.
  Future<void> updatePilgrimSafeFlag(
    String sessionId,
    String pilgrimId,
    bool isSafe, {
    double? bleDistance,
  }) async {
    try {
      final Map<String, dynamic> data = {'isSafeByBle': isSafe};
      if (isSafe && bleDistance != null) {
        data['bleDistance'] = double.parse(bleDistance.toStringAsFixed(1));
      } else if (!isSafe) {
        data['bleDistance'] = null; // يُزيل الحقل عندما يبتعد الحاج
      }
      await _db.ref('TrackingSessions/$sessionId/pilgrims/$pilgrimId').update(
        data,
      );
    } catch (e) {
      debugPrint('❌ فشل في تحديث حالة الأمان للحاج: $e');
    }
  }

  /// 3. إغلاق الجلسة وحذفها من فايربيس
  Future<void> deleteSession(String sessionId) async {
    try {
      await _db.ref('TrackingSessions/$sessionId').remove();
    } catch (e) {
      throw Exception("فشل في حذف الجلسة من فايربيس: $e");
    }
  }

  // ==========================================
  // دوال القراءة المستمرة (Read Streams)
  // ==========================================

  /// 4. الاستماع اللحظي لمواقع جميع الحجاج داخل الجلسة
  Stream<DatabaseEvent> pilgrimsStream(String sessionId) {
    return _db.ref('TrackingSessions/$sessionId/pilgrims').onValue;
  }

  /// الاستماع اللحظي لبيانات حاج واحد معين (يُستدعى بواسطة الحاج نفسه لقراءة صك الأمان)
  Stream<DatabaseEvent> pilgrimStream(String sessionId, String pilgrimId) {
    return _db.ref('TrackingSessions/$sessionId/pilgrims/$pilgrimId').onValue;
  }

  /// 5. الاستماع اللحظي لموقع المشرف
  Stream<DatabaseEvent> leaderStream(String sessionId) {
    return _db.ref('TrackingSessions/$sessionId/leaderLocation').onValue;
  }

  /// حذف الحاج من الجلسة عند إيقاف التتبع
  Future<void> removePilgrimFromSession({
    required String sessionId,
    required String pilgrimId,
  }) async {
    try {
      await _db.ref('TrackingSessions/$sessionId/pilgrims/$pilgrimId').remove();
    } catch (e) {
      throw Exception("فشل في حذف الحاج من الفايربيس: $e");
    }
  }

  // دالة لجلب وقت آخر تحديث للمشرف (بالميلي ثانية)
  Future<int?> getLeaderLastUpdate(String sessionId) async {
    try {
      final snapshot = await _db
          .ref('TrackingSessions/$sessionId/leaderLocation/lastUpdate')
          .get();
      if (snapshot.exists) {
        return snapshot.value as int; // الفايربيس يحفظ الـ timestamp كـ int
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
