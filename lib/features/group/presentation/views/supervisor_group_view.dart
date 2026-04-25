import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/common/widgets/custom_golden_back_button.dart';
import 'package:yusr/features/group/providers/group_provider.dart';

import 'package:yusr/features/group/presentation/widgets/group_filter_pill.dart';
import 'package:yusr/features/group/presentation/widgets/pilgrim_list_card.dart';

class SupervisorGroupView extends ConsumerStatefulWidget {
  const SupervisorGroupView({super.key});

  @override
  ConsumerState<SupervisorGroupView> createState() => _SupervisorGroupViewState();
}

class _SupervisorGroupViewState extends ConsumerState<SupervisorGroupView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearch);
  }

  void _onSearch() {
    // Calling setState will trigger re-build and re-filter using the _searchController value
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    final asyncData = ref.watch(supervisorGroupDetailsProvider);

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
          error: (error, _) {
            final errorString = error.toString();
            final isNotAssigned = errorString.contains('لم يتم تعيينك');

            if (!isNotAssigned) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSize.paddingOfPage),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          color: AppColor.danger, size: 80),
                      const SizedBox(height: 16),
                      Text(
                        errorString.replaceAll('Exception: ', ''),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColor.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSize.paddingOfPage),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColor.golden.withValues(alpha: 0.1),
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
            );
          },
          data: (groupModel) {
            // Apply filtering logic locally from fetched data
            final query = _searchController.text.trim();
            final displayedPilgrims = query.isEmpty
                ? groupModel.pilgrims
                : groupModel.pilgrims
                    .where((p) => p.fullName.contains(query))
                    .toList();

            return Column(
              children: [
                // ── Filter pills + search ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSize.paddingOfPage,
                    AppSize.paddingOfPage,
                    AppSize.paddingOfPage,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pills row
                      Row(
                        children: [
                          GroupFilterPill(
                            icon: Icons.people_outline,
                            label: groupModel.groupName,
                          ),
                          const SizedBox(width: 12),
                          GroupFilterPill(
                            icon: Icons.people_outline,
                            label: '${groupModel.membersCount} ${locale.members}',
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Search bar
                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColor.withe,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.black.withValues(alpha: 0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            const Icon(Icons.search,
                                color: AppColor.golden, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: locale.searchPilgrim,
                                  hintStyle: const TextStyle(
                                    color: AppColor.lightFontColor,
                                    fontSize: 15,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                                style: const TextStyle(
                                  color: AppColor.textDark,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                // ── Pilgrim list ──
                Expanded(
                  child: displayedPilgrims.isEmpty
                      ? Center(
                          child: Text(
                            locale.noPilgrimsFound,
                            style: const TextStyle(
                                color: AppColor.lightFontColor),
                          ),
                        )
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.paddingOfPage,
                          ),
                          itemCount: displayedPilgrims.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (_, index) {
                            final pilgrim = displayedPilgrims[index];
                            return PilgrimListCard(
                              name: pilgrim.fullName,
                              statusColor: pilgrim.isHealthStable
                                  ? AppColor.success
                                  : AppColor.warning,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoute.pilgrimDetailsView,
                                  arguments: pilgrim.userId,
                                );
                              },
                            );
                          },
                        ),
                ),

                const SizedBox(height: AppSize.paddingOfPage),
              ],
            );
          },
        ),
      ),
    );
  }
}
