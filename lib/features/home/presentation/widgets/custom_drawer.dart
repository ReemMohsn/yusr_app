import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/extensions/async_value_ui.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/auth/providers/logout_controller_provider.dart';
import 'package:yusr/features/home/presentation/widgets/build_drawer_header.dart';
import 'package:yusr/features/home/presentation/widgets/build_logout_button.dart';
import 'package:yusr/features/home/presentation/widgets/build_menu_item.dart';
import 'package:yusr/features/home/providers/user_provider.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale;

    ref.listen<AsyncValue<void>>(logoutControllerProvider, (_, state) {
      if (state.isLoading) {
        context.showLoadingDialog();
      } else {
        context.closeLoadingDialog();
        if (state.hasError) {
          context.showErrorSnackBar(state.errorMessage);
          print(state.errorMessage);
        } else {
          context.showSuccessSnackBar(locale.logoutSuccessMessage);
          ref.invalidate(userProfileProvider);
          Navigator.of(context).pushNamed(AppRoute.loginView);
        }
      }
    });

    final userState = ref.watch(userProfileProvider);
    return Drawer(
      backgroundColor: AppColor.baseFontColor,
      child: userState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (profile) {
          return Column(
            children: [
              // 1. رأس القائمة (Header)
              BuildDrawerHeader(profile: profile!),

              // 2. خيارات القائمة بناءً على الدور
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: _buildMenuItems(context, profile.userRole),
                  ),
                ),
              ),

              // 3. زر تسجيل الخروج
              BuildLogoutButton(context: context, ref: ref),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildMenuItems(BuildContext context, String role) {
    final locale = context.locale;
    switch (role.toLowerCase()) {
      case 'مشرف':
        return [
          BuildMenuItem(
            context: context,
            title: locale.becomeALeader,
            icon: Icons.workspace_premium_outlined,
            onTap: () {},
          ),
          BuildMenuItem(
            context: context,
            title: locale.announcements,
            icon: Icons.campaign_outlined,
            onTap: () {},
          ),
          BuildMenuItem(
            context: context,
            title: locale.groupInfo,
            icon: Icons.info_outline,
            onTap: () {},
          ),
          BuildMenuItem(
            context: context,
            title: locale.hajjRituals,
            icon: Icons.menu_book_outlined,
            onTap: () {},
          ),
        ];
      case 'مدير الحملة':
        return [
          BuildMenuItem(
            context: context,
            title: locale.announcements,
            icon: Icons.campaign_outlined,
            onTap: () {},
          ),
          BuildMenuItem(
            context: context,
            title: locale.campaignLocation,
            icon: Icons.location_on_outlined,
            onTap: () {},
          ),
          BuildMenuItem(
            context: context,
            title: locale.hajjRituals,
            icon: Icons.menu_book_outlined,
            onTap: () {},
          ),
        ];
      case 'الحاج':
        return [
          BuildMenuItem(
            context: context,
            title: locale.groupInfo,
            icon: Icons.info_outline,
            onTap: () {},
          ),
          BuildMenuItem(
            context: context,
            title: locale.hajjRituals,
            icon: Icons.menu_book_outlined,
            onTap: () {},
          ),
        ];
      default:
        return [];
    }
  }
}
