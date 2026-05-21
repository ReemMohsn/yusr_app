import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/onboarding/providers/onboarding_controller.dart';
import '../widgets/onboarding_content.dart';
import '../widgets/dot_indicator.dart';

class OnboardingView extends ConsumerWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale;
    final state = ref.watch(onboardingControllerProvider);
    final notifier = ref.read(onboardingControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // زر التخطي العلوي
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: TextButton(
                  onPressed: () => notifier.completeAndNavigate(context),
                  child: Text(
                    locale.skip,
                    style: TextStyle(
                      color: AppColor.iconColors,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ),

            // ممر الصفحات الترحيبية
            Expanded(
              child: PageView.builder(
                controller: notifier.pageController,
                itemCount: state.totalPages,
                onPageChanged: notifier.updateIndex,
                itemBuilder: (context, index) {
                  return OnboardingContent(model: state.pages[index]);
                },
              ),
            ),

            // لوحة التحكم السفلية (النقاط والأزرار)
            Padding(
              padding: EdgeInsets.all(30.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // مؤشرات النقاط الديناميكية
                  Row(
                    children: List.generate(
                      state.totalPages,
                      (index) =>
                          DotIndicator(isActive: state.currentIndex == index),
                    ),
                  ),

                  // زر الانتقال 
                  ElevatedButton(
                    onPressed: () => notifier.nextPage(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.golden,
                      padding: EdgeInsets.symmetric(
                        horizontal: 25.w,
                        vertical: 12.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      state.isLastPage ? locale.start : locale.next,
                      style: const TextStyle(
                        color: AppColor.withe,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
