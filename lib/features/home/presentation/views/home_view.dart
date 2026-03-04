import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/home/presentation/widgets/PreparationCard.dart';
import 'package:yusr/features/home/presentation/widgets/campaign_location_card.dart';
import 'package:yusr/features/home/presentation/widgets/hajj_status_card_widget.dart';
import 'package:yusr/features/home/presentation/widgets/prayer_times_widget.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HajjStatusCard(),
          SizedBox(height: 30.h),
          Text(
            locale.prayerTimes,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20.h),
          const PrayerTimesWidget(),
          SizedBox(height: 60.h),
          const PreparationCard(),
          SizedBox(height: 30.h),
          Text(
            locale.campaignLocation,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20.h),
          CampaignLocationCard(),
        ],
      ),
    );
  }
}
