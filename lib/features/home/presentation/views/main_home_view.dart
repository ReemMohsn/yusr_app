import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_image.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/features/auth/data/models/login_model.dart';
import 'package:yusr/features/home/data/models/navigation_item_model.dart';
import 'package:yusr/features/home/presentation/views/home_view.dart';
import 'package:yusr/features/home/presentation/widgets/custom_drawer.dart';
import 'package:yusr/features/home/providers/current_index_controller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yusr/features/home/providers/user_provider.dart';

class MainHomeView extends ConsumerWidget {
  const MainHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileState = ref.watch(userProfileProvider);
    final profile = userProfileState.asData?.value;
    final bool isLoggedIn = profile != null;

    final List<NavigationItemModel> _itemsData = [
      NavigationItemModel(
        label: 'الرئيسية',
        page: const HomeView(),
        activeIconPath: AppImage.homeIcon,
      ),
      NavigationItemModel(
        label: 'عداد المناسك',
        page: const Placeholder(),
        activeIconPath: AppImage.timerIcon,
      ),
      NavigationItemModel(
        label: 'المفتي الذكي',
        page: const Placeholder(),
        activeIconPath: AppImage.smartMoftiIcon,
      ),
      NavigationItemModel(
        label: 'ارجعني',
        page: const Placeholder(),
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
        leadingWidth: isLoggedIn ? 100 : 120,
        leading: isLoggedIn
            ? _buildLoggedInLeading(profile!) // عرض البروفايل + الجرس
            : TextButton(
                // عرض زر تسجيل الدخول للزائر
                onPressed: () {
                  Navigator.pushNamed(context, AppRoute.loginView);
                },
                child: const Text(
                  "تسجيل الدخول",
                  style: TextStyle(
                    color: AppColor.golden,
                    fontWeight: FontWeight.bold,
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
          children: _itemsData.map((e) => e.page).toList(),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColor.darkBlack,
        selectedIndex: currentIndex,
        onDestinationSelected: (int newIndex) {
          currentIndexNotifier.setIndex(newIndex);
        },
        destinations: _itemsData.map((item) {
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
  Widget _buildLoggedInLeading(ProfileModel profile) {
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
        const Icon(Icons.notifications_none_outlined, color: AppColor.golden),
      ],
    );
  }
}
