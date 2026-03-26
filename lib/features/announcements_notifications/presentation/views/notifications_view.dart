import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpod/src/framework.dart';
import 'package:yusr/core/common/widgets/custom_golden_back_button.dart';
import 'package:yusr/core/common/widgets/custom_text_field.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/core/extensions/async_value_ui.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/announcements_notifications/presentation/widgets/notification_card.dart'
    show NotificationCard;
import 'package:yusr/features/announcements_notifications/providers/filtered_notifications_provider.dart'
    show filteredNotificationsProvider;
import 'package:yusr/features/announcements_notifications/providers/notifications_provider.dart'
    show notificationsProvider;
import 'package:yusr/features/announcements_notifications/providers/read_notifications_provider.dart';
// استدعِ ملفات الكنترولر والموديل هنا

class NotificationsView extends ConsumerStatefulWidget {
  const NotificationsView({super.key});

  @override
  ConsumerState<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends ConsumerState<NotificationsView> {
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
    final notificationsState = ref.watch(notificationsProvider);
    final filteredState = ref.watch(filteredNotificationsProvider);
    // 🌟 يجب أن يكون هذا السطر موجوداً هنا لكي يتعرف على readIds
    final readNotificationsState = ref.watch(
      readNotificationsProvider as ProviderListenable<dynamic>,
    );
    final List<String> readIds = readNotificationsState.value ?? [];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          locale.notifications,
        ), // استخدم الترجمة من الإضافة الخاصة بك
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
                    hintText: locale
                        .notificationSearch, // استخدم الترجمة من الإضافة الخاصة بك
                    prefixIcon: Icons.search,
                    textInputAction: TextInputAction.search,
                    onChanged: (value) {
                      // نرسل النص للبروفايدر فوراً
                      ref
                          .read(filteredNotificationsProvider.notifier)
                          .search(value);
                    },
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey, size: 20.sp),
                      onPressed: () {
                        // إذا ضغط عليه يمسح النص، يصفر البحث، ويغلق الكيبورد
                        _searchController.clear();
                        ref
                            .read(filteredNotificationsProvider.notifier)
                            .search('');
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
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
                    '${locale.errorFetchingNotifications}\n${filteredState.errorMessage}', // 🔥 هنا استخدمنا الإضافة الخاصة بك                    textAlign: TextAlign.center,
                  ),
                ),

                // 3. حالة النجاح ووجود البيانات
                data: (notificationsList) {
                  if (notificationsList.isEmpty) {
                    final isSearching = ref
                        .read(filteredNotificationsProvider.notifier)
                        .searchQuery
                        .isNotEmpty;
                    return Center(
                      child: Text(
                        isSearching
                            ? locale.noMatchingSearchResults
                            : locale.noNotificationsCurrently,
                      ),
                    );
                  }

                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: notificationsList.length,
                    itemBuilder: (context, index) {
                      final notification = notificationsList[index];
                      // 🌟 التحقق مما إذا كان هذا الإشعار مقروءاً أم لا
                      // تأكدي من اسم المتغير للـ ID في الموديل الخاص بك (notificationId أو announcementId)
                      final bool isRead = readIds.contains(
                        notification.notificationId.toString(),
                      );
                      return GestureDetector(
                        onTap: () {
                          // 🌟 بمجرد النقر، نقوم بتسجيل هذا الإشعار كـ "مقروء" في الذاكرة
                          ref
                              .read(readNotificationsProvider.notifier)
                              .markAsRead(
                                notification.notificationId.toString(),
                              );
                          Navigator.of(context).pushNamed(
                            AppRoute.notificationDetailsView,
                            arguments: notification, // تمرير الموديل كامل
                          );
                        },
                        child: NotificationCard(
                          date: notification.sentAtDate, // تمرير التاريخ
                          title: notification.title, // تمرير العنوان
                          description: notification.body, // تمرير التفاصيل
                          time: notification.sentAtTime, // تمرير الوقت
                          senderName:
                              notification.senderName, // تمرير الجمهور المستهدف
                          isRead: isRead, // تمرير حالة القراءة
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
