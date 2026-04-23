import 'package:flutter/material.dart';
import 'package:yusr/core/constants/app_color.dart';

/// A pill-shaped tag used in the supervisor group screen to show
/// group name / member count at a glance.
class GroupFilterPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const GroupFilterPill({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppColor.withe,
        borderRadius: BorderRadius.circular(100),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 15,
            offset: Offset(0, 10),
          ),
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColor.golden, size: 24),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppColor.textDark,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
