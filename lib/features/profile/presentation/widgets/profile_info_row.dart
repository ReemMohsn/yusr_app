import 'package:flutter/material.dart';
import 'package:yusr/core/constants/app_color.dart';

// ─────────────────────────────────────────────
//  Icon Box Helpers
// ─────────────────────────────────────────────

class _GoldIconBox extends StatelessWidget {
  final IconData icon;
  const _GoldIconBox({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColor.golden, AppColor.darkGolden],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }
}

class _DarkIconBox extends StatelessWidget {
  final IconData icon;
  const _DarkIconBox({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColor.baseFontColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: AppColor.golden, size: 18),
    );
  }
}

// ─────────────────────────────────────────────
//  Shared Internal Row
// ─────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget iconWidget;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.iconWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        iconWidget,
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: AppColor.textGrey, fontSize: 12),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                  color: AppColor.textDark,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  Public Widgets
// ─────────────────────────────────────────────

class ProfileHighlightedInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const ProfileHighlightedInfoRow({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0.4, -1),
          end: const Alignment(-0.4, 1),
          colors: [
            const Color(0xFFFFFBEB),
            const Color(0xFFFEFCE8).withValues(alpha: 0.8),
            const Color(0xFFFFF7ED).withValues(alpha: 0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColor.golden.withValues(alpha: 0.4), width: 0.7),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: _InfoRow(label: label, value: value, iconWidget: _GoldIconBox(icon: icon)),
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool highlighted;

  const ProfileInfoRow({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    if (highlighted) {
      return ProfileHighlightedInfoRow(label: label, value: value, icon: icon);
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: _InfoRow(label: label, value: value, iconWidget: _DarkIconBox(icon: icon)),
    );
  }
}
