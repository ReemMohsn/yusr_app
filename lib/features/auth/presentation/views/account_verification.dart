import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/common/widgets/widget.dart'; // CustomBigButton
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/core/extensions/async_value_ui.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/auth/presentation/widgets/custom_back_button.dart';
import 'package:yusr/features/auth/presentation/widgets/hgh.dart';
import 'package:yusr/features/auth/presentation/widgets/otp_digit_field.dart';
import 'package:yusr/features/auth/providers/auth_controller.dart';

class OtpVerificationView extends ConsumerStatefulWidget {
  const OtpVerificationView({super.key});

  @override
  ConsumerState<OtpVerificationView> createState() =>
      _OtpVerificationViewState();
}

class _OtpVerificationViewState extends ConsumerState<OtpVerificationView> {
  final List<TextEditingController> _controllers = List.generate(
    5,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(5, (_) => FocusNode());

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  String get _otpCode => _controllers.map((e) => e.text).join();

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(authControllerProvider, (_, state) {
      if (state.isLoading) {
        context.showLoadingDialog();
      } else {
        context.closeLoadingDialog();
        if (state.hasError) {
          context.showErrorSnackBar(state.errorMessage);
        } else if (state.hasValue) {
          context.showSuccessSnackBar("تم التحقق بنجاح");
          // Navigator.pushNamed(context, AppRoute.resetPassword); // الانتقال للصفحة التالية
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 60.w,
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: const UnconstrainedBox(child: CustomBackButton()),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSize.paddingOfPage),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              // --- Header Icon ---
              Container(
                width: 80.w,
                height: 80.w,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: AppColor.golden,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.golden.withValues(alpha: 0.5),
                      blurRadius: 30,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.mail_outline_rounded,
                  size: 35.sp,
                  color: AppColor.withe,
                ),
              ),

              SizedBox(height: 30.h),
              Text(
                "التحقق من الحساب",
                style: context.theme.textTheme.headlineLarge,
              ),
              SizedBox(height: 20.h),
              Text(
                "أدخل رمز التحقق المكون من 5 أرقام الذي تم إرساله إليك",
                style: context.theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 40.r),

              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 40.h),
                decoration: BoxDecoration(
                  color: AppColor.withe,
                  border: Border.all(
                    color: AppColor.inputFieldBoundaries, // لون الحدود
                    width: 0.7, // حجم صغير جداً (يمكنك جعله 0.5 إذا أردته أنحف)
                  ),
                  borderRadius: BorderRadius.circular(30.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10), // 10% Opacity
                      offset: const Offset(0, 20), // Y = 20
                      blurRadius: 25, // Blur = 25
                      spreadRadius: -5, // Spread = -5
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      offset: const Offset(0, 8), // Y = 8
                      blurRadius: 10, // Blur = 10
                      spreadRadius: -6, // Spread = -6
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomLable(context: context, text: "رمز التحقق"),

                    SizedBox(height: 20.h),

                    // --- Custom OTP Fields Row ---
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(5, (index) {
                          return OtpDigitField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            // تمرير الـ FocusNode السابق والتالي للتحكم بالتنقل
                            nextFocusNode: index < 4
                                ? _focusNodes[index + 1]
                                : null,
                            prevFocusNode: index > 0
                                ? _focusNodes[index - 1]
                                : null,
                          );
                        }),
                      ),
                    ),

                    SizedBox(height: 30.h),

                    CustomBigButton(
                      text: 'التحقق من الرمز',
                      onPressed: () async {
                        // if (_otpCode.length == 5) {
                        //   await ref.read(authControllerProvider.notifier).verifyOtp(_otpCode);
                        // } else {
                        //   context.showErrorSnackBar("الرجاء إدخال الرمز كاملاً");
                        // }
                      },
                      backgroundColor: AppColor.golden,
                      textColor: AppColor.withe,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
