import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/common/widgets/custom_golden_back_button.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:yusr/features/profile/presentation/widgets/importance_info_card.dart';
import 'package:yusr/features/profile/presentation/widgets/notes_card.dart';
import 'package:yusr/features/profile/presentation/widgets/phone_input_form_card.dart';
import 'package:yusr/features/profile/providers/profile_provider.dart';
import 'package:yusr/features/profile/providers/saudi_phone_controller.dart';

class SaudiPhoneView extends ConsumerStatefulWidget {
  final bool isEditMode;
  final String? currentNumber;

  const SaudiPhoneView({
    super.key,
    required this.isEditMode,
    this.currentNumber,
  });

  @override
  ConsumerState<SaudiPhoneView> createState() => _SaudiPhoneViewState();
}

class _SaudiPhoneViewState extends ConsumerState<SaudiPhoneView> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode && widget.currentNumber != null) {
      String num = widget.currentNumber!;
      if (num.startsWith('+966')) {
        num = num.substring(4);
      }
      _phoneController.text = num;
    }
    _focusNode.addListener(() => setState(() => _isFocused = _focusNode.hasFocus));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  bool _validate() {
    final locale = context.locale;
    final v = _phoneController.text.trim();
    if (v.isEmpty) {
      setState(() => _errorText = locale.saudiPhoneRequired);
      return false;
    }
    if (!v.startsWith('5')) {
      setState(() => _errorText = locale.saudiPhoneMustStartWith5);
      return false;
    }
    if (v.length != 9) {
      setState(() => _errorText = locale.saudiPhoneMustBe9Digits);
      return false;
    }
    setState(() => _errorText = null);
    return true;
  }

  Future<void> _onSave() async {
    final locale = context.locale;
    if (_validate()) {
      _focusNode.unfocus();
      
      final number = _phoneController.text.trim();
      await ref.read(saudiPhoneControllerProvider.notifier).updateSaudiNumber(number);
      
      final state = ref.read(saudiPhoneControllerProvider);
      
      if (!mounted) return;

      if (state is AsyncData) {
        // Show success snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isEditMode
                  ? locale.editedSaudiNumberSuccess
                  : locale.addedSaudiNumberSuccess,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: AppColor.golden,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 2),
          ),
        );
        
        // Refresh profile data instantly and pop
        ref.invalidate(userDetailsProvider);
        Navigator.pop(context);
        
      } else if (state is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error.toString()),
            backgroundColor: AppColor.danger,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _onCancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    final saudiPhoneState = ref.watch(saudiPhoneControllerProvider);
    final isSaving = saudiPhoneState is AsyncLoading;

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.baseFontColor, // matches 1A1A1A prototype
        centerTitle: true,
        title: Text(
          widget.isEditMode ? locale.editNumberTitle : locale.addNumberTitle,
          style: const TextStyle(
            color: AppColor.golden,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: const UnconstrainedBox(child: CustomGoldenBackButton()),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const ImportanceInfoCard(),
              const SizedBox(height: 16),
              PhoneInputFormCard(
                isEditMode: widget.isEditMode,
                controller: _phoneController,
                focusNode: _focusNode,
                isFocused: _isFocused,
                errorText: _errorText,
                onSave: _onSave,
                onCancel: _onCancel,
                isSaving: isSaving,
              ),
              const SizedBox(height: 16),
              const NotesCard(),
            ],
          ),
        ),
      ),
    );
  }
}
