import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yusr/core/constants/shared_preferences_keys.dart';
import 'package:yusr/features/be_leader/data/models/tracking_notification_model.dart';
import 'package:yusr/features/be_leader/presentation/services/tracking_strings.dart';

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
  /// تُستدعى مرة واحدة فقط من [MainHomeView.initState].
  Future<void> loadPersistedInvite() async {
    final prefs = SharedPreferencesAsync();
    final sessionIdStr = await prefs.getString(
      SharedPreferencesKeys.pendingTrackingSessionId,
    );
    final body = await prefs.getString(
      SharedPreferencesKeys.pendingTrackingBody,
    );

    final sessionId = int.tryParse(sessionIdStr ?? '0') ?? 0;
    if (sessionId <= 0 || body == null) return;

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
        title: TrackingStrings.locationRequestTitle,
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
    final prefs = SharedPreferencesAsync();
    await prefs.remove(SharedPreferencesKeys.pendingTrackingSessionId);
    await prefs.remove(SharedPreferencesKeys.pendingTrackingBody);
  }

  /// احذف كل إشعارات جلسة معينة دفعة واحدة (عند tracking_session_ended).
  Future<void> clearBySessionId(int sessionId) async {
    state = state.where((n) => n.sessionId != sessionId).toList();
    final prefs = SharedPreferencesAsync();
    await prefs.remove(SharedPreferencesKeys.pendingTrackingSessionId);
    await prefs.remove(SharedPreferencesKeys.pendingTrackingBody);
  }

  /// مسح كامل (تسجيل خروج) — لا يمسح SharedPreferences (الجلسة تستمر).
  void clearAll() {
    state = [];
  }
}
