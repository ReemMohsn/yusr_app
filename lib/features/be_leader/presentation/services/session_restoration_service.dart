import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/common/providers/shared_preferences_service_provider.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/constants/shared_preferences_keys.dart';
import 'package:yusr/core/services/shared_preferences_service.dart';
import 'package:yusr/features/be_leader/providers/active_session_id_provider.dart';
import 'package:yusr/features/be_leader/providers/pilgrim_tracking_controller.dart';
import 'package:yusr/features/be_leader/providers/pilgrims_list_provider.dart';
import 'package:yusr/features/be_leader/providers/tracking_notifications_store.dart';
import 'package:yusr/features/be_leader/providers/tracking_repository_provider.dart';

class SessionRestorationService {
  final Ref ref;

  SessionRestorationService(this.ref);

  SharedPreferencesService get _prefsService => ref.read(sharedPreferencesServiceProvider);

  /// تهيئة [activeSessionIdProvider] من SharedPreferences.
  /// في حالة الجلسة غير موجودة في الخادم → نوقف التتبع ونمسح كل شيء فوراً ثم نرجع.
  /// في حالة اعتيادية → نقرأ sessionId ونحدّث المزود.
  Future<void> initActiveSession() async {
    final sessionId = await _prefsService.getInt(SharedPreferencesKeys.currentSessionId) ?? 0;

    if (sessionId > 0) {
      // 🔵 التحقق الفعلي من Firebase هل الجلسة ما زالت موجودة؟
      final exists = await ref.read(trackingRepositoryProvider).checkSessionExists(sessionId);
      
      if (!exists) {
        debugPrint('🚩 [SessionRestoration] الجلسة ($sessionId) محذوفة من الخادم → تنظيف الذاكرة');
        
        // تنظيف الذاكرة وإغلاق التتبع
        ref.read(pilgrimTrackingControllerProvider.notifier).stopTracking();
        await ref.read(trackingNotificationsStoreProvider.notifier).clearSessionInvite();
        
        // العودة للرئيسية إن كانت الخريطة مفتوحة
        navigatorKey.currentState?.popUntil((route) {
          return route.settings.name == AppRoute.mainHomeView || route.isFirst;
        });
        return;
      }

      // الجلسة موجودة وصحيحة
      ref.read(activeSessionIdProvider.notifier).updateSessionId(sessionId);
      ref.invalidate(pilgrimsListProvider(sessionId));
    } else {
      ref.read(activeSessionIdProvider.notifier).updateSessionId(0);
    }
  }

  /// فحص وجود دعوة جلسة معلقة وعرض إشعار لها.
  Future<void> restorePendingInvite() async {
    // تحميل الدعوة للذاكرة (لتظهر في واجهة الإشعارات)
    await ref
        .read(trackingNotificationsStoreProvider.notifier)
        .loadPersistedInvite();

    // فحص وجود دعوة معلقة من SharedPreferencesService (والذي يستخدم النسخة الحديثة Async مباشرة)
    final sessionIdStr = await _prefsService.getString(
      SharedPreferencesKeys.pendingTrackingSessionId,
    );
    final body = await _prefsService.getString(
      SharedPreferencesKeys.pendingTrackingBody,
    );
    final sessionId = int.tryParse(sessionIdStr ?? '0') ?? 0;

    if (sessionId > 0 && body != null) {
      // 🔵 التحقق الفعلي من Firebase هل الجلسة ما زالت قائمة قبل إبقاء الدعوة؟
      final exists = await ref.read(trackingRepositoryProvider).checkSessionExists(sessionId);
      
      if (!exists) {
        debugPrint('📨 [SessionRestoration] الدعوة المعلقة للجلسة ($sessionId) أصبحت ملغاة من الخادم → سيتم مسحها');
        await ref.read(trackingNotificationsStoreProvider.notifier).clearSessionInvite();
        return;
      }
      
      // الجلسة موجودة وصالحة
      debugPrint('📨 [SessionRestoration] دعوة معلقة موجودة وصالحة (session=$sessionId) → محفوظة في الإشعارات');
    }
  }
}
