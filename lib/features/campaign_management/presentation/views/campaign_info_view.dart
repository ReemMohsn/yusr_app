import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/core/common/widgets/custom_golden_back_button.dart';
import 'package:yusr/core/extensions/async_value_ui.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/campaign_management/providers/campaign_info_provider.dart';
import 'package:yusr/features/profile/presentation/widgets/profile_info_row.dart';
import 'package:yusr/features/profile/presentation/widgets/profile_section_card.dart';

class CampaignInfoView extends ConsumerWidget {
  const CampaignInfoView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale;
    final asyncData = ref.watch(campaignInfoProvider);

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(locale.aboutCampaign),
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
                  onPressed: () => ref.invalidate(campaignInfoProvider),
                  child: Text(locale.retry),
                ),
              ],
            ),
          ),
          data: (info) {
            return RefreshIndicator(
              onRefresh: () async => ref.refresh(campaignInfoProvider.future),
              color: AppColor.golden,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSize.paddingOfPage,
                  vertical: AppSize.smallSpace * 2,
                ),
                child: Column(
                  children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSize.paddingInsideCard),
                    decoration: BoxDecoration(
                      color: AppColor.darkBlack,
                      borderRadius: BorderRadius.circular(AppSize.borderRadiusCard),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.campaign_outlined,
                          size: 50,
                          color: AppColor.golden,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          info.campaignName,
                          style: const TextStyle(
                            color: AppColor.golden,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${locale.hijriYear} ${info.hajjYear}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                   const SizedBox(height: AppSize.spaceBetweenCards),
                  ProfileSectionCard(
                    title: locale.campaignDates,
                    children: [       
                      ProfileInfoRow(
                        label: locale.campaignStartDate,
                        value: info.departureDate.toString(),
                        icon: Icons.calendar_month_outlined,
                      ),
                      const SizedBox(height: 12),
                      ProfileInfoRow(
                        label: locale.campaignReturnDate,
                        value: info.returnDate.toString(),
                        icon: Icons.calendar_month_outlined,
                      ),
                      
                    ],
                  ),
                  const SizedBox(height: AppSize.spaceBetweenCards),
                  ProfileSectionCard(
                    title: locale.generalInfo,
                    children: [       
                      ProfileInfoRow(
                        label: locale.totalPilgrims,
                        value: info.totalPilgrims.toString(),
                        icon: Icons.people_outline,
                      ),
                      const SizedBox(height: 12),
                      ProfileInfoRow(
                        label: locale.totalGroups,
                        value: info.totalGroups.toString(),
                        icon: Icons.group_work_outlined,
                      ),
                      const SizedBox(height: 12),
                      ProfileInfoRow(
                        label: locale.totalSupervisors,
                        value: info.totalSupervisors.toString(),
                        icon: Icons.supervisor_account_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSize.spaceBetweenCards),
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.golden,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSize.borderRadiusCard),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRoute.campaignGroupsView);
                      },
                      child: Text(
                        locale.viewCampaignGroups,
                        style: const TextStyle(
                          color: AppColor.darkBlack,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSize.paddingInsideCard),
                ],
              ),
            ));
          },
        ),
      ),
    );
  }
}

