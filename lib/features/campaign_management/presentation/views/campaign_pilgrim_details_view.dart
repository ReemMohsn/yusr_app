import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/core/common/widgets/custom_golden_back_button.dart';
import 'package:yusr/core/extensions/async_value_ui.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/campaign_management/providers/campaign_pilgrim_details_provider.dart';
import 'package:yusr/features/profile/presentation/widgets/profile_contact_row.dart';
import 'package:yusr/features/profile/presentation/widgets/profile_info_row.dart';
import 'package:yusr/features/profile/presentation/widgets/profile_section_card.dart';
import 'package:yusr/features/group/presentation/widgets/pilgrim_header_card.dart';

class CampaignPilgrimDetailsView extends ConsumerWidget {
  final int userId;

  const CampaignPilgrimDetailsView({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale;
    final asyncData = ref.watch(campaignPilgrimDetailsProvider(userId));

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(locale.pilgrimDetails),
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
                  onPressed: () => ref.invalidate(campaignPilgrimDetailsProvider(userId)),
                  child: Text(locale.retry),
                ),
              ],
            ),
          ),
          data: (pilgrim) {
            return RefreshIndicator(
              onRefresh: () async => ref.refresh(campaignPilgrimDetailsProvider(userId).future),
              color: AppColor.golden,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSize.paddingOfPage,
                  vertical: AppSize.smallSpace * 2,
                ),
                child: Column(
                  children: [
                  PilgrimHeaderCard(
                    fullName: pilgrim.fullName,
                    jobTitle: 'حاج',
                  ),
                  const SizedBox(height: AppSize.spaceBetweenCards),

                  // ── Group Info Section ──
                  ProfileSectionCard(
                    title: locale.groupInfoSectionTitle,
                    children: [
                      ProfileInfoRow(
                        label: locale.groupName,
                        value: pilgrim.groupName.isNotEmpty ? pilgrim.groupName : '—',
                        icon: Icons.group_outlined,
                      ),
                      const SizedBox(height: 12),
                      ProfileInfoRow(
                        label: locale.supervisorName,
                        value: pilgrim.supervisorName.isNotEmpty
                            ? pilgrim.supervisorName
                            : '—',
                        icon: Icons.admin_panel_settings_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSize.spaceBetweenCards),

                  // ── Contact Section ──
                  ProfileSectionCard(
                    title: locale.contactData,
                    children: [
                      ProfileContactRow(
                        label: locale.saudiMobileNumber,
                        value: pilgrim.saudiNumber.isNotEmpty
                            ? pilgrim.saudiNumber
                            : '—',
                        icon: Icons.phone_outlined,
                      ),
                      const SizedBox(height: 12),
                      ProfileContactRow(
                        label: locale.yemeniMobileNumber,
                        value: pilgrim.yemeniNumber.isNotEmpty
                            ? pilgrim.yemeniNumber
                            : '—',
                        icon: Icons.phone_outlined,
                      ),
                      const SizedBox(height: 12),
                      ProfileContactRow(
                        label: locale.familyNumber,
                        value: pilgrim.familyNumber.isNotEmpty
                            ? pilgrim.familyNumber
                            : '—',
                        icon: Icons.phone_outlined,
                      ),
                      const SizedBox(height: 12),
                      ProfileContactRow(
                        label: locale.whatsappNumber,
                        value: pilgrim.whatsappNumber.isNotEmpty
                            ? pilgrim.whatsappNumber
                            : '—',
                        icon: Icons.chat_bubble_outline,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSize.paddingInsideCard),
                ],
              ),
            ),
            );
          },
        ),
      ),
    );
  }
}
