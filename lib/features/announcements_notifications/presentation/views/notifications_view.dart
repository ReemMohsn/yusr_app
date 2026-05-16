import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/common/widgets/custom_golden_back_button.dart';
import 'package:yusr/core/common/widgets/custom_text_field.dart';
import 'package:yusr/core/constants/app_color.dart';
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
import 'package:yusr/features/be_leader/presentation/widgets/tracking_notification_card.dart';
import 'package:yusr/features/be_leader/providers/tracking_notifications_store.dart';

class NotificationsView extends ConsumerStatefulWidget {
  const NotificationsView({super.key});

  @override
  ConsumerState<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends ConsumerState<NotificationsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // ✅ إعادة جلب الإشعارات من السيرفر في كل مرة تُفتح الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(notificationsProvider);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    // 🌟 مراقبة حالة الإعلانات (تحميل، خطأ، أو داتا)
    final filteredState = ref.watch(filteredNotificationsProvider);
    // 🌟 معرّفات الإشعارات المقروءة
    final readIds = ref.watch(readNotificationsProvider).value ?? [];
    // 🌟 إشعارات "كن قائد" — تتحدث تفاعلياً فور add/remove
    final trackingNotifications = ref.watch(trackingNotificationsStoreProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(locale.notifications),
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: const UnconstrainedBox(child: CustomGoldenBackButton()),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSize.paddingOfPage),
        child: Column(
          children: [
            // ─── شريط البحث ───
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _searchController,
                    hintText: locale.notificationSearch,
                    prefixIcon: Icons.search,
                    textInputAction: TextInputAction.search,
                    onChanged: (value) {
                      ref
                          .read(filteredNotificationsProvider.notifier)
                          .search(value);
                    },
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey, size: 20.sp),
                      onPressed: () {
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
            const SizedBox(height: 16),

            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // ══════════════════════════════════════════════════
                  // قسم 1: إشعارات "كن قائد" (من المخزن المحلي)
                  // ══════════════════════════════════════════════════
                  if (trackingNotifications.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.h, top: 4.h),
                        child: _SectionHeader(title: '🔔 إشعارات كن قائد'),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, index) => TrackingNotificationCard(
                          notification: trackingNotifications[index],
                        ),
                        childCount: trackingNotifications.length,
                      ),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                  ],

                  // ══════════════════════════════════════════════════
                  // قسم 2: إعلانات الحملة (من الداتابيس)
                  // ══════════════════════════════════════════════════
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: _SectionHeader(title: '📢 إعلانات الحملة'),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: filteredState.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (_, __) => Center(
                        child: Text(
                          '${locale.errorFetchingNotifications}\n${filteredState.errorMessage}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      data: (notificationsList) {
                        if (notificationsList.isEmpty) {
                          final isSearching = ref
                              .read(filteredNotificationsProvider.notifier)
                              .searchQuery
                              .isNotEmpty;
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: Text(
                                isSearching
                                    ? locale.noMatchingSearchResults
                                    : locale.noNotificationsCurrently,
                              ),
                            ),
                          );
                        }
                        return Column(
                          children: notificationsList.map((notification) {
                            final bool isRead = readIds.contains(
                              notification.notificationId.toString(),
                            );
                            return GestureDetector(
                              onTap: () {
                                ref
                                    .read(readNotificationsProvider.notifier)
                                    .markAsRead(
                                      notification.notificationId.toString(),
                                    );
                                Navigator.of(context).pushNamed(
                                  AppRoute.notificationDetailsView,
                                  arguments: notification,
                                );
                              },
                              child: NotificationCard(
                                date: notification.sentAtDate,
                                title: notification.title,
                                description: notification.body,
                                time: notification.sentAtTime,
                                senderName: notification.senderName,
                                isRead: isRead,
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// عنوان القسم — مشترك بين القسمين
// ══════════════════════════════════════════════════════════════
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3.5.w,
          height: 16.h,
          decoration: BoxDecoration(
            color: AppColor.golden,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
        ),
      ],
    );
  }
}
