// تأكدي من مسار الملف الصحيح حسب مشروعك
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
        page: const Placeholder(),
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
        leadingWidth: isLoggedIn ? 100 : 140,
        leading: isLoggedIn
            ? _buildLoggedInLeading(context,profile) // عرض البروفايل + الجرس
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  // عرض زر تسجيل الدخول للزائر
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoute.loginView);
                  },
                  child: Text(
                    locale.login,
                    // style: TextStyle(
                    //   color: AppColor.golden,
                    //   fontWeight: FontWeight.bold,
                    //   fontSize: 14,
                    // ),
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

  /// الواجهة في حالة المستخدم المسجل (صورة + جرس)
  Widget _buildLoggedInLeading(BuildContext context,ProfileModel profile) {
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
        const SizedBox(width: 10),
        // أيقونة الجرس
        // IconButton(
        //   icon: const Icon(Icons.notifications_none_outlined, color: AppColor.golden),
        //   onPressed: () => _navigateToNotifications(context)
        //     // معالجة النقر على أيقونة الجرس
        //   ,
        // ),
        // 🌟 2. إضافة الـ Badge حول أيقونة الجرس
        Badge(
          // إظهار البادج فقط إذا كان هناك إشعارات جديدة (أكبر من 0)
          isLabelVisible: unreadCount > 0,
          // عرض الرقم داخل البادج
          label: Text(
            unreadCount > 99 ? '+99' : unreadCount.toString(), // للتعامل مع الأرقام الكبيرة
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.red, // لون البادج أحمر ليدل على التنبيه
          alignment: const Alignment(0.4, -0.4), // ضبط موضع البادج أعلى يمين الجرس
          child: IconButton(
            icon: const Icon(Icons.notifications_none_outlined, color: AppColor.golden),
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
