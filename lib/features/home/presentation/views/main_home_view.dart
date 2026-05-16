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
import 'package:yusr/features/be_leader/providers/tracking_notifications_store.dart';
import 'package:yusr/features/auth/data/models/login_model.dart';
import 'package:yusr/features/auto_counter/presentation/views/tawaf_counter_view.dart';
import 'package:yusr/features/be_leader/providers/active_session_id_provider.dart';
import 'package:yusr/features/be_leader/providers/pilgrim_tracking_controller.dart';
import 'package:yusr/features/be_leader/providers/pilgrims_list_provider.dart';
import 'package:yusr/features/home/data/models/navigation_item_model.dart';
import 'package:yusr/features/home/presentation/views/home_view.dart';
import 'package:yusr/features/home/presentation/widgets/custom_drawer.dart';
import 'package:yusr/features/home/providers/current_index_controller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yusr/features/home/providers/user_provider.dart';
import 'package:yusr/features/return_to_compaign_location/presentation/views/return_me_view.dart';
import 'package:yusr/features/smart_mufti/presentation/views/smart_mufti_view.dart';

class MainHomeView extends ConsumerStatefulWidget {
  const MainHomeView({super.key});

  @override
  ConsumerState<MainHomeView> createState() => _MainHomeViewState();
}

class _MainHomeViewState extends ConsumerState<MainHomeView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _syncNotifications();
    _initActiveSession(); // قراءة الجلسة المحفوظة لتهيئة الزر
    // استعادة بطاقة دعوة الجلسة المحفوظة في SharedPreferences (إن وجدت)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(trackingNotificationsStoreProvider.notifier)
          .loadPersistedInvite();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// عند عودة التطبيق للمقدمة: أعِد قراءة الجلسة وحدِّث قائمة الحجاج إن وُجدت
  @override
  void didChangeAppLifecycleState(AppLifecycleState appState) {
    if (appState == AppLifecycleState.resumed) {
      _initActiveSession();
      // إعادة تحميل الدعوة المعلقة عند العودة للمقدمة (احتياطي)
      ref
          .read(trackingNotificationsStoreProvider.notifier)
          .loadPersistedInvite();
    }
  }

  /// تهيئة [activeSessionIdProvider] من SharedPreferences
  Future<void> _initActiveSession() async {
    final prefs = ref.read(sharedPreferencesServiceProvider);
    final sessionId =
        await prefs.getInt(SharedPreferencesKeys.currentSessionId) ?? 0;
    if (mounted) {
      ref.read(activeSessionIdProvider.notifier).updateSessionId(sessionId);
      // تحديث قائمة الحجاج إن كانت جلسة المشرف نشطة
      if (sessionId > 0) {
        ref.invalidate(pilgrimsListProvider(sessionId));
      }
    }
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
        page: SmartMuftiView(),
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
        leadingWidth: isLoggedIn ? 160 : 140,
        leading: isLoggedIn
            ? _buildLoggedInLeading(context, profile) // عرض البروفايل + الجرس
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  // عرض زر تسجيل الدخول للزائر
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoute.loginView);
                  },
                  child: Text(locale.login),
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
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, AppRoute.profileView);
          },
          child: Container(
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
        ),
        const SizedBox(width: 5),
        if (profile.userRole == 'حاج')
          Builder(
            builder: (context) {
              // 🌟 مزود تفاعلي: يختفي فور انتهاء الجلسة دون الحاجة لإعادة البناء
              final activeSessionId = ref.watch(activeSessionIdProvider);
              if (activeSessionId <= 0) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.only(right: 5),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.location_on,
                    color: Colors.greenAccent,
                    size: 28,
                  ),
                  onPressed: () async {
                    final controller = ref.read(
                      pilgrimTrackingControllerProvider.notifier,
                    );

                    // ✅ إذا كانت الـ streams مغلقة (أي أُعيد فتح التطبيق بعد إغلاقه)
                    // → أعد التتبع بدون إرسال طلب للـ API
                    // ✅ إذا كانت الـ streams مفتوحة بالفعل
                    // → تجاهل الاستدعاء (resumeTrackingStreams تتحقق داخلياً)
                    if (!controller.isActivelyTracking) {
                      await controller.resumeTrackingStreams(
                        sessionId: activeSessionId,
                        pilgrimId: profile.userId.toString(),
                        pilgrimName: profile.fullName,
                      );
                    }

                    if (context.mounted) {
                      Navigator.of(context).pushNamed(
                        AppRoute.pilgrimMapTrackingView,
                        arguments: activeSessionId,
                      );
                    }
                  },
                ),
              );
            },
          ),

        // 🌟 3. الـ Badge حول أيقونة الجرس
        if (profile.userRole != "مدير الحملة")
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
