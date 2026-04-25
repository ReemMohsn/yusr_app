// تأكدي من مسار الملف الصحيح حسب مشروعك
import 'package:yusr/core/constants/shared_preferences_keys.dart';
import 'package:yusr/features/announcements_notifications/providers/unread_notifications_count_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/common/providers/api_service_provider.dart';
import 'package:yusr/core/common/providers/shared_preferences_service_provider.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_image.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/core/services/notification_service.dart';
import 'package:yusr/features/auth/data/models/login_model.dart';
import 'package:yusr/features/auto_counter/presentation/views/tawaf_counter_view.dart';
import 'package:yusr/features/be_leader/providers/pilgrim_tracking_controller.dart';
import 'package:yusr/features/home/data/models/navigation_item_model.dart';
import 'package:yusr/features/home/presentation/views/home_view.dart';
import 'package:yusr/features/home/presentation/widgets/custom_drawer.dart';
import 'package:yusr/features/home/providers/current_index_controller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yusr/features/home/providers/user_provider.dart';
import 'package:yusr/features/return_to_compaign_location/presentation/views/return_me_view.dart';

class MainHomeView extends ConsumerStatefulWidget {
  const MainHomeView({super.key});

  @override
  ConsumerState<MainHomeView> createState() => _MainHomeViewState();
}

class _MainHomeViewState extends ConsumerState<MainHomeView> {
  @override
  void initState() {
    super.initState();
    // استدعاء التزامن مرة واحدة عند فتح التطبيق
    _syncNotifications();
  }

  Future<void> _syncNotifications() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 1. التحقق من حالة تسجيل الدخول
      final userProfileState = ref.read(userProfileProvider);
      final profile = userProfileState.asData?.value;

      // 2. إذا لم يكن هناك بروفايل (أي زائر)، نخرج من الدالة ولا نستدعي المزامنة
      if (profile == null) {
        debugPrint("المستخدم زائر: تم تخطي مزامنة الإشعارات.");
        return;
      }
      final prefsService = ref.read(sharedPreferencesServiceProvider);
      final apiService = ref.read(apiServiceProvider);
      final notificationService = NotificationService(prefsService, apiService);
      notificationService.syncUserTopics();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProfileState = ref.watch(userProfileProvider);
    final profile = userProfileState.asData?.value;
    final bool isLoggedIn = profile != null;
    final locale = context.locale;

    final List<NavigationItemModel> itemsData = [
      NavigationItemModel(
        label: locale.home,
        page: const HomeView(),
        activeIconPath: AppImage.homeIcon,
      ),
      NavigationItemModel(
        label: locale.manasekCounter,
        page: const TawafCounterView(),
        activeIconPath: AppImage.timerIcon,
      ),
      NavigationItemModel(
        label: locale.smartMufti,
        page: const Placeholder(),
        activeIconPath: AppImage.smartMoftiIcon,
      ),
      NavigationItemModel(
        label: locale.returnMe,
        page: const ReturnMeView(),
        activeIconPath: AppImage.arjeneeIcon,
      ),
    ];

    final int currentIndex = ref.watch(currentIndexControllerProvider);

    final currentIndexNotifier = ref.read(
      currentIndexControllerProvider.notifier,
    );

