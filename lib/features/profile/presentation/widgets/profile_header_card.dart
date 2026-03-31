import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/common/providers/shared_preferences_service_provider.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:hijri/hijri_calendar.dart';

// ─── Role helper (mirrors the one in profile_view.dart) ──────────────────────────────
bool _isHajjRole(String rawRole) {
  final lower = rawRole.toLowerCase();
  return lower == 'user' || lower == 'hajj' ||
      rawRole == 'مستخدم' || rawRole == 'حاج' || rawRole.isEmpty;
}

class ProfileHeaderCard extends ConsumerWidget {
  final String fullName;

  const ProfileHeaderCard({
    super.key,
    required this.fullName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sharedPrefs = ref.watch(sharedPreferencesServiceProvider);

    return FutureBuilder(
      future: sharedPrefs.getProfile(),
      builder: (context, snapshot) {
        final localProfile = snapshot.data;
        final identifier = localProfile?.identifier ?? '';
        final rawRole = localProfile?.userRole ?? context.locale.userRole;
        final displayRole = _isHajjRole(rawRole) ? 'حاج' : rawRole;

        final currentHijriYear = HijriCalendar.now().hYear;
        final userRole = '$displayRole - حملة $currentHijriYearهـ';
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 28, 16, 24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColor.baseFontColor, AppColor.dark2, AppColor.baseFontColor],
              stops: [0.0, 0.5, 1.0],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColor.golden.withValues(alpha: 0.3), width: 0.7),
            boxShadow: [
              BoxShadow(
                color: AppColor.black.withValues(alpha: 0.18),
                blurRadius: 25,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            children: [
              // ── Avatar ──
              Container(
                width: 106,
                height: 106,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColor.golden, AppColor.darkGolden],
                  ),
                  border: Border.all(color: AppColor.withe.withValues(alpha: 0.22), width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.black.withValues(alpha: 0.18),
                      blurRadius: 14,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    fullName.isNotEmpty ? fullName.characters.first : 'م',
                    style: const TextStyle(
                      color: AppColor.withe,
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // ── Full name ──
              Text(
                fullName,
                style: const TextStyle(
                  color: AppColor.withe,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 6),

              // ── Username ──
              Text(
                identifier,
                style: TextStyle(
                  color: AppColor.withe.withValues(alpha: 0.6),
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 18),

              // ── Badge ──
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColor.highlightBackground1, AppColor.highlightBackground2],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColor.golden.withValues(alpha: 0.4), width: 0.7),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.black.withValues(alpha: 0.1),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Text(
                  userRole,
                  style: const TextStyle(
                    color: AppColor.baseFontColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
