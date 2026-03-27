import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';

// ─────────────────────────────────────────────
//  Shared Contact Card
// ─────────────────────────────────────────────

class ProfileContactRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool showDelete;
  final bool showEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const ProfileContactRow({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.showDelete = false,
    this.showEdit = false,
    this.onDelete,
    this.onEdit,
  });

  void _copy(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.locale.copiedText, textDirection: TextDirection.rtl),
        backgroundColor: AppColor.golden,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
      child: Row(
        children: [
          // ── Main action icon (Leading) ──
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColor.baseFontColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColor.golden, size: 18),
          ),
          const SizedBox(width: 12),

          // ── Text ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColor.textGrey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
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

          const SizedBox(width: 10),

          // ── Action icons (Trailing) ──
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Copy icon
              GestureDetector(
                onTap: () => _copy(context, value),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColor.golden, width: 1),
                  ),
                  child: const Icon(Icons.copy_outlined, color: AppColor.golden, size: 16),
                ),
              ),
              // Optional edit icon
              if (showEdit && onEdit != null) ...[
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green.shade200, width: 1),
                    ),
                    child: Icon(Icons.edit_outlined, color: Colors.green.shade400, size: 16),
                  ),
                ),
              ],
              // Optional delete icon
              if (showDelete && onDelete != null) ...[
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF5F5),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.red.shade200, width: 1),
                    ),
                    child: Icon(Icons.delete_outline, color: Colors.red.shade400, size: 16),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

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
          colors: [Color(0xFF2B2B2B), Color(0xFF1A1A1A)],
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
                        color: Colors.white,
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
                    color: Colors.black.withValues(alpha: 0.15),
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
