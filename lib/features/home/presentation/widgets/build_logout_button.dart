import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/auth/providers/logout_controller_provider.dart';
import 'package:yusr/core/common/providers/shared_preferences_service_provider.dart';
import 'package:yusr/core/constants/shared_preferences_keys.dart';

class BuildLogoutButton extends StatelessWidget {
  const BuildLogoutButton({
    super.key,
    required this.context,
    required this.ref,
  });

  final BuildContext context;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    return InkWell(
      onTap: () async {
        final shouldLogout = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(locale.logout),
            content: const Text("هل أنت متأكد من رغبتك في تسجيل الخروج؟"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text("إلغاء"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text("تأكيد", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );

        if (shouldLogout != true) return;

        // التحقق من وجود جلسة نشطة
        final sharedPrefs = ref.read(sharedPreferencesServiceProvider);
        final activeSessionId = await sharedPrefs.getInt(
          SharedPreferencesKeys.currentSessionId,
        );

        if (activeSessionId != null && activeSessionId > 0) {
          if (!context.mounted) return;
          showDialog(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: const Text("تنبيه"),
              content: const Text(
                "توجد جلسة نشطة حالياً. إذا كنت تريد تسجيل الخروج، قم أولاً بإيقاف تلك الجلسة.",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text("حسناً"),
                ),
              ],
            ),
          );
          return; // منع تسجيل الخروج
        }

        if (!context.mounted) return;
        ref.read(logoutControllerProvider.notifier).logout();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        color: const Color(0xFF2C2C2C),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Colors.redAccent, size: 20),
            SizedBox(width: 10),
            Text(
              locale.logout, // "تسجيل الخروج",
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
