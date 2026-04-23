import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/core/common/widgets/custom_golden_back_button.dart';
import 'package:yusr/features/group/providers/group_provider.dart';
import 'package:yusr/features/profile/presentation/widgets/profile_contact_row.dart';
import 'package:yusr/features/profile/presentation/widgets/profile_info_row.dart';
import 'package:yusr/features/profile/presentation/widgets/profile_section_card.dart';
import 'package:yusr/features/group/presentation/widgets/pilgrim_header_card.dart';
import 'package:yusr/features/group/presentation/widgets/pilgrim_health_card.dart';

class PilgrimDetailsView extends ConsumerWidget {
  final int userId;

  const PilgrimDetailsView({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(pilgrimDetailsProvider(userId));
    final locale = context.locale;

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
                  locale.errorLoadingPilgrimData,
                  style: const TextStyle(color: AppColor.danger),
                ),
                ElevatedButton(
                  onPressed: () => ref.invalidate(pilgrimDetailsProvider(userId)),
                  child: Text(locale.retry),
                ),
              ],
            ),
          ),
          data: (pilgrim) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSize.paddingOfPage,
                vertical: AppSize.smallSpace * 2,
              ),
              child: Column(
                children: [
                  PilgrimHeaderCard(
                    fullName: pilgrim.fullName,
                    jobTitle: pilgrim.jobTitle,
                  ),
                  const SizedBox(height: AppSize.spaceBetweenCards),

                  PilgrimHealthCard(
                    healthStatus: pilgrim.healthStatus,
                    healthNote: pilgrim.healthNote,
                  ),
                  const SizedBox(height: AppSize.spaceBetweenCards),

                  // ── Personal Data Section ──
                  ProfileSectionCard(
                    title: locale.personalData,
                    children: [
                      ProfileInfoRow(
                        label: locale.gender,
                        value: pilgrim.gender.isNotEmpty ? pilgrim.gender : '—',
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 12),
                      ProfileInfoRow(
                        label: locale.dateOfBirth,
                        value: pilgrim.dateOfBirth.isNotEmpty
                            ? pilgrim.dateOfBirth
                            : '—',
                        icon: Icons.calendar_today_outlined,
                      ),
                      const SizedBox(height: 12),
                      ProfileContactRow(
                        label: locale.passportNumber,
                        value: pilgrim.passportNumber.isNotEmpty
                            ? pilgrim.passportNumber
                            : '—',
                        icon: Icons.badge_outlined,
                      ),
                      const SizedBox(height: 12),
                      ProfileInfoRow(
                        label: locale.residentialLocation,
                        value: pilgrim.placeResidence.isNotEmpty
                            ? pilgrim.placeResidence
                            : '—',
                        icon: Icons.location_on_outlined,
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
                        label: locale.whatsappNumber,
                        value: pilgrim.whatsappNumber.isNotEmpty
                            ? pilgrim.whatsappNumber
                            : '—',
                        icon: Icons.chat_bubble_outline,
                      ),
                      const SizedBox(height: 12),
                      ProfileContactRow(
                        label: locale.relativeContact,
                        value: pilgrim.emergencyContact.name != '—'
                            ? '${pilgrim.emergencyContact.name} (${pilgrim.emergencyContact.phone})'
                            : '—',
                        icon: Icons.people_outline,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSize.paddingInsideCard),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
