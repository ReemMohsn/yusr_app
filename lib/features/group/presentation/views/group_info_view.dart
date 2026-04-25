import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/group/providers/group_provider.dart';
import 'package:yusr/features/group/presentation/widgets/group_hero_card.dart';
import 'package:yusr/features/group/presentation/widgets/group_info_row.dart';
import 'package:yusr/features/group/presentation/widgets/group_contact_row.dart';
import 'package:yusr/features/group/presentation/widgets/group_section_header.dart';

class GroupInfoView extends ConsumerWidget {
  const GroupInfoView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale;
    final groupDataAsync = ref.watch(groupInfoProvider);

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: groupDataAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColor.golden),
        ),
        error: (error, _) {
          final errorString = error.toString();
          final isNotAssigned = errorString.contains('لم يتم تعيينك');

          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColor.backgroundColor,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: AppColor.golden),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            backgroundColor: AppColor.backgroundColor,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSize.paddingOfPage),
                child: !isNotAssigned
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline,
                              color: AppColor.danger, size: 48),
                          const SizedBox(height: 16),
                          Text(
                            errorString.replaceAll('Exception: ', ''),
                            style: const TextStyle(
                                color: AppColor.danger, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColor.goldenWithOpacity,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColor.golden.withValues(alpha: 0.3),
                              ),
                            ),
                            padding: const EdgeInsets.all(32),
                            child: const Icon(
                              Icons.groups_outlined,
                              size: 72,
                              color: AppColor.golden,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            locale.groupNotAssignedTitle,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColor.baseFontColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            locale.groupNotAssignedBody,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColor.baseFontColor.withValues(alpha: 0.6),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
              ),
            ),
          );
        },
        data: (data) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Custom App Bar ──
              SliverAppBar(
                pinned: true,
                backgroundColor: AppColor.baseFontColor,
                elevation: 0,
                shadowColor: AppColor.black.withValues(alpha: 0.2),
                forceElevated: true,
                centerTitle: true,
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColor.baseFontColor, AppColor.dark2],
                    ),
                  ),
                ),
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColor.golden),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new,
                          color: AppColor.golden, size: 18),
                    ),
                  ),
                ),
                title: Text(
                  locale.groupInfoSectionTitle,
                  style: const TextStyle(
                    color: AppColor.golden,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // ── Body content ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),

                      // ── Hero Card ──
                      GroupHeroCard(
                        groupName: data.groupName,
                        pilgrimsCount: data.pilgrimsCount.toString(),
                        supervisorName: data.supervisorName,
                      ),
                      const SizedBox(height: 16),

                      // ── Group Info Section ──
                      _InfoSection(
                        title: locale.groupInfoSectionTitle,
                        children: [
                          GroupInfoRow(
                            label: locale.groupName,
                            value: data.groupName,
                            icon: Icons.groups_outlined,
                            isGold: true,
                          ),
                          GroupInfoRow(
                            label: locale.pilgrimsCount,
                            value: data.pilgrimsCount.toString(),
                            icon: Icons.groups_outlined,
                          ),
                          GroupInfoRow(
                            label: locale.arrivalDate,
                            value: data.arrivalDate,
                            icon: Icons.calendar_today_outlined,
                          ),
                          GroupInfoRow(
                            label: locale.departureDate,
                            value: data.departureDate,
                            icon: Icons.calendar_today_outlined,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // ── Supervisor Info Section ──
                      _InfoSection(
                        title: locale.supervisorInfo,
                        children: [
                          GroupInfoRow(
                            label: locale.supervisorName,
                            value: data.supervisorName,
                            icon: Icons.person_outline,
                            isGold: true,
                          ),
                          GroupContactRow(
                            label: locale.yemeniMobileNumber,
                            value: data.supervisorYemeniNumber,
                            leadingIcon: Icons.phone_outlined,
                            actionIcon: Icons.copy,
                          ),
                          GroupContactRow(
                            label: locale.saudiMobileNumber,
                            value: data.supervisorSaudiNumber,
                            leadingIcon: Icons.phone_outlined,
                            actionIcon: Icons.copy,
                          ),
                          GroupContactRow(
                            label: locale.whatsappNumber,
                            value: data.supervisorWhatsApp,
                            leadingIcon: Icons.chat_bubble_outline,
                            actionIcon: Icons.copy,
                          ),
                          GroupContactRow(
                            label: locale.email,
                            value: data.supervisorEmail,
                            leadingIcon: Icons.email_outlined,
                            actionIcon: Icons.copy,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Internal layout helper — wraps a section header + children in a white card.
// ─────────────────────────────────────────────────────────────────────────────
class _InfoSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _InfoSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.withe,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.inputFieldBoundaries, width: 0.7),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          GroupSectionHeader(title: title),
          const Divider(height: 1, color: AppColor.inputFieldBoundaries),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}
