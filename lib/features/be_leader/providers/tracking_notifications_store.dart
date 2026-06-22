import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/common/providers/shared_preferences_service_provider.dart';
import 'package:yusr/core/services/shared_preferences_service.dart';
import 'package:yusr/core/constants/shared_preferences_keys.dart';
import 'package:yusr/features/be_leader/data/models/tracking_notification_model.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/extensions/context_extension.dart';

part 'tracking_notifications_store.g.dart';

/// مخزن تفاعلي في الذاكرة لإشعارات "كن قائد".
///
/// القاعدة:
///   [addNotification]            ← يُستدعى بجانب _notificationsPlugin.show()
///   [removeNotification]         ← يُستدعى بجانب _notificationsPlugin.cancel()
///   [loadPersistedInvite]        ← يُستدعى عند فتح التطبيق لاستعادة الدعوة المحفوظة
///   [clearSessionInvite]         ← يحذف بطاقة الدعوة من الذاكرة وSharedPreferences
@Riverpod(keepAlive: true)
class TrackingNotificationsStore extends _$TrackingNotificationsStore {
  @override
  List<TrackingNotificationModel> build() => [];

  SharedPreferencesService get _prefs =>
      ref.read(sharedPreferencesServiceProvider);

  // ═══════════════════════════════════════════════════════════════════════
  // العمليات
  // ═══════════════════════════════════════════════════════════════════════

  /// أضف أو حدِّث إشعاراً (يُستدعى مع show()).
  void addNotification(TrackingNotificationModel notification) {
    final filtered = state.where((n) => n.id != notification.id).toList();
    state = [...filtered, notification];
  }

  /// احذف إشعاراً بمعرّفه (يُستدعى مع cancel()).
  void removeNotification(String id) {
    if (!state.any((n) => n.id == id)) return;
    state = state.where((n) => n.id != id).toList();
  }

  /// قراءة الدعوة المحفوظة من SharedPreferences عند فتح التطبيق.
  Future<void> loadPersistedInvite() async {
    final sessionIdStr = await _prefs.getString(
      SharedPreferencesKeys.pendingTrackingSessionId,
    );
    final body = await _prefs.getString(
      SharedPreferencesKeys.pendingTrackingBody,
    );

    final sessionId = int.tryParse(sessionIdStr ?? '0') ?? 0;
    if (sessionId <= 0 || body == null) {
      // 💡 المزامنة الصحيحة: إذا كانت الدعوة غير موجودة في الذاكرة الدائمة (ربما تم مسحها في الخلفية)،
      // يجب أن نزيلها من الذاكرة المؤقتة (RAM) أيضاً لكي تختفي النقطة الحمراء.
      state = state
          .where((n) => n.type != TrackingNotificationType.sessionInvite)
          .toList();
      return;
    }

    // تجنّب إضافة نسخة مكررة إذا كانت موجودة في الذاكرة بالفعل
    final alreadyExists = state.any(
      (n) =>
          n.type == TrackingNotificationType.sessionInvite &&
          n.sessionId == sessionId,
    );
    if (alreadyExists) return;

    addNotification(
      TrackingNotificationModel(
        id: 'session_invite_$sessionId',
        title:
            navigatorKey.currentContext?.locale.locationRequestTitle ??
            '📍 طلب مشاركة الموقع',
        body: body,
        timestamp: DateTime.now().toIso8601String(),
        type: TrackingNotificationType.sessionInvite,
        sessionId: sessionId,
      ),
    );
  }

  /// احذف بطاقة الدعوة من الذاكرة و SharedPreferences معاً.
  /// يُستدعى عند انتهاء الجلسة أو مؤقت الـ 30 دقيقة.
  Future<void> clearSessionInvite() async {
    state = state
        .where((n) => n.type != TrackingNotificationType.sessionInvite)
        .toList();
    await _prefs.removeKey(SharedPreferencesKeys.sessionId);
    await _prefs.removeKey(SharedPreferencesKeys.pendingTrackingSessionId);
    await _prefs.removeKey(SharedPreferencesKeys.pendingTrackingBody);
  }

  /// احذف كل إشعارات جلسة معينة دفعة واحدة (عند tracking_session_ended).
  Future<void> clearBySessionId(int sessionId) async {
    state = state.where((n) => n.sessionId != sessionId).toList();
    await _prefs.removeKey(SharedPreferencesKeys.sessionId);
    await _prefs.removeKey(SharedPreferencesKeys.pendingTrackingSessionId);
    await _prefs.removeKey(SharedPreferencesKeys.pendingTrackingBody);
  }

  /// مسح كامل (تسجيل خروج) — لا يمسح SharedPreferences (الجلسة تستمر).
  void clearAll() {
    state = [];
  }
}
