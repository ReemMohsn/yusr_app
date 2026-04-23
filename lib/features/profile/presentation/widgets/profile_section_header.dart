import 'package:flutter/material.dart';
import 'package:yusr/core/constants/app_color.dart';

/// Clean section title — thin gold pill accent beside the text, no box/fill.
class ProfileSectionHeader extends StatelessWidget {
  final String title;
  const ProfileSectionHeader(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Thin gold vertical pill — purely decorative accent
        Container(
          width: 3,
          height: 18,
          decoration: BoxDecoration(
            color: AppColor.golden,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: AppColor.baseFontColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
