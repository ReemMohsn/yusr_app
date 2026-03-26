import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
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
      });
    } catch (e) {
      // هنا يمكنك تسجيل الخطأ أو إرساله لخدمة تتبع الأخطاء
      throw Exception("فشل في تحديث موقع المشرف: $e");
    }
  }

  /// 2. تحديث موقع الحاج
  Future<void> updatePilgrimLocation({
    required int sessionId,
    required String pilgrimId,
    required String pilgrimName,
    required LatLng location,
  }) async {
    try {
      await _db.ref('TrackingSessions/$sessionId/pilgrims/$pilgrimId').update({
        'name': pilgrimName,
        'latitude': location.latitude,
        'longitude': location.longitude,
        'lastUpdate': ServerValue.timestamp,
      });
    } catch (e) {
      throw Exception("فشل في تحديث موقع الحاج: $e");
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

  /// 5. الاستماع اللحظي لموقع المشرف
  Stream<DatabaseEvent> leaderStream(String sessionId) {
    return _db.ref('TrackingSessions/$sessionId/leaderLocation').onValue;
  }
}
