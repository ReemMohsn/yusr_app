import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/common/providers/shared_preferences_service_provider.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/be_leader/providers/pilgrim_tracking_controller.dart';

class PilgrimStopTrackingFab extends ConsumerWidget {
  final int sessionId;

  const PilgrimStopTrackingFab({super.key, required this.sessionId});

  Future<void> _showStopTrackingDialog(
    BuildContext context,
    WidgetRef ref,
    String pilgrimId,
  ) async {
    final locale = context.locale;
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            title: Text(
              locale.stopTracking,
              style: const TextStyle(color: Colors.red),
            ),
            content: Text(locale.stopTrackingConfirmMsg),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(
                  locale.cancel,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(
                  locale.yesStop,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );

    if (confirm == true && context.mounted) {
      await ref
          .read(pilgrimTrackingControllerProvider.notifier)
          .leaveAndStopTracking(
            sessionId: sessionId,
            pilgrimId: pilgrimId,
          );
      if (context.mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale;
    return FutureBuilder(
      future: ref.read(sharedPreferencesServiceProvider).getProfile(),
      builder: (context, snapshot) {
        final profile = snapshot.data;
        return FloatingActionButton.extended(
          heroTag: 'stop_tracking_pilgrim',
          backgroundColor: Colors.red,
          icon: const Icon(Icons.stop),
          label: Text(locale.stopTracking),
          onPressed: () {
            if (profile?.userId != null) {
              _showStopTrackingDialog(
                context,
                ref,
                profile!.userId.toString(),
              );
            }
          },
        );
      },
    );
  }
}
