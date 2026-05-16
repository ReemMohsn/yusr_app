import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/core/common/widgets/custom_golden_back_button.dart';
import 'package:yusr/core/extensions/async_value_ui.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/campaign_management/providers/campaign_groups_provider.dart';

class CampaignGroupsView extends ConsumerWidget {
  const CampaignGroupsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale;
    final asyncData = ref.watch(campaignGroupsProvider);

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(locale.campaignGroups),
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: const UnconstrainedBox(child: CustomGoldenBackButton()),
        ),
      ),
      body: SafeArea(
        child: asyncData.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColor.golden),
          ),
          error: (error, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${locale.errorLoadingData}\n${asyncData.errorMessage}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColor.danger),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => ref.invalidate(campaignGroupsProvider),
                  child: Text(locale.retry),
                ),
              ],
            ),
          ),
          data: (groups) {
            if (groups.isEmpty) {
              return Center(child: Text(locale.noGroupsCurrently));
            }

            return RefreshIndicator(
              onRefresh: () async => ref.refresh(campaignGroupsProvider.future),
              color: AppColor.golden,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSize.paddingOfPage,
                  vertical: AppSize.smallSpace * 2,
                ),
                itemCount: groups.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                final group = groups[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AppRoute.campaignGroupDetailsView,
                      arguments: group.groupId,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(AppSize.paddingInsideCard),
                    decoration: BoxDecoration(
                      color: AppColor.withe,
                      borderRadius: BorderRadius.circular(AppSize.borderRadiusCard),
                      border: Border.all(color: AppColor.goldenWithOpacity, width: 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColor.goldenWithOpacity,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.group,
                            color: AppColor.golden,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                group.groupName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColor.baseFontColor,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${locale.supervisor} ${group.supervisorName}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColor.lightFontColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColor.darkBlack,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.people, color: AppColor.golden, size: 16),
                              const SizedBox(width: 5),
                              Text(
                                '${group.pilgrimsCount}',
                                style: const TextStyle(
                                  color: AppColor.golden,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ));
          },
        ),
      ),
    );
  }
}
