import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/features/home/presentation/widgets/PreparationCard.dart';
import 'package:yusr/features/home/presentation/widgets/campaign_location_card.dart';
import 'package:yusr/features/home/presentation/widgets/hajj_status_card_widget.dart';
import 'package:yusr/features/home/presentation/widgets/prayer_times_widget.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const HajjStatusCard(),
          SizedBox(height: 30.h),
          Text(
            "مواقيت الصلاة",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20.h),
          const PrayerTimesWidget(),
          SizedBox(height: 60.h),

          const PreparationCard(), // 👈 الكرت الجديد
          SizedBox(height: 30.h),
          Text(
            "موقع استقرار الحملة",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 12.sp,
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

          // if (role == UserRole.guest)
          // const RitualsPreparationCard(),
          // else
          // const CampaignLocationCard(), تظهر "لا يوجد" أو الموقع الفعلي حسب البيانات