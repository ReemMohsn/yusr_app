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
import 'package:yusr/core/common/providers/shared_preferences_service_provider%20.dart';
import 'package:yusr/core/constants/shared_preferences_keys.dart';
import 'package:yusr/features/auth/providers/forgot_password_controller_provider.dart';

class ForgotPassword extends ConsumerStatefulWidget {
  const ForgotPassword({super.key});

  @override
  ConsumerState<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends ConsumerState<ForgotPassword> {
  final formKey = GlobalKey<FormState>();
  final identifirController = TextEditingController();
  final FocusNode passWordFocusNode = FocusNode();

  @override
  void dispose() {
    identifirController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = context.locale;
    ref.listen<AsyncValue<void>>(forgotPasswordControllerProvider, (_, state) {
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
                      color: AppColor.golden.withValues(
                        alpha: 0.6,
                      ), // لون ذهبي شفاف
                      offset: const Offset(0, 0), // في المنتصف
                      blurRadius: 40, // انتشار كبير للظل ليعطي تأثير التوهج
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  AppImage.lockIcon,
                  colorFilter: ColorFilter.mode(
                    AppColor.darkBlack,
                    BlendMode.srcIn,
                  ),
                ),
              ),

              // Container(
              //   width: 80.w,
              //   height: 80.w,
              //   padding: EdgeInsets.all(22.w),
              //   decoration: BoxDecoration(
              //     color: AppColor.golden,
              //     shape: BoxShape.circle,
              //     boxShadow: [
              //       BoxShadow(
              //         color: AppColor.darkBlack.withValues(alpha: 0.2),
              //         offset: const Offset(0, 4),
              //         blurRadius: 3,
              //         spreadRadius: 1,
              //       ),
              //     ],
              //   ),
              //   child: SvgPicture.asset(
              //     AppImage.lockIcon,
              //     // width: 20.w,
              //     // height: 20.h,
              //     colorFilter: ColorFilter.mode(
              //       AppColor.darkBlack,
              //       BlendMode.srcIn,
              //     ),
              //   ),
              // ),
              SizedBox(height: 30.h),
              Text(
                "نسيت كلمة المرور؟",
                style: context.theme.textTheme.headlineLarge,
              ),
              SizedBox(height: 20.h),
              Text(
                "لا تقلق، يمكنك استعادة حسابك بسهولة. أدخل بريدك الإلكتروني وسنرسل لك رمز التحقق",
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
                      CustomLable(context: context, text: "البريد الإلكتروني"),
                      SizedBox(height: 20.h),
                      TextFormField(
                        validator: AppValidator.validateEmptyField,
                        controller: identifirController,
                        autofocus: true,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(
                          context,
                        ).requestFocus(passWordFocusNode),
                        decoration: InputDecoration(
                          hintText: "example@email.com",
                          prefixIcon: Icon(
                            Icons.mail_outline_rounded,
                            size: 12.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "سيتم إرسال رابط الاستعادة إلى بريدك الإلكتروني",
                        style: TextStyle(
                          color: AppColor.lightFontColor,
                          fontSize: 7.sp,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      CustomBigButton(
                        text: 'إرسال رمز التحقق',
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            FocusScope.of(context).unfocus();
                            final email = identifirController.text.trim();
                            await ref
                                .read(sharedPreferencesServiceProvider)
                                .setString(
                                  SharedPreferencesKeys.resetEmail,
                                  email,
                                );
                            await ref
                                .read(forgotPasswordControllerProvider.notifier)
                                .sendCode(email);
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
