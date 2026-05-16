import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/core/common/widgets/custom_golden_back_button.dart';
import 'package:yusr/core/extensions/async_value_ui.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/campaign_management/providers/campaign_group_details_provider.dart';
import 'package:yusr/features/profile/presentation/widgets/profile_contact_row.dart';
import 'package:yusr/features/profile/presentation/widgets/profile_info_row.dart';
import 'package:yusr/features/profile/presentation/widgets/profile_section_card.dart';

class CampaignGroupDetailsView extends ConsumerWidget {
  final int groupId;

  const CampaignGroupDetailsView({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale;
    final asyncData = ref.watch(campaignGroupDetailsProvider(groupId));

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(locale.supervisorGroupDetails),
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
                  onPressed: () => ref.invalidate(campaignGroupDetailsProvider(groupId)),
                  child: Text(locale.retry),
                ),
              ],
            ),
          ),
          data: (details) {
            return RefreshIndicator(
              onRefresh: () async => ref.refresh(campaignGroupDetailsProvider(groupId).future),
              color: AppColor.golden,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSize.paddingOfPage),
                    child: Column(
                      children: [
                        // Card for Group and Supervisor Info
                        Container(
                          padding: const EdgeInsets.all(AppSize.paddingInsideCard),
                          decoration: BoxDecoration(
                            color: AppColor.darkBlack,
                            borderRadius: BorderRadius.circular(AppSize.borderRadiusCard),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.group_work,
                                size: 40,
                                color: AppColor.golden,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                details.groupName,
                                style: const TextStyle(
                                  color: AppColor.golden,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${locale.pilgrimsCount}: ${details.pilgrims.length}',
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
                          title: locale.supervisorInfo,
                          children: [
                            ProfileInfoRow(
                              label: locale.fullName,
                              value: details.supervisorName,
                              icon: Icons.person_outline,
                            ),
                            const SizedBox(height: 12),
                            ProfileContactRow(
                              label: locale.saudiMobileNumber,
                              value: details.supervisorSaudiNumber,
                              icon: Icons.phone_outlined,
                            ),
                            const SizedBox(height: 12),
                            ProfileContactRow(
                              label: locale.yemeniMobileNumber,
                              value: details.supervisorYemeniNumber,
                              icon: Icons.phone_outlined,
                            ),
                            const SizedBox(height: 12),
                            ProfileContactRow(
                              label: locale.whatsappNumber,
                              value: details.supervisorWhatsappNumber,
                              icon: Icons.chat_bubble_outline,
                            ),
                            const SizedBox(height: 12),                            
                            ProfileContactRow(
                              label: locale.familyNumber,
                              value: details.supervisorFamilyNumber,
                              icon: Icons.phone_outlined,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSize.spaceBetweenCards),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            locale.pilgrimsListTitle,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColor.baseFontColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSize.paddingOfPage),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final pilgrim = details.pilgrims[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              AppRoute.campaignPilgrimDetailsView,
                              arguments: pilgrim.userId,
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
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
                                    Icons.person,
                                    color: AppColor.golden,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Text(
                                    pilgrim.fullName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: AppColor.baseFontColor,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: pilgrim.isHealthStable
                                        ? AppColor.successBackground
                                        : AppColor.dangerBackground,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: pilgrim.isHealthStable
                                          ? AppColor.successBorder
                                          : AppColor.dangerBorder,
                                    ),
                                  ),
                                  child: Text(
                                    pilgrim.isHealthStable ? locale.healthStable : locale.inactive, // We reuse inactive or add not stable
                                    style: TextStyle(
                                      color: pilgrim.isHealthStable
                                          ? AppColor.successIcon
                                          : AppColor.dangerIcon,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: details.pilgrims.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
              ],
            ),
            );
          },
        ),
      ),
    );
  }
}
