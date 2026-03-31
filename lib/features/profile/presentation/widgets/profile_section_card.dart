import 'package:flutter/material.dart';
import 'package:yusr/core/constants/app_color.dart';

/// Clean section title — thin gold pill accent beside the text, no box/fill.
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

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

/// White card wrapper with a section header
class ProfileSectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const ProfileSectionCard({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.withe,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.inputFieldBoundaries, width: 0.7),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // ── Header ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
            child: Align(
              alignment: Alignment.centerRight,
              child: _SectionHeader(title),
            ),
          ),
          // ── Content ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}
