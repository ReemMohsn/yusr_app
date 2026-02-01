import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_image.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/features/home/data/models/navigation_item_model.dart';
import 'package:yusr/features/home/presentation/views/home_view.dart';
import 'package:yusr/features/home/providers/current_index_controller.dart';
import 'package:flutter_svg/svg.dart';

class MainHomeView extends ConsumerWidget {
  const MainHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final role = ref.watch(userRoleProvider);
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
      // // القائمة الجانبية تظهر فقط إذا لم يكن زائراً (أو حسب رغبتك)
      // endDrawer: role == UserRole.guest ? null : const CustomDrawer(),
      appBar: AppBar(
        // // إذا كان زائراً، نعرض زر تسجيل الدخول
        // // إذا كان مستخدماً، نعرض أيقونة القائمة والجرس
        // leading: role == UserRole.guest
        //     ? TextButton(child: Text("تسجيل الدخول"), onPressed: (){/* Go to login */})
        //     : IconButton(icon: Icon(Icons.notifications), onPressed: (){}),
        title: TextButton(
          child: Text("تسجيل الدخول"),
          onPressed: () {
            Navigator.pushNamed(context, AppRoute.loginView);
          },
        ),
        // actions: [
        //   // if (role != UserRole.guest)
        //      Builder(builder: (context) => IconButton(
        //         icon: Icon(Icons.menu),
        //         onPressed: () => Scaffold.of(context).openEndDrawer(),
        //      )),
        // ],
      ),
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
}
