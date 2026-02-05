import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:yusr/features/auth/providers/login_controller_provider.dart';
import 'package:yusr/features/auth/providers/password_visibility_provider.dart';
import 'package:yusr/features/home/providers/user_provider.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final formKey = GlobalKey<FormState>();
  final identifirController = TextEditingController();
  final passwordController = TextEditingController();
  final FocusNode passWordFocusNode = FocusNode();

  @override
  void dispose() {
    identifirController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = context.locale;
    final isPasswordVisible = ref.watch(passwordVisibilityProvider);
    ref.listen<AsyncValue<void>>(loginControllerProvider, (_, state) {
      if (state.isLoading) {
        context.showLoadingDialog();
      } else {
        context.closeLoadingDialog();
        if (state.hasError) {
          context.showErrorSnackBar(state.errorMessage);
          print(state.errorMessage);
        } else {
          context.showSuccessSnackBar("تم تسجيل الدخول بنجاح");
          ref.invalidate(userProfileProvider);
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(AppRoute.mainHomeView, (route) => false);
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
                width: 90.w,
                height: 90.w,
                padding: EdgeInsets.all(13.w),
                decoration: BoxDecoration(
                  color: AppColor.golden,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.darkBlack.withValues(alpha: 0.2),
                      offset: const Offset(0, 4),
                      blurRadius: 3,
                      spreadRadius: 1,
                    ),
                  ],
                ),

                child: Image.asset(AppImage.logoBlack),
              ),

              SizedBox(height: 16.h),
              Text("يُسر", style: context.theme.textTheme.headlineLarge),
              SizedBox(height: 10.h),
              Text(
                "رفيق الحاج الذكي",
                style: context.theme.textTheme.headlineMedium,
              ),

              SizedBox(height: 40.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 40.h),
                decoration: BoxDecoration(
                  color: AppColor.withe,
                  borderRadius: BorderRadius.circular(30.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      offset: const Offset(0, 1),
                      blurRadius: 3,
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                      spreadRadius: -1,
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
                        text: "البريد الإلكتروني أو رقم الجواز",
                      ),
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
                          hintText: "أدخل البيانات المطلوبة",
                          prefixIcon: Icon(
                            Icons.mail_outline_rounded,
                            size: 12.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 25.h),

                      // حقل كلمة المرور
                      CustomLable(context: context, text: "كلمة المرور"),
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

                      SizedBox(height: 12.h),

                      GestureDetector(
                        onTap: () => Navigator.of(
                          context,
                        ).pushNamed(AppRoute.forgotPassword),
                        child: Text(
                          "نسيت كلمة المرور؟",
                          style: TextStyle(
                            color: AppColor.golden,
                            fontSize: 8.sp,
                          ),
                        ),
                      ),

                      SizedBox(height: 30.h),
                      CustomBigButton(
                        text: 'تسجيل الدخول',
                        onPressed: () async {
                          // اللوجيك الخاص بهذه الصفحة يكتب هنا
                          if (formKey.currentState!.validate()) {
                            // إغلاق الكيبورد لجمالية أكثر
                            FocusScope.of(context).unfocus();

                            await ref
                                .read(loginControllerProvider.notifier)
                                .login(
                                  identifirController.text.trim(),
                                  passwordController.text.trim(),
                                );
                          }
                        },
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
