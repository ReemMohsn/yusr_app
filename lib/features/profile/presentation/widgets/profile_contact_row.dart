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
        color: AppColor.withe,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.14),
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
                  textDirection: TextDirection.ltr,
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
              // Optional edit icon
              if (showEdit && onEdit != null) ...[
                GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColor.golden,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColor.darkGolden, width: 1),
                    ),
                    child: const Icon(Icons.edit_outlined, color: AppColor.withe, size: 16),
                  ),
                ),
                const SizedBox(width: 6),
              ],
              // Copy icon
              GestureDetector(
                onTap: () => _copy(context, value),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColor.inputFieldColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColor.golden, width: 1),
                  ),
                  child: const Icon(Icons.copy_outlined, color: AppColor.golden, size: 16),
                ),
              ),
              // Optional delete icon
              if (showDelete && onDelete != null) ...[
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColor.dangerBackground,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColor.dangerBorder, width: 1),
                    ),
                    child: const Icon(Icons.delete_outline, color: AppColor.dangerIcon, size: 16),
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
