import 'package:flutter/material.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';

// ─────────────────────────────────────────────
//  Add Saudi Number Card (before state)
// ─────────────────────────────────────────────

class AddSaudiNumberCard extends StatelessWidget {
  final VoidCallback onTap;
  const AddSaudiNumberCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColor.lightBlack, AppColor.baseFontColor],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row: text + phone icon ──
          Row(
            children: [
              // Circle gold phone icon
              Container(
                width: 45,
                height: 45,
                decoration: const BoxDecoration(
                  color: AppColor.golden,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.phone_outlined, color: AppColor.baseFontColor, size: 20),
              ),
              const SizedBox(width: 12),
              // Texts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.locale.saudiMobileNumber,
                      style: const TextStyle(
                        color: AppColor.withe,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.locale.notAdded,
                      style: const TextStyle(
                        color: AppColor.lightFontColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ── Gold add button ──
          GestureDetector(
             onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColor.golden, AppColor.darkGolden],
                ),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.black.withValues(alpha: 0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '+',
                    style: TextStyle(
                      color: AppColor.baseFontColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    context.locale.addSaudiNumberAction,
                    style: const TextStyle(
                      color: AppColor.baseFontColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
