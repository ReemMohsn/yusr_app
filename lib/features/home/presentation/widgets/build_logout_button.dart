import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/features/auth/providers/logout_controller_provider.dart';

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
    return InkWell(
      onTap: () async {
        ref.read(logoutControllerProvider.notifier).logout();
        // Navigator.of(context).pushNamed(AppRoute.loginView);
        // // ref.invalidate(userProfileProvider);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        color: const Color(0xFF2C2C2C),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.logout, color: Colors.redAccent, size: 20),
            SizedBox(width: 10),
            Text(
              "تسجيل الخروج",
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
