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
import 'package:yusr/core/services/API/ApiResponse.dart';
import 'package:yusr/core/utils/app_validator.dart';
import 'package:yusr/features/auth/presentation/widgets/custom_back_button.dart';
import 'package:yusr/features/auth/presentation/widgets/hgh.dart';
import 'package:yusr/features/auth/providers/password_visibility_provider.dart';
import 'package:yusr/core/common/providers/shared_preferences_service_provider%20.dart';
import 'package:yusr/features/auth/providers/reset_password_controller_provider.dart';

class ResetPasswordView extends ConsumerStatefulWidget {
  const ResetPasswordView({super.key});

  @override
  ConsumerState<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends ConsumerState<ResetPasswordView> {
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
    final isPasswordTwoVisible = ref.watch(passwordTwoVisibilityProvider);
    final local = context.locale;
    ref.listen<AsyncValue<ApiResponse<dynamic>?>>(
      resetPasswordControllerProvider,
      (_, state) async {
        if (state.isLoading) {
          context.showLoadingDialog();
        } else if (state.hasError) {
          context.closeLoadingDialog();
          context.showErrorSnackBar(state.errorMessage);
        } else if (state.hasValue && state.value != null) {
          context.closeLoadingDialog();
          // 🎉 هنا السحر! نجحت العملية والبيانات موجودة
          context.showSuccessSnackBar(state.value!.message);
          await ref.read(sharedPreferencesServiceProvider).removeResetEmail();
          await ref.read(sharedPreferencesServiceProvider).removeOtpCode();

          //  ref.invalidate(userProfileProvider);
          // Navigator.of(
          //   context,
          // ).pushNamedAndRemoveUntil(AppRoute.loginView, (route) => false);

          Navigator.of(context).pushNamed(AppRoute.loginView);
        }
      },
    );
    // ref.listen<AsyncValue<void>>(resetPasswordControllerProvider, (
    //   _,
    //   state,
    // ) async {
    //   if (state.isLoading) {
    //     context.showLoadingDialog();
    //   } else {
    //     context.closeLoadingDialog();
    //     if (state.hasError) {
    //       context.showErrorSnackBar(state.errorMessage);
    //     } else {
    //       context.showSuccessSnackBar("تم إعاده تعيين كلمة المرور بنجاح");
    //       // Clear any saved reset email after successful password reset

    //       await ref.read(sharedPreferencesServiceProvider).removeResetEmail();
    //       await ref.read(sharedPreferencesServiceProvider).removeOtpCode();
    //       Navigator.of(context).pushNamed(AppRoute.loginView);
    //     }
    //   }
    // });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 60.w,
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
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
                width: 96.w,
                height: 96.w,
                padding: EdgeInsets.all(25.w),
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
                local.setNewPassword,
                style: context.theme.textTheme.headlineLarge,
              ),
              SizedBox(height: 20.h),
              Text(
                local.newPasswordDescription,
                style: context.theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 40.h),
                decoration: BoxDecoration(
                  color: AppColor.withe,
                  border: Border.all(
                    color: AppColor.inputFieldBoundaries,
                    width: 0.7,
                  ),
                  borderRadius: BorderRadius.circular(24.r),
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
                        text: local.newPasswordLabel,
                      ),
                      SizedBox(height: 15.h),
                      TextFormField(
                        controller: passwordController,
                        autofocus: true,
                        keyboardType: TextInputType.visiblePassword,
                        validator: AppValidator.validatePassword,
                        obscureText: !isPasswordVisible,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => FocusScope.of(
                          context,
                        ).requestFocus(passWordFocusNode),
                        decoration: InputDecoration(
                          hintText: "**********",
                          prefixIcon: Icon(
                            Icons.lock_outline_rounded,
                            size: 20.sp,
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
                              size: 15.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25.h),
                      CustomLable(
                        context: context,
                        text: local.confirmPasswordLabel,
                      ),
                      SizedBox(height: 15.h),
                      TextFormField(
                        controller: towpassWordController,
                        keyboardType: TextInputType.visiblePassword,
                        validator: AppValidator.validatePassword,
                        obscureText: !isPasswordTwoVisible,
                        textInputAction: TextInputAction.done,
                        focusNode: passWordFocusNode,
                        decoration: InputDecoration(
                          hintText: "**********",
                          prefixIcon: Icon(
                            Icons.lock_outline_rounded,
                            size: 20.sp,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              ref
                                      .read(
                                        passwordTwoVisibilityProvider.notifier,
                                      )
                                      .state =
                                  !isPasswordTwoVisible;
                            },
                            icon: Icon(
                              isPasswordTwoVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 15.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      CustomBigButton(
                        text: local.resetButton,
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            if (passwordController.text.trim() !=
                                towpassWordController.text.trim()) {
                              context.showErrorSnackBar(
                                local.passwordsDoNotMatchError,
                              );
                            } else {
                              FocusScope.of(context).unfocus();
                              await ref
                                  .read(
                                    resetPasswordControllerProvider.notifier,
                                  )
                                  .resetPassword(
                                    passwordController.text.trim(),
                                  );
                            }
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
