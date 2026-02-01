import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yusr/core/common/widgets/widget.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_image.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/core/extensions/async_value_ui.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/core/utils/app_validator.dart';
import 'package:yusr/features/auth/presentation/widgets/custom_back_button.dart';
import 'package:yusr/features/auth/presentation/widgets/hgh.dart';
import 'package:yusr/features/auth/providers/auth_controller.dart';
import 'package:yusr/features/auth/providers/password_visibility_provider.dart';

class ResetPassword extends ConsumerStatefulWidget {
  const ResetPassword({super.key});

  @override
  ConsumerState<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends ConsumerState<ResetPassword> {
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final towpassWordController = TextEditingController();
  final FocusNode passWordFocusNode = FocusNode();

  @override
  void dispose() {
    passwordController.dispose();
    towpassWordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPasswordVisible = ref.watch(passwordVisibilityProvider);
    final local = context.locale;
    ref.listen<AsyncValue<void>>(authControllerProvider, (_, state) {
      if (state.isLoading) {
        context.showLoadingDialog();
      } else {
        context.closeLoadingDialog();
        if (state.hasError) {
          context.showErrorSnackBar(state.errorMessage);
        } else {
          context.showSuccessSnackBar(
            "تم إرسال رمز التحقق إلى بريدك الإلكتروني بنجاح",
          );
          Navigator.of(context).pushNamed(AppRoute.otpVerificationView);
        }
      }
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              Container(
                width: 80.w,
                height: 80.w,
                padding: EdgeInsets.all(22.w),
                decoration: BoxDecoration(
                  color: AppColor.golden,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.golden.withValues(alpha: 0.6),
                      offset: const Offset(0, 0),
                      blurRadius: 40,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  AppImage.lockIcon,
                  colorFilter: ColorFilter.mode(
                    AppColor.withe,
                    BlendMode.srcIn,
                  ),
                ),
              ),

              SizedBox(height: 30.h),
              Text(
                "تعيين كلمة مرور جديدة",
                style: context.theme.textTheme.headlineLarge,
              ),
              SizedBox(height: 20.h),
              Text(
                "يجب أن تكون كلمة المرور الجديدة مختلفة عن كلمات المرور السابقة",
                style: context.theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 40.h),
                decoration: BoxDecoration(
                  color: AppColor.withe,
                  border: Border.all(
                    color: AppColor.inputFieldBoundaries,
                    width: 0.7,
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
                      color: Colors.black.withOpacity(0.10), // 10% Opacity
                      offset: const Offset(0, 8), // Y = 8
                      blurRadius: 10, // Blur = 10
                      spreadRadius: -6, // Spread = -6
                    ),
                  ],
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomLable(
                        context: context,
                        text: "كلمة المرور الجديدة",
                      ),
                      SizedBox(height: 20.h),
                      TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        validator: AppValidator.validateEmptyField,
                        obscureText: !isPasswordVisible,
                        focusNode: passWordFocusNode,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: "**********",
                          prefixIcon: Icon(
                            Icons.lock_outline_rounded,
                            size: 12.sp,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              ref
                                      .read(passwordVisibilityProvider.notifier)
                                      .state =
                                  !isPasswordVisible;
                            },
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 12.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25.h),
                      CustomLable(context: context, text: "تأكييد كلمة المرور"),
                      SizedBox(height: 20.h),
                      TextFormField(
                        controller: towpassWordController,
                        keyboardType: TextInputType.visiblePassword,
                        validator: AppValidator.validateEmptyField,
                        obscureText: !isPasswordVisible,
                        focusNode: passWordFocusNode,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: "**********",
                          prefixIcon: Icon(
                            Icons.lock_outline_rounded,
                            size: 12.sp,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              ref
                                      .read(passwordVisibilityProvider.notifier)
                                      .state =
                                  !isPasswordVisible;
                            },
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 12.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),

                      CustomBigButton(
                        text: 'إعادة التعيين',
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            // FocusScope.of(context).unfocus();
                            // await ref
                            //     .read(authControllerProvider.notifier)
                            //     .forgotPassword(
                            //       identifirController.text.trim(),
                            //     );
                          }
                        },
                        backgroundColor: AppColor.golden,
                        textColor: AppColor.withe,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ودجت صغيرة لرسم العنوان مع الخط الذهبي الجانبي
}
