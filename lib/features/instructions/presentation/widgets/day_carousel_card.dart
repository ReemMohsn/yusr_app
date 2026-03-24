import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/features/instructions/data/models/hajj_day_model.dart';
import 'package:yusr/features/instructions/providers/current_day_index_provider.dart';

class DayCarouselCard extends ConsumerStatefulWidget {
  final List<HajjDayModel> days;

  const DayCarouselCard({super.key, required this.days});

  @override
  ConsumerState<DayCarouselCard> createState() => _DayCarouselCardState();
}

class _DayCarouselCardState extends ConsumerState<DayCarouselCard> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // Initialize PageController with the current provider state
    final initialPage = ref.read(currentDayIndexProvider);
    _pageController = PageController(initialPage: initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.days.isEmpty) return const SizedBox.shrink();

    // Sync PageController when currentDayIndexProvider changes (e.g. from arrows)
    ref.listen<int>(currentDayIndexProvider, (previous, next) {
      if (_pageController.hasClients && _pageController.page?.round() != next) {
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });

    final currentPage = ref.watch(currentDayIndexProvider);
    final totalDays = widget.days.length;

    final canGoForward = currentPage < totalDays - 1;
    final canGoBack = currentPage > 0;

    return Container(
      margin: EdgeInsets.fromLTRB(
        AppSize.paddingOfPage.w,
        16.h,
        AppSize.paddingOfPage.w,
        0,
      ),
      width: double.infinity,
      height: 174.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColor.brownGolden, AppColor.golden],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.darkBlack.withValues(alpha: 0.25),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // ── Slidable Content ──
          PageView.builder(
            controller: _pageController,
            itemCount: totalDays,
            onPageChanged: (index) {
              ref.read(currentDayIndexProvider.notifier).setIndex(index);
            },
            itemBuilder: (context, index) {
              final day = widget.days[index];
              return Stack(
                children: [
                  // Title
                  Positioned(
                    top: 36.h,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        day.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                          color: AppColor.withe,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  // Subtitle
                  Positioned(
                    top: 78.h,
                    left: 20.w,
                    right: 20.w,
                    child: Center(
                      child: Text(
                        day.subtitle,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColor.withe.withValues(alpha: 0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // ── Fixed UI Elements (Not Sliding) ──

          // Dot indicators
          Positioned(
            bottom: 14.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(totalDays, (i) {
                final isActive = currentPage == i;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  width: isActive ? 32.w : 6.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColor.withe
                        : AppColor.withe.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(99.r),
                  ),
                );
              }),
            ),
          ),

          // Left navigation arrow (RTL = go FORWARD)
          if (canGoForward)
            Positioned(
              left: 8.w,
              top: 67.h,
              child: GestureDetector(
                onTap: () => ref
                    .read(currentDayIndexProvider.notifier)
                    .increment(totalDays),
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: AppColor.withe.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chevron_right,
                    color: AppColor.withe,
                    size: 24.sp,
                  ),
                ),
              ),
            ),

          // Right navigation arrow (RTL = go BACK)
          if (canGoBack)
            Positioned(
              right: 8.w,
              top: 67.h,
              child: GestureDetector(
                onTap: () =>
                    ref.read(currentDayIndexProvider.notifier).decrement(),
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: AppColor.withe.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chevron_left,
                    color: AppColor.withe.withValues(alpha: 0.85),
                    size: 24.sp,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
