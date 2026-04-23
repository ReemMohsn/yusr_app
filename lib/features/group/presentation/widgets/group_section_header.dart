import 'package:flutter/material.dart';
import 'package:yusr/core/constants/app_color.dart';

/// A section header with a golden left-accent bar and bold title text.
/// Used in [GroupInfoView] to separate info sections.
class GroupSectionHeader extends StatelessWidget {
  final String title;

  const GroupSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 25,
            decoration: BoxDecoration(
              color: AppColor.golden,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: AppColor.baseFontColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
