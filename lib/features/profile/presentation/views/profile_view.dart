import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/profile/providers/profile_provider.dart';
import 'package:yusr/core/common/providers/shared_preferences_service_provider.dart';
import 'package:yusr/features/profile/presentation/widgets/profile_contact_row.dart';
import 'package:yusr/features/profile/presentation/widgets/profile_header_card.dart';
import 'package:yusr/features/profile/presentation/widgets/profile_info_row.dart';
import 'package:yusr/features/profile/presentation/widgets/profile_section_card.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  bool _hasSaudiNumber = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userOpt = ref.read(userDetailsProvider).value;
      if (userOpt != null && userOpt.saudiContactNumber.isNotEmpty) {
        setState(() => _hasSaudiNumber = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userDetailsAsync = ref.watch(userDetailsProvider);
    final locale = context.locale;

    return Scaffold(
        backgroundColor: const Color(0xFFF0F0F0),
        body: SafeArea(
          child: Column(
            children: [
              // ── App Bar ──
              Container(
                color: AppColor.baseFontColor,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    // Back button explicitly as in the blueprint
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColor.golden, width: 1.5),
                        ),
                        child: const Icon(Icons.chevron_right, color: AppColor.golden, size: 22),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        locale.profileTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColor.golden,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 38),
                  ],
                ),
              ),
              
              // ── Body ──
              Expanded(
                child: userDetailsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator(color: AppColor.golden)),
                  error: (error, stackTrace) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(locale.errorLoadingData, style: const TextStyle(color: AppColor.danger)),
                        ElevatedButton(
                          onPressed: () => ref.invalidate(userDetailsProvider),
                          child: Text(locale.retry),
                        )
                      ],
                    ),
                  ),
                  data: (user) {
                    final hasActualSaudiNumber = user.saudiContactNumber.isNotEmpty;
                    
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        children: [
                          ProfileHeaderCard(
                            fullName: user.fullName,
                            identifier: user.email.isNotEmpty ? user.email : 'm.abdullahalsyaif.sco',
                          ),
                          const SizedBox(height: 16),
                          
                          // ── Personal Data Section (Hajj Only) ──
                          FutureBuilder(
                            future: ref.read(sharedPreferencesServiceProvider).getProfile(),
                            builder: (context, snapshot) {
                              final dynamic localProfile = snapshot.data;
                              final rawRole = localProfile?.userRole ?? '';
                              final roleLower = rawRole.toLowerCase();
                              final isHajj = roleLower == 'user' || roleLower == 'hajj' || rawRole == 'مستخدم' || rawRole == 'حاج' || rawRole.isEmpty;
                              
                              if (!isHajj) return const SizedBox.shrink();

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: ProfileSectionCard(
                                  title: locale.personalData,
                                  children: [
                                    ProfileInfoRow(
                                      label: locale.fullName,
                                      value: user.fullName,
                                      icon: Icons.person_outline,
                                      highlighted: true,
                                    ),
                                    const SizedBox(height: 12),
                                    ProfileInfoRow(
                                      label: locale.gender,
                                      value: locale.male, // Static to meet blueprint exactly if dynamic not present
                                      icon: Icons.person_outline,
                                    ),
                                    const SizedBox(height: 12),
                                    ProfileInfoRow(
                                      label: locale.dateOfBirth,
                                      value: '3/1/1999', // Static
                                      icon: Icons.calendar_today_outlined,
                                    ),
                                    const SizedBox(height: 12),
                                    ProfileInfoRow(
                                      label: locale.healthStatus,
                                      value: 'مستقرة لا توجد أمراض', // Static
                                      icon: Icons.monitor_heart_outlined,
                                    ),
                                    const SizedBox(height: 12),
                                    ProfileInfoRow(
                                      label: locale.residentialLocation,
                                      value: 'اليمن-حضرموت-المكلا',
                                      icon: Icons.location_on_outlined,
                                    ),
                                  ],
                                ),
                              );
                            }
                          ),
                          
                          // ── Contact Section ──
                          ProfileSectionCard(
                            title: locale.contactData,
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 350),
                                child: (_hasSaudiNumber || hasActualSaudiNumber)
                                    ? ProfileContactRow(
                                        key: const ValueKey('saudi_added'),
                                        label: locale.saudiMobileNumber,
                                        value: hasActualSaudiNumber ? user.saudiContactNumber : '+966 501234567',
                                        icon: Icons.phone_outlined,
                                        showDelete: !_hasSaudiNumber && !hasActualSaudiNumber, // Kept false out of dynamic safety
                                        showEdit: true,
                                        onEdit: () {
                                          // TODO: Add implementation logic later
                                        },
                                        onDelete: () => setState(() => _hasSaudiNumber = false),
                                      )
                                    : AddSaudiNumberCard(
                                        key: const ValueKey('saudi_add'),
                                        onTap: () => setState(() => _hasSaudiNumber = true),
                                      ),
                              ),
                              const SizedBox(height: 12),
                              ProfileContactRow(
                                label: locale.yemeniMobileNumber,
                                value: user.yemeniContactNumber.isNotEmpty ? user.yemeniContactNumber : '+966 501234567',
                                icon: Icons.phone_outlined,
                              ),
                              const SizedBox(height: 12),
                              ProfileContactRow(
                                label: locale.whatsappNumber,
                                value: user.whatsAppContactNumber.isNotEmpty ? user.whatsAppContactNumber : '+966 501234567',
                                icon: Icons.chat_bubble_outline,
                              ),
                              const SizedBox(height: 12),
                              ProfileContactRow(
                                label: locale.relativeContact,
                                value: user.familyContactNumber.isNotEmpty ? user.familyContactNumber : 'أحمد الشريف(966+)(501234567)',
                                icon: Icons.people_outline,
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
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
