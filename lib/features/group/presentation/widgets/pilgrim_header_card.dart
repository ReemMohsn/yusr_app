import 'package:flutter/material.dart';
import 'package:yusr/core/constants/app_color.dart';

/// Top card on the Pilgrim Details screen showing the pilgrim's
/// full name and job title with a golden gradient accent bar.
class PilgrimHeaderCard extends StatelessWidget {
  final String fullName;
  final String jobTitle;

  const PilgrimHeaderCard({
    super.key,
    required this.fullName,
    required this.jobTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.withe,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // ── Golden gradient top bar ──
          Container(
            height: 4,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColor.golden, AppColor.lightGolden, AppColor.golden],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                Text(
                  fullName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  jobTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColor.midlineColor,
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
