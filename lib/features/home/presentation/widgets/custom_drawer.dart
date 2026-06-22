import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/common/providers/shared_preferences_service_provider.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/constants/shared_preferences_keys.dart';
import 'package:yusr/core/extensions/async_value_ui.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/auth/providers/logout_controller_provider.dart';
import 'package:yusr/features/be_leader/providers/be_leader_repository_provider.dart';
import 'package:yusr/features/be_leader/providers/leader_tracking_controller.dart';
import 'package:yusr/features/be_leader/providers/tracking_repository_provider.dart';
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
                    children: _buildMenuItems(context, ref, profile.userRole),
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

  List<Widget> _buildMenuItems(
    BuildContext context,
    WidgetRef ref,
    String role,
  ) {
    final locale = context.locale;
    switch (role.toLowerCase()) {
      case 'مشرف':
        return [
          BuildMenuItem(
            context: context,
            title: locale.becomeALeader,
            icon: Icons.workspace_premium_outlined,
            onTap: () async {
              final sharedPrefs = ref.read(sharedPreferencesServiceProvider);
              int? activeSessionId = await sharedPrefs.getInt(
                SharedPreferencesKeys.currentSessionId,
              );
              // 🛑إضافة التحقق من الباك إند إذا لم نجد الجلسة محلياً (تمت معالجة حالة إلغاء التثبيت)
              if (activeSessionId == null || activeSessionId == 0) {
                context.showLoadingDialog();
                try {
                  final apiRepo = ref.read(leaderTrackingApiRepositoryProvider);
                  final response = await apiRepo.getActiveSession();
                  if (response.data != null && response.data!.sessionId > 0) {
                    activeSessionId = response.data!.sessionId;
                    // نحفظه محلياً لكي لا نطلبه مرة أخرى
                    await sharedPrefs.setInt(
                      SharedPreferencesKeys.currentSessionId,
                      activeSessionId,
                    );
                  }
                } catch (e) {
                  // نتجاهل الخطأ ونفترض أنه لا توجد جلسة
                }
                if (!context.mounted) return;
                context.closeLoadingDialog();
              }

              if (activeSessionId != null && activeSessionId > 0) {
                // 🚀 التحقق الأول: هل الوظيفة تعمل حالياً في الذاكرة؟
                final isAlreadyRunning = ref
                    .read(leaderTrackingControllerProvider.notifier)
                    .isCurrentlyTracking;

                if (isAlreadyRunning) {
                  Navigator.of(context).pushNamed(
                    AppRoute.leaderPilgrimsListView,
                    arguments: activeSessionId,
                  );
                  return; // نخرج من الدالة
                }

                // 🛑 التحقق الثاني (نسأل الفايربيس):
                // نفتح التحميل (والقائمة الجانبية لا تزال مفتوحة لكي يبقى السياق context حياً)
                context.showLoadingDialog();

                final repo = ref.read(trackingRepositoryProvider);
                final lastUpdate = await repo.getLeaderLastUpdate(
                  activeSessionId.toString(),
                );

                bool isSessionExpired = true; // نفترض أنها منتهية كإجراء أمني

                if (lastUpdate != null) {
                  final currentTime = DateTime.now().millisecondsSinceEpoch;
                  final differenceInMinutes =
                      (currentTime - lastUpdate) / (1000 * 60);

                  if (differenceInMinutes < 30) {
                    isSessionExpired = false; // الجلسة لا زالت صالحة
                  }
                }
                context.closeLoadingDialog(); // إخفاء التحميل بأمان

                if (isSessionExpired) {
                  // 🔴 الجلسة ميتة
                  await ref
                      .read(leaderTrackingControllerProvider.notifier)
                      .cleanUpGhostSession(activeSessionId);

                  if (!context.mounted) return;
                  context.showErrorSnackBar(
                    'انتهت صلاحية جلستك السابقة لعدم نشاطك لأكثر من 30 دقيقة.',
                  );
                  Navigator.of(
                    context,
                  ).pushNamed(AppRoute.leaderStartSessionView);
                } else {
                  // 🟢 الجلسة صالحة
                  ref
                      .read(leaderTrackingControllerProvider.notifier)
                      .startTracking(activeSessionId);

                  if (!context.mounted) return;
                  Navigator.of(context).pushNamed(
                    AppRoute.leaderPilgrimsListView,
                    arguments: activeSessionId,
                  );
                }
              } else {
                // لا توجد جلسة من الأساس
                Navigator.of(
                  context,
                ).pushNamed(AppRoute.leaderStartSessionView);
              }
            },
          ),

          BuildMenuItem(
            context: context,
            title: locale.announcements,
            icon: Icons.campaign_outlined,
            onTap: () =>
                Navigator.of(context).pushNamed(AppRoute.announcementsView),
          ),
          BuildMenuItem(
            context: context,
            title: locale.groupInfo,
            icon: Icons.info_outline,
            onTap: () {
              Navigator.pop(context); // close drawer
              Navigator.of(context).pushNamed(AppRoute.supervisorGroupView);
            },
          ),
          BuildMenuItem(
            context: context,
            title: locale.hajjRituals,
            icon: Icons.menu_book_outlined,
            onTap: () =>
                Navigator.of(context).pushNamed(AppRoute.instructionsView),
          ),
        ];
      case 'مدير الحملة':
        return [
          BuildMenuItem(
            context: context,
            title: 'عن الحملة',
            icon: Icons.info_outline,
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(AppRoute.campaignInfoView);
            },
          ),
          BuildMenuItem(
            context: context,
            title: locale.announcements,
            icon: Icons.campaign_outlined,
            onTap: () =>
                Navigator.of(context).pushNamed(AppRoute.announcementsView),
          ),
          BuildMenuItem(
            context: context,
            title: locale.campaignLocation, // "موقع استقرار الحملة"
            icon: Icons.location_on_outlined, // أيقونة الموقع
            onTap: () {
              Navigator.pop(
                context,
              ); // إغلاق القائمة الجانبية أولاً (مهم جداً للاحترافية)
              Navigator.of(
                context,
              ).pushNamed(AppRoute.campaignLocationView); // الانتقال للصفحة
            },
          ),
          BuildMenuItem(
            context: context,
            title: locale.hajjRituals,
            icon: Icons.menu_book_outlined,
            onTap: () =>
                Navigator.of(context).pushNamed(AppRoute.instructionsView),
          ),
        ];
      case 'حاج':
        return [
          BuildMenuItem(
            context: context,
            title: locale.groupInfo,
            icon: Icons.info_outline,
            onTap: () {
              Navigator.pop(context); // close drawer
              Navigator.of(context).pushNamed(AppRoute.groupInfoView);
            },
          ),
          BuildMenuItem(
            context: context,
            title: locale.hajjRituals,
            icon: Icons.menu_book_outlined,
            onTap: () =>
                Navigator.of(context).pushNamed(AppRoute.instructionsView),
          ),
        ];
      default:
        return [];
    }
  }
}