    return Scaffold(
      endDrawer: isLoggedIn ? const CustomDrawer() : null,
      appBar: AppBar(
        leadingWidth: isLoggedIn ? 150 : 140,
        leading: isLoggedIn
            ? _buildLoggedInLeading(context, profile) // عرض البروفايل + الجرس
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  // عرض زر تسجيل الدخول للزائر
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoute.loginView);
                  },
                  child: Text(
                    locale.login,
                  ),
                ),
              ),

        // ============================================================
        // الجزء الأيمن (Actions): أصبح الآن يحتوي على زر القائمة (Menu)
        // ============================================================
        actions: isLoggedIn
            ? [
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: AppColor.golden,
                      size: 30,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                  ),
                ),
                const SizedBox(width: 10),
              ]
            : [], // إخفاء القائمة للزوار
      ),
      // leading: isLoggedIn
      //     ? Builder(
      //         builder: (context) => IconButton(
      //           icon: const Icon(
      //             Icons.menu,
      //             color: AppColor.golden,
      //             size: 30,
      //           ),
      //           onPressed: () {
      //             Scaffold.of(context).openEndDrawer();
      //           },
      //         ),
      //       )
      //     : null,
      // actions: isLoggedIn
      //     ? [_buildLoggedInLeading(profile), const SizedBox(width: 10)]
      //     : [
      //         TextButton(
      //           child: const Text(
      //             "تسجيل الدخول",
      //             style: TextStyle(
      //               color: AppColor.golden,
      //               fontWeight: FontWeight.bold,
      //             ),
      //           ),
      //           onPressed: () {
      //             Navigator.pushNamed(context, AppRoute.loginView);
      //           },
      //         ),
      //         const SizedBox(width: 10),
      //       ],

      // ),
      body: Padding(
        padding: EdgeInsets.all(AppSize.paddingOfPage),
        child: IndexedStack(
          index: currentIndex,
          children: itemsData.map((e) => e.page).toList(),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColor.darkBlack,
        selectedIndex: currentIndex,
        onDestinationSelected: (int newIndex) {
          currentIndexNotifier.setIndex(newIndex);
        },
        destinations: itemsData.map((item) {
          return NavigationDestination(
            label: item.label,
            icon: Builder(
              builder: (context) {
                final iconColor = IconTheme.of(context).color;

                return SvgPicture.asset(
                  item.activeIconPath,
                  width: 22,
                  height: 22,
                  colorFilter: iconColor != null
                      ? ColorFilter.mode(iconColor, BlendMode.srcIn)
                      : null,
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  /// الواجهة في حالة المستخدم المسجل (صورة + خريطة التتبع + جرس)
  Widget _buildLoggedInLeading(BuildContext context, ProfileModel profile) {
    final unreadCount = ref.watch(unreadNotificationsCountProvider);

    return Row(
      children: [
        const SizedBox(width: 10),
        // أيقونة البروفايل
        Container(
          width: 35,
          height: 35,
          decoration: const BoxDecoration(
            color: AppColor.golden,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              profile.fullName.isNotEmpty
                  ? profile.fullName[0].toUpperCase()
                  : "P",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(width: 5),
        // 🌟 2. استخدام FutureBuilder للتعامل مع Future<int?> القادم من SharedPreferences
        if (profile.userRole == 'حاج')
          FutureBuilder<int?>(
            // نمرر الـ Future هنا
            future: ref
                .read(sharedPreferencesServiceProvider)
                .getInt(SharedPreferencesKeys.currentSessionId),
            builder: (context, snapshot) {
              // نستخرج القيمة، وإذا كانت null نعتبرها 0
              final activeSessionId = snapshot.data ?? 0;

              // إذا كان هناك جلسة نشطة، نظهر الزر الأخضر
              if (activeSessionId > 0) {
                return Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(
                      Icons.location_on,
                      color:
                          Colors.greenAccent, // لون مميز يدل على أن التتبع نشط
                      size: 28,
                    ),
                    onPressed: () {
                      // 🌟 التعديل هنا: استدعاء دالة بدء التتبع لتنشيط الـ Stream في حال تم إغلاق التطبيق مسبقاً
                      ref
                          .read(pilgrimTrackingControllerProvider.notifier)
                          .acceptAndStartTracking(
                            sessionId: activeSessionId,
                            pilgrimId: profile.userId
                                .toString(), // تأكد أن userId هو اسم المتغير الصحيح في موديل Profile
                            pilgrimName: profile.fullName,
                          );

                      // ثم الانتقال إلى الخريطة
                      Navigator.of(context).pushNamed(
                        AppRoute.pilgrimMapTrackingView,
                        arguments: activeSessionId,
                      );
                    },
                  ),
                );
              }
              // إذا لم تكن هناك جلسة نشطة، لا نعرض شيئاً
              return const SizedBox.shrink();
            },
          ),

        // 🌟 3. الـ Badge حول أيقونة الجرس
        Badge(
          isLabelVisible: unreadCount > 0,
          label: Text(
            unreadCount > 99 ? '+99' : unreadCount.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.red,
          alignment: const Alignment(0.4, -0.4),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.notifications_none_outlined,
              color: AppColor.golden,
              size: 28,
            ),
            onPressed: () => _navigateToNotifications(context),
          ),
        ),
      ],
    );
  }

  // دالة التنقل المنفصلة لزيادة وضوح الكود
  void _navigateToNotifications(BuildContext context) {
    Navigator.pushNamed(context, AppRoute.notificationsView);
  }
}
