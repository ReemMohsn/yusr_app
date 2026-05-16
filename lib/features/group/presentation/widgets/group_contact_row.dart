import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';

/// A copyable contact row used in the supervisor info section of [GroupInfoView].
///
/// Displays a [label] + [value] pair with a leading [leadingIcon] and a copy
/// button on the trailing side. Tapping the button copies [value] to clipboard.
class GroupContactRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData leadingIcon;
  final IconData actionIcon;

  const GroupContactRow({
    super.key,
    required this.label,
    required this.value,
    required this.leadingIcon,
    required this.actionIcon,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    return Container(
      decoration: BoxDecoration(
        color: AppColor.withe,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColor.inputFieldBoundaries, width: 0.7),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // ── Leading icon ──
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColor.baseFontColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(leadingIcon, color: AppColor.golden, size: 18),
          ),
          const SizedBox(width: 12),
          // ── Label + value ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColor.textGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColor.textDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          // ── Copy button ──
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(locale.copiedText, textDirection: TextDirection.rtl),
                  backgroundColor: AppColor.golden,
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColor.inputFieldColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColor.golden, width: 1),
              ),
              child: Icon(actionIcon, color: AppColor.golden, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
