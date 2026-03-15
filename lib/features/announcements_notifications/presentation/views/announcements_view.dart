import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/common/widgets/custom_golden_back_button.dart';
import 'package:yusr/core/common/widgets/custom_text_field.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/core/extensions/async_value_ui.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/announcements_notifications/presentation/widgets/add_botton.dart';
import 'package:yusr/features/announcements_notifications/presentation/widgets/announcement_card.dart';
import 'package:yusr/features/announcements_notifications/presentation/widgets/confirm_delete_dialog.dart';
import 'package:yusr/features/announcements_notifications/providers/announcements_provider.dart';
import 'package:yusr/features/announcements_notifications/providers/delete_announcement_provider.dart';
import 'package:yusr/features/announcements_notifications/providers/filtered_announcements_provider.dart';
// استدعِ ملفات الكنترولر والموديل هنا

class AnnouncementsView extends ConsumerStatefulWidget {
  const AnnouncementsView({super.key});

  @override
  ConsumerState<AnnouncementsView> createState() => _AnnouncementsViewState();
}

class _AnnouncementsViewState extends ConsumerState<AnnouncementsView> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    // 🌟 مراقبة حالة الإعلانات (تحميل، خطأ، أو داتا)
    // final announcementsState = ref.watch(announcementsProvider);
    final filteredState = ref.watch(filteredAnnouncementsProvider);

    ref.listen(deleteAnnouncementProvider, (_, state) {
      if (state.isLoading) {
        context.showLoadingDialog();
      } else if (state.hasError) {
        context.closeLoadingDialog();
        context.showErrorSnackBar(state.errorMessage);
      } else if (state.hasValue && state.value != null) {
        context.closeLoadingDialog();
        context.showSuccessSnackBar(state.value!.message);
        ref.invalidate(announcementsProvider); // تحديث القائمة فوراً
      }
    });
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(locale.announcements),
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: const UnconstrainedBox(child: CustomGoldenBackButton()),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSize.paddingOfPage),
        child: Column(
          children: [
            // 🌟 قسم البحث وزر الإضافة (ثابت في الأعلى)
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _searchController,
                    hintText: locale.announcementSearch,
                    prefixIcon: Icons.search,
                    textInputAction: TextInputAction.search,
                    onChanged: (value) {
                      // نرسل النص للبروفايدر فوراً
                      ref
                          .read(filteredAnnouncementsProvider.notifier)
                          .search(value);
                    },
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey, size: 20.sp),
                      onPressed: () {
                        // إذا ضغط عليه يمسح النص، يصفر البحث، ويغلق الكيبورد
                        _searchController.clear();
                        ref
                            .read(filteredAnnouncementsProvider.notifier)
                            .search('');
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                AddBotton(
                  onTap: () {
                    Navigator.of(
                      context,
                    ).pushNamed(AppRoute.addAnnouncementView);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 🌟 قائمة الإعلانات (تتعامل مع جميع حالات الـ API)
            Expanded(
              child: filteredState.when(
                // 1. حالة التحميل
                loading: () => const Center(child: CircularProgressIndicator()),

                // 2. حالة الخطأ
                error: (error, stackTrace) => Center(
                  child: Text(
                    '${locale.errorFetchingAnnouncements}\n${filteredState.errorMessage}', // 🔥 هنا استخدمنا الإضافة الخاصة بك                    textAlign: TextAlign.center,
                  ),
                ),

                // 3. حالة النجاح ووجود البيانات
                data: (announcementsList) {
                  if (announcementsList.isEmpty) {
                    final isSearching = ref
                        .read(filteredAnnouncementsProvider.notifier)
                        .searchQuery
                        .isNotEmpty;
                    return Center(
                      child: Text(
                        isSearching
                            ? locale.noMatchingSearchResults
                            : locale.noAnnouncementsCurrently,
                      ),
                    );
                  }

                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: announcementsList.length,
                    itemBuilder: (context, index) {
                      final announcement = announcementsList[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            AppRoute.announcementDetailsView,
                            arguments: announcement, // تمرير الموديل كامل
                          );
                        },
                        child: AnnouncementCard(
                          date: announcement.sentAtDate, // تمرير التاريخ
                          title: announcement.title, // تمرير العنوان
                          description: announcement.body, // تمرير التفاصيل
                          time: announcement.sentAtTime, // تمرير الوقت
                          tag: announcement
                              .targetAudienceName, // تمرير الجمهور المستهدف
                          onDelete: () async {
                            // إظهار نافذة التأكيد
                            final shouldDelete = await showDialog<bool>(
                              context: context,
                              builder: (context) => const ConfirmDeleteDialog(),
                            );
                            // إذا ضغط المستخدم "حذف" (true)
                            if (shouldDelete == true) {
                              ref
                                  .read(deleteAnnouncementProvider.notifier)
                                  .deleteAnnouncement(
                                    announcement.announcementId,
                                  );
                            }
                          },
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
