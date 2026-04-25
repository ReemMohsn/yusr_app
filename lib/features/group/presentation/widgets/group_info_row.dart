import 'package:flutter/material.dart';
import 'package:yusr/core/constants/app_color.dart';

/// A single info row card used inside group info sections.
///
/// When [isGold] is true the card gets a warm golden gradient background
/// (used for the primary field, e.g. group name or supervisor name).
class GroupInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isGold;

  const GroupInfoRow({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.isGold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isGold ? null : AppColor.withe,
        gradient: isGold
            ? const LinearGradient(
                colors: [
                  AppColor.highlightBackground1,
                  AppColor.highlightBackground2,
                  AppColor.highlightBackground3,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isGold
              ? AppColor.goldenWithOpacity
              : AppColor.inputFieldBoundaries,
          width: 0.7,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // ── Icon container ──
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isGold ? null : AppColor.baseFontColor,
              gradient: isGold
                  ? const LinearGradient(
                      colors: [AppColor.golden, AppColor.goldDark],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )
                  : null,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColor.withe, size: 18),
          ),
          const SizedBox(width: 12),
          // ── Label + value ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColor.textGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColor.textDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
