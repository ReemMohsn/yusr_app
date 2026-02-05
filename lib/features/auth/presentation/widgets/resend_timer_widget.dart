import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/features/auth/providers/resend_timer_controller_provider.dart';

class ResendTimerWidget extends ConsumerWidget {
  final Future<void> Function() onResend;

  const ResendTimerWidget({super.key, required this.onResend});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // مراقبة الوقت المتبقي
    final timeLeft = ref.watch(resendTimerControllerProvider);

    // إذا كان الوقت 0، نعرض زر إعادة الإرسال
    final isResendButtonActive = timeLeft == 0;

    return isResendButtonActive
        ? TextButton(
            onPressed: () async {
              // 1. بدء المؤقت فوراً حتى لا ينتظر استجابة الـ API
              ref.read(resendTimerControllerProvider.notifier).startTimer();

              // 2. استدعاء دالة إعادة الإرسال الخارجية
              await onResend();
            },
            child: const Text(
              "إعادة إرسال الكود",
              style: TextStyle(
                fontSize: 15,
                color: AppColor.golden, // تم التعديل حسب ألوان مشروعك
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : Text(
            "إعادة إرسال الكود في 00:${timeLeft.toString().padLeft(2, '0')}",
            style: const TextStyle(
              fontSize: 15,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          );
  }
}
