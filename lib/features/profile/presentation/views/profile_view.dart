import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/profile/providers/profile_provider.dart';
import 'package:yusr/core/common/providers/shared_preferences_service_provider.dart';
import 'package:yusr/features/profile/presentation/widgets/profile_contact_row.dart';
import 'package:yusr/features/profile/presentation/widgets/profile_header_card.dart';
import 'package:yusr/features/profile/presentation/widgets/profile_info_row.dart';
import 'package:yusr/features/profile/presentation/widgets/profile_section_card.dart';
import 'package:yusr/core/common/widgets/custom_golden_back_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ─── Role helper (single source of truth — shared with ProfileHeaderCard) ────
bool _isHajjRole(String rawRole) {
  final lower = rawRole.toLowerCase();
  return lower == 'user' || lower == 'hajj' ||
      rawRole == 'مستخدم' || rawRole == 'حاج' || rawRole.isEmpty;
}

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  // Tracks whether the user has opted to add a Saudi number in this session.
  // Initialised to false; set to true once the API data confirms one exists.
  bool _saudiNumberAdded = false;

  @override
  Widget build(BuildContext context) {
    final userDetailsAsync = ref.watch(userDetailsProvider);
    final locale = context.locale;

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(locale.profileTitle),
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: const UnconstrainedBox(child: CustomGoldenBackButton()),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: userDetailsAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColor.golden),
                ),
                error: (error, _) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        locale.errorLoadingData,
                        style: const TextStyle(color: AppColor.danger),
                      ),
                      ElevatedButton(
                        onPressed: () => ref.invalidate(userDetailsProvider),
                        child: Text(locale.retry),
                      ),
                    ],
                  ),
                ),
                data: (user) {
                  // Derive Saudi number state from live data, not initState.
                  final hasActualSaudiNumber = user.saudiNumber.isNotEmpty && 
                                               user.saudiNumber != 'غير متوفر';
                  // Show the row if the API already has one, or if the user
                  // tapped "add" in this session.
                  final showSaudiRow = hasActualSaudiNumber || _saudiNumberAdded;

                  return FutureBuilder(
                    future: ref.read(sharedPreferencesServiceProvider).getProfile(),
                    builder: (context, snapshot) {
                      final rawRole = snapshot.data?.userRole ?? '';
                      final isHajj = _isHajjRole(rawRole);

                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.paddingOfPage,
                          vertical: AppSize.smallSpace * 3,
                        ),
                        child: Column(
                          children: [
                            ProfileHeaderCard(fullName: user.fullName),
                            const SizedBox(height: AppSize.spaceBetweenCards),

                            // ── Personal Data Section (Hajj pilgrims only) ──
                            if (isHajj) ...[
                              ProfileSectionCard(
                                title: locale.personalData,
                                children: [
                                  ProfileInfoRow(
                                    label: locale.fullName,
                                    value: user.fullName,
                                    icon: Icons.person_outline,
                                  ),
                                  const SizedBox(height: 12),
                                  ProfileInfoRow(
                                    label: locale.gender,
                                    value: user.gender.isNotEmpty
                                        ? user.gender
                                        : '—',
                                    icon: Icons.person_outline,
                                  ),
                                  const SizedBox(height: 12),
                                  ProfileInfoRow(
                                    label: locale.dateOfBirth,
                                    value: user.dateOfBirth.isNotEmpty
                                        ? user.dateOfBirth
                                        : '—',
                                    icon: Icons.calendar_today_outlined,
                                  ),
                                  const SizedBox(height: 12),
                                  ProfileInfoRow(
                                    label: locale.age,
                                    value: user.age.isNotEmpty
                                        ? user.age
                                        : '—',
                                    icon: Icons.cake_outlined,
                                  ),
                                  const SizedBox(height: 12),
                                  ProfileInfoRow(
                                    label: locale.healthStatus,
                                    value: user.healthStatus.isNotEmpty
                                        ? user.healthStatus
                                        : '—',
                                    icon: Icons.monitor_heart_outlined,
                                  ),
                                  const SizedBox(height: 12),
                                  ProfileInfoRow(
                                    label: locale.residentialLocation,
                                    value: user.placeResidence.isNotEmpty
                                        ? user.placeResidence
                                        : '—',
                                    icon: Icons.location_on_outlined,
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSize.spaceBetweenCards),
                            ],

                            // ── Contact Section ──
                            ProfileSectionCard(
                              title: locale.contactData,
                              children: [
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 350),
                                  child: showSaudiRow
                                      ? ProfileContactRow(
                                          key: const ValueKey('saudi_added'),
                                          label: locale.saudiMobileNumber,
                                          value: user.saudiNumber,
                                          icon: Icons.phone_outlined,
                                          showEdit: true,
                                          onEdit: () {
                                            // Edit flow to be implemented
                                          },
                                        )
                                      : AddSaudiNumberCard(
                                          key: const ValueKey('saudi_add'),
                                          onTap: () => setState(
                                            () => _saudiNumberAdded = true,
                                          ),
                                        ),
                                ),
                                const SizedBox(height: 12),
                                ProfileContactRow(
                                  label: locale.yemeniMobileNumber,
                                  value: user.yemeniNumber,
                                  icon: Icons.phone_outlined,
                                ),
                                const SizedBox(height: 12),
                                ProfileContactRow(
                                  label: locale.whatsappNumber,
                                  value: user.whatsappNumber,
                                  icon: Icons.chat_bubble_outline,
                                ),
                                const SizedBox(height: 12),
                                ProfileContactRow(
                                  label: locale.relativeContact,
                                  value: user.relativePhoneNumber,
                                  icon: Icons.people_outline,
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSize.paddingInsideCard),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
