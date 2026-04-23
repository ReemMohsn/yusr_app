import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';

// Saudi country code — single source of truth
const String _kSaudiDialCode = '+966';

class PhoneInputFormCard extends StatelessWidget {
  final bool isEditMode;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isFocused;
  final String? errorText;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final bool isSaving;

  const PhoneInputFormCard({
    super.key,
    required this.isEditMode,
    required this.controller,
    required this.focusNode,
    required this.isFocused,
    required this.errorText,
    required this.onSave,
    required this.onCancel,
    required this.isSaving,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section label ──
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            isEditMode ? locale.editNumber : locale.addNumberBtn,
            style: const TextStyle(
              color: AppColor.textGrey,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // ── White card ──
        Container(
          decoration: BoxDecoration(
            color: AppColor.withe,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColor.inputFieldBoundaries, width: 1.4),
            boxShadow: [
              BoxShadow(
                color: AppColor.black.withValues(alpha: 0.10),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: AppColor.black.withValues(alpha: 0.10),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(25, 25, 25, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PhoneInputSection(
                controller: controller,
                focusNode: focusNode,
                isFocused: isFocused,
                errorText: errorText,
              ),
              const SizedBox(height: 24),
              _ActionButtons(
                isEditMode: isEditMode,
                onSave: onSave,
                onCancel: onCancel,
                isSaving: isSaving,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PhoneInputSection extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isFocused;
  final String? errorText;

  const _PhoneInputSection({
    required this.controller,
    required this.focusNode,
    required this.isFocused,
    required this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Field label ──
        Text(
          locale.saudiMobileNumber,
          style: const TextStyle(
            color: AppColor.midlineColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        // ── Input box ──
        Container(
          height: 59,
          decoration: BoxDecoration(
            color: AppColor.inputBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: errorText != null
                  ? AppColor.danger
                  : isFocused
                      ? AppColor.golden
                      : AppColor.inputFieldBoundaries,
              width: 1.4,
            ),
          ),
          child: Row(
            textDirection: TextDirection.ltr,
            children: [
              // ── Digit input (left in LTR) ──
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    keyboardType: TextInputType.phone,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColor.textDark,
                    ),
                    decoration: InputDecoration(
                      hintText: locale.saudiPhoneHint,
                      hintStyle: TextStyle(
                        color: AppColor.textDark.withValues(alpha: 0.5),
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(9),
                    ],
                  ),
                ),
              ),
              // ── Divider ──
              Container(width: 1, height: 24, color: AppColor.divider),
              // ── Dial code (right in LTR = right in RTL UI) ──
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  _kSaudiDialCode,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textDark,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // ── Hint / Error ──
        Row(
          children: [
            Icon(
              Icons.info_outline,
              size: 14,
              color: errorText != null ? AppColor.danger : AppColor.midlineColor,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                errorText ?? locale.saudiPhoneHint,
                style: TextStyle(
                  fontSize: 12,
                  color: errorText != null ? AppColor.danger : AppColor.midlineColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final bool isEditMode;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final bool isSaving;

  const _ActionButtons({
    required this.isEditMode,
    required this.onSave,
    required this.onCancel,
    required this.isSaving,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    return Row(
      children: [
        // ── Primary: Save / Add ──
        Expanded(
          child: GestureDetector(
            onTap: isSaving ? null : onSave,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: AppColor.baseFontColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: isSaving
                  ? const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: AppColor.golden,
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [                        
                        const Icon(Icons.save_outlined, color: AppColor.golden, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          isEditMode ? locale.saveNumberBtn : locale.addNumberBtn,
                          style: const TextStyle(
                            color: AppColor.golden,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // ── Secondary: Cancel ──
        Expanded(
          child: GestureDetector(
            onTap: isSaving ? null : onCancel,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: AppColor.withe,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColor.inputFieldBoundaries, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.black.withValues(alpha: 0.10),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.close, color: AppColor.midlineColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    locale.cancel,
                    style: const TextStyle(
                      color: AppColor.midlineColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
