import 'package:flutter/material.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/group/presentation/widgets/heart_status_icon.dart';

class PilgrimHealthCard extends StatelessWidget {
  final String healthStatus;
  final String? healthNote;

  const PilgrimHealthCard({
    super.key,
    required this.healthStatus,
    this.healthNote,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    // healthNote == null → health is stable
    final bool isStable = healthNote == null;
    final Color mainColor = isStable ? AppColor.success : AppColor.warning;
    final String tagText = isStable ? locale.healthStable : healthNote!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.withe,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          right: BorderSide(color: mainColor, width: 3.5),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            locale.healthStatus,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: AppColor.lightFontColor,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Heart icon on the RIGHT (leading in RTL) ──
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: mainColor.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Center(child: HeartStatusIcon(color: mainColor)),
              ),
              const SizedBox(width: 8),

              // ── Health status text ──
              Flexible(
                child: Text(
                  healthStatus,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textDark,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // ── Status tag on the LEFT (trailing in RTL) ──
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: mainColor.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  tagText,
                  style: TextStyle(
                    color: mainColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
