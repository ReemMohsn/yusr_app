import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/common/widgets/custom_golden_back_button.dart';
import 'package:yusr/core/common/widgets/widget.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/constants/app_size.dart'; // استيراد ملف المقاسات
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/core/services/API/ApiResponse.dart';
import 'package:yusr/features/campaign_location/providers/campaign_location_controller_provider.dart';
import 'package:yusr/features/campaign_location/providers/get_locations_provider.dart';
import '../widgets/current_location_card.dart';
import '../widgets/other_location_item.dart';
import 'package:yusr/features/campaign_location/data/models/campaign_location_item_model.dart';
import 'package:yusr/features/campaign_location/data/models/campaign_locations_view_model.dart';

class CampaignLocationView extends ConsumerWidget {
  const CampaignLocationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale;
    final theme = Theme.of(context).textTheme; // الوصول للثيم الموحد
    final locationsAsync = ref.watch(getCampaignLocationsProvider);

    ref.listen<AsyncValue<ApiResponse<dynamic>?>>(
      // تغيير النوع هنا إلى dynamic
      campaignLocationControllerProvider,
      (prev, next) {
        if (next.isLoading) {
          context.showLoadingDialog();
        } else if (next.hasError) {
          context.closeLoadingDialog();
          context.showErrorSnackBar(next.error.toString());
        } else if (next.hasValue && !next.isLoading) {
          context.closeLoadingDialog();

          // الآن سيعمل هذا السطر بنجاح لأن النوع dynamic
          final message = next.value?.message ?? locale.deleteSuccess;
          context.showSuccessSnackBar(message);
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(locale.campaignLocation),
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: const UnconstrainedBox(child: CustomGoldenBackButton()),
        ),
      ),
      // تم حذف SafeArea واستبدالها ببادنق من ملف AppSize
      body: Padding(
        padding: const EdgeInsets.all(AppSize.paddingOfPage),
        child: locationsAsync.when(
          data: (data) {
            if (data == null)
              return Center(
                child: Text(locale.notFound, style: theme.bodyMedium),
              );

            return RefreshIndicator(
              onRefresh: () async =>
                  ref.refresh(getCampaignLocationsProvider.future),
              color: AppColor.golden,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                // البادنق الأفقي تم نقله للـ body الرئيسي لتوحيد المسافات
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.darkBlack.withOpacity(0.25),
                              blurRadius: 4,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.golden,
                            // الطول يعتمد على البادنق كما في الملاحظات
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 12.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () => Navigator.pushNamed(
                            context,
                            AppRoute.addLocationView,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.add, color: AppColor.withe),
                              SizedBox(width: 8.w),
                              Text(
                                locale.addLocation,
                                // استخدام bodyLarge مع تعديل اللون والوزن
                                style: theme.bodyLarge?.copyWith(
                                  color: AppColor.withe,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),
                    SectionHeader(title: locale.currentLocation, theme: theme),
                    SizedBox(height: 16.h),
                    if (data.currentLocation != null)
                      CurrentLocationCard(location: data.currentLocation!)
                    else
                      EmptyCard(message: locale.notFound, theme: theme),

                    SizedBox(height: 30.h),

                    SectionHeader(title: locale.otherLocations, theme: theme),
                    SizedBox(height: 16.h),
                    if (data.previousLocations.isEmpty)
                      EmptyCard(message: locale.notFound, theme: theme)
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.previousLocations.length,
                        separatorBuilder: (_, __) => SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          return OtherLocationItem(
                            key: ValueKey(
                              data.previousLocations[index].locationId,
                            ),
                            location: data.previousLocations[index],
                          );
                        },
                      ),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            );
          },
          error: (error, stack) => ErrorState(
            context: context,
            ref: ref,
            locale: locale,
            theme: theme,
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColor.golden),
          ),
        ),
      ),
    );
  }
}

class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    required this.context,
    required this.ref,
    required this.locale,
    required this.theme,
  });

  final BuildContext context;
  final WidgetRef ref;
  final dynamic locale;
  final TextTheme theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(locale.fetchDataError, style: theme.bodyMedium),
          TextButton(
            onPressed: () => ref.invalidate(getCampaignLocationsProvider),
            child: Text(
              locale.retry,
              style: theme.bodyMedium?.copyWith(color: AppColor.golden),
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyCard extends StatelessWidget {
  const EmptyCard({super.key, required this.message, required this.theme});

  final String message;
  final TextTheme theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: theme.bodySmall?.copyWith(color: AppColor.lightFontColor),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, required this.theme});

  final String title;
  final TextTheme theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10.w),
      child: Text(
        title,
        textAlign: TextAlign.right,
        style: theme.headlineSmall?.copyWith(
          fontSize: 20.sp,
        ), // استخدام الثيم مع تعديل الحجم للرأس
      ),
    );
  }
}
