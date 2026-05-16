import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/be_leader/providers/leader_tracking_controller.dart';

class LeaderEndSessionFab extends ConsumerWidget {
  const LeaderEndSessionFab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale;
    return FloatingActionButton.extended(
      heroTag: 'stop_session_unique_tag',
      backgroundColor: Colors.red,
      icon: const Icon(Icons.stop),
      label: Text(locale.endSessionOfficially),
      onPressed: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(locale.endSession),
            content: Text(locale.confirmEndSessionMsg),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(locale.cancel),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () => Navigator.pop(context, true),
                child: Text(locale.confirmEnd),
              ),
            ],
          ),
        );
        if (confirm == true) {
          ref
              .read(stopLeaderSessionControllerProvider.notifier)
              .stopSession();
        }
      },
    );
  }
}
