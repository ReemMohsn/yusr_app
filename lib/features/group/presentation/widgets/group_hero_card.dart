import 'package:flutter/material.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';

// ─────────────────────────────────────────────
//  Stat Tile (internal)
// ─────────────────────────────────────────────

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.withe.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColor.withe.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColor.golden, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: AppColor.withe.withValues(alpha: 0.7),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: AppColor.withe,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Group Hero Card (public)
// ─────────────────────────────────────────────

/// A dark gradient hero card displayed at the top of [GroupInfoView].
///
/// Shows the [groupName], [pilgrimsCount], and [supervisorName] as stat tiles.
class GroupHeroCard extends StatelessWidget {
  final String groupName;
  final String pilgrimsCount;
  final String supervisorName;

  const GroupHeroCard({
    super.key,
    required this.groupName,
    required this.pilgrimsCount,
    required this.supervisorName,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColor.baseFontColor,
            AppColor.dark2,
            AppColor.baseFontColor,
          ],
          stops: [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColor.golden.withValues(alpha: 0.3),
          width: 0.7,
        ),
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
          const SizedBox(height: 24),

          // ── Gold groups icon ──
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColor.golden, AppColor.goldDark],
              ),
              border: Border.all(
                color: AppColor.withe.withValues(alpha: 0.22),
                width: 3.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColor.black.withValues(alpha: 0.18),
                  blurRadius: 15,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.groups,
              color: AppColor.baseFontColor,
              size: 40,
            ),
          ),

          const SizedBox(height: 16),

          // ── Group name ──
          Text(
            groupName,
            style: const TextStyle(
              color: AppColor.withe,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // ── Stat row ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                _StatTile(
                  label: locale.pilgrimsCount,
                  value: pilgrimsCount,
                  icon: Icons.groups,
                ),
                const SizedBox(width: 16),
                _StatTile(
                  label: locale.supervisorName,
                  value: supervisorName,
                  icon: Icons.person,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
