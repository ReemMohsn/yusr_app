import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/be_leader/providers/pilgrim_tracking_controller.dart';

class PilgrimMuteAlarmButton extends ConsumerWidget {
  const PilgrimMuteAlarmButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale;
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade800,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
        elevation: 6,
      ),
      icon: const Icon(Icons.volume_off),
      label: Text(
        locale.muteAlarmTemporarily,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
      ),
      onPressed: () {
        ref
            .read(pilgrimTrackingControllerProvider.notifier)
            .stopAlarmManual(isUserAction: true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(locale.alarmMutedPilgrimMsg),
            backgroundColor: Colors.black87,
            duration: const Duration(seconds: 3),
          ),
        );
      },
    );
  }
}
