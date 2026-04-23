import 'package:flutter/material.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';

class ImportanceInfoCard extends StatelessWidget {
  const ImportanceInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(0.4, -1),
          end: Alignment(-0.6, 1),
          colors: [AppColor.highlightBackground1, AppColor.highlightBackground3],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.golden.withValues(alpha: 0.30), width: 0.7),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.10),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.06),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Top row: Icon (right) + text (left) ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info icon — rendered first = right side in RTL
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColor.golden, AppColor.goldDark],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.info_outline_rounded,
                  color: AppColor.withe,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locale.saudiPhoneImportance,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColor.baseFontColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      locale.saudiPhoneImportanceDesc,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColor.textGrey,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // ── Star label — right-aligned ──
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.star, color: AppColor.golden, size: 14),
              const SizedBox(width: 8),
              Text(
                locale.localSADialTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: AppColor.lightFontColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
