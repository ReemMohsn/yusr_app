import 'package:flutter/material.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/features/group/presentation/widgets/heart_status_icon.dart';

/// A single pilgrim row card used in the supervisor's group details screen.
class PilgrimListCard extends StatelessWidget {
  final String name;

  /// Health status color — use [AppColor.success] for good, [AppColor.warning]
  /// for pending. Defaults to [AppColor.success].
  final Color statusColor;

  /// Called when the chevron button is tapped.
  final VoidCallback? onTap;

  const PilgrimListCard({
    super.key,
    required this.name,
    this.statusColor = AppColor.success,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSize.paddingOfPage),
        decoration: BoxDecoration(
          color: AppColor.withe,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Gold left-accent bar ──
            Container(
              width: 4,
              height: 56,
              decoration: BoxDecoration(
                color: AppColor.golden,
                borderRadius: BorderRadius.circular(100),
              ),
            ),

            const SizedBox(width: 16),

            // ── Name + health icon ──
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: AppColor.textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  HeartStatusIcon(color: statusColor),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // ── Chevron button ──
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColor.golden.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.chevron_right,
                  color: AppColor.golden,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
