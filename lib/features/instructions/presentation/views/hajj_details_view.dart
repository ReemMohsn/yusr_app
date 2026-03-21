import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/features/auth/presentation/widgets/custom_back_button.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/instructions/presentation/widgets/action_item_row.dart';
import 'package:yusr/features/instructions/presentation/widgets/day_carousel_card.dart';
import 'package:yusr/features/instructions/providers/current_day_index_provider.dart';
import 'package:yusr/features/instructions/providers/hajj_details_provider.dart';

class HajjDetailsView extends ConsumerStatefulWidget {
  final String hajjType;

  const HajjDetailsView({super.key, required this.hajjType});

  @override
  ConsumerState<HajjDetailsView> createState() => _HajjDetailsViewState();
}

class _HajjDetailsViewState extends ConsumerState<HajjDetailsView> {
  @override
  void initState() {
    super.initState();
    // Reset the carousel to day 0 when entering a new Hajj type
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentDayIndexProvider.notifier).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.locale;
    final days = ref.watch(hajjDaysProvider(widget.hajjType, l10n: l10n));

    if (days.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.hajjType),
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          leadingWidth: 60.w,
          leading: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: const UnconstrainedBox(child: CustomBackButton()),
          ),
        ),
        body: Center(child: Text(l10n.notFound)),
      );
    }

    final currentPage = ref.watch(currentDayIndexProvider);
    final items = days[currentPage].actions;

    return Scaffold(
      appBar: AppBar(
        // AppBar title uses the localized label + the type name from the ARB
        title: Text('${l10n.hajjActionsTitle} ${widget.hajjType}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 60.w,
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: const UnconstrainedBox(child: CustomBackButton()),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            DayCarouselCard(days: days),
            SizedBox(height: AppSize.spaceBetweenCards.h),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: ListView.builder(
                  key: ValueKey(currentPage),
                  padding: EdgeInsets.fromLTRB(
                    AppSize.paddingOfPage.w,
                    AppSize.spaceBetweenCards.h,
                    AppSize.paddingOfPage.w,
                    AppSize.paddingInsideCard.h,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ActionItemRow(
                      action: items[index],
                      number: index + 1,
                      isFirst: index == 0,
                      isLast: index == items.length - 1,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoute.actionDetailsView,
                          arguments: items[index],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
