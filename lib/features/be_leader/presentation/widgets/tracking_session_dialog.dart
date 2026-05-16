import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/constants/app_route.dart' show AppRoute, navigatorKey;
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/be_leader/providers/pilgrim_tracking_controller.dart';
import 'package:yusr/features/home/providers/user_provider.dart';

/// دايلوج موحّد لطلب الانضمام لجلسة التتبع.
///
/// يُستخدَم في:
///   - [PushNotificationService._showTrackingAcceptDialog] — عند وصول FCM
///   - [TrackingNotificationCard] — عند الضغط على بطاقة الدعوة في الواجهة
///
/// السلوك:
///   - رفض  → يُخطر الـ API ويُغلق الدايلوج. الدعوة تبقى في الواجهة.
///   - قبول → يبدأ التتبع وينتقل للخريطة. زر الانضمام يتحول "جاري التتبع".
class TrackingSessionDialog extends ConsumerWidget {
  final int sessionId;
  final String notificationBody;

  const TrackingSessionDialog({
    super.key,
    required this.sessionId,
    required this.notificationBody,
  });

  /// مساعدة: يفتح الدايلوج من أي [BuildContext]
  static void show(
    BuildContext context, {
    required int sessionId,
    required String notificationBody,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => TrackingSessionDialog(
        sessionId: sessionId,
        notificationBody: notificationBody,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale;
    ref.listen(respondToTrackingSessionControllerProvider, (_, state) {
      if (state.isLoading) {
        context.showLoadingDialog();
      } else if (state.hasError) {
        context.closeLoadingDialog();
        context.showErrorSnackBar(state.error.toString().replaceAll('Exception: ', ''));
      } else if (state.hasValue && state.value != '') {
        context.closeLoadingDialog();
        Navigator.pop(context);

        if (state.value == 'accepted') {
          context.showSuccessSnackBar(locale.inviteAcceptedMsg);
          navigatorKey.currentState?.pushNamed(
            AppRoute.pilgrimMapTrackingView,
            arguments: sessionId,
          );
        } else if (state.value == 'rejected') {
          context.showSuccessSnackBar(locale.inviteRejectedMsg);
        }
      }
    });

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          const Icon(Icons.location_on, color: AppColor.golden),
          const SizedBox(width: 8),
          Text(locale.locationRequestDialogTitle,
              style: const TextStyle(fontSize: 16)),
        ],
      ),
      content: Text(notificationBody),
      actions: [
        // ─── رفض: الدعوة تبقى — يقدر يرجع ينضم لاحقاً ───
        TextButton(
          onPressed: () {
            ref
                .read(respondToTrackingSessionControllerProvider.notifier)
                .rejectSession(sessionId: sessionId);
          },
          child: Text(locale.dialogReject,
              style: const TextStyle(color: Colors.red)),
        ),
        // ─── قبول: يبدأ التتبع والزر يتحول لـ "جاري التتبع" تلقائياً ───
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColor.golden),
          onPressed: () {
            final profile = ref.read(userProfileProvider).value;
            if (profile != null) {
              ref
                  .read(respondToTrackingSessionControllerProvider.notifier)
                  .acceptSession(
                    sessionId: sessionId,
                    pilgrimId: profile.userId.toString(),
                    pilgrimName: profile.fullName,
                  );
            }
          },
          child: Text(locale.dialogAccept,
              style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
