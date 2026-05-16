import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/campaign_location/providers/get_locations_provider.dart';
import 'package:yusr/features/home/providers/user_provider.dart';

/// Shows the campaign's current base location on the home screen.
///
/// - **Visitor** → placeholder prompting login (unchanged).
/// - **Logged-in user** → fetches the real current location from the API and
///   displays it. Tapping navigates to the full [CampaignLocationView].
class CampaignLocationCard extends ConsumerWidget {
  const CampaignLocationCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale;
    final profile = ref.watch(userProfileProvider).asData?.value;
    final bool isLoggedIn = profile != null;

    // ── Visitor view (unchanged) ──────────────────────────────────────────
    if (!isLoggedIn) {
      return LocationCardShell(
        icon: Icons.location_on_outlined,
        title: locale.notFound,
        subtitle: locale.loginToViewCampaignLocation,
        onTap: null,
      );
    }

    // ── Logged-in view ────────────────────────────────────────────────────
    final locationsAsync = ref.watch(getCampaignLocationsProvider);

    return locationsAsync.when(
      loading: () => LocationCardShell(
        icon: Icons.location_on_outlined,
        title: '...',
        subtitle: locale.campaignLocation,
        onTap: null,
      ),
      error: (_, __) => LocationCardShell(
        icon: Icons.location_off_outlined,
        title: locale.notFound,
        subtitle: locale.fetchDataError,
        onTap: () => ref.invalidate(getCampaignLocationsProvider),
      ),
      data: (data) {
        final current = data?.currentLocation;
        final title = current?.locationName ?? locale.notFound;
        final subtitle = current?.description ?? locale.loginToViewCampaignLocation;

        return LocationCardShell(
          icon: Icons.location_on_outlined,
          title: title,
          subtitle: subtitle,
          onTap: () => Navigator.pushNamed(context, AppRoute.campaignLocationView),
        );
      },
    );
  }
}

// ─── Shared card shell ────────────────────────────────────────────────────────

class LocationCardShell extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const LocationCardShell({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColor.withe,
          border: Border.all(color: AppColor.goldenWithOpacity),
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              offset: const Offset(0, 1),
              blurRadius: 3,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Icon ──
            Container(
              width: 39.w,
              height: 39.w,
              decoration: BoxDecoration(
                color: AppColor.goldenWithOpacity,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColor.golden, size: 20.sp),
            ),
            SizedBox(width: 8.w),

            // ── Text ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.darkBlack,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColor.midlineColor,
                    ),
                  ),
                ],
              ),
            ),

            // ── Chevron (only when tappable) ──
            if (onTap != null)
              Icon(Icons.chevron_right, color: AppColor.golden, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
