import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/features/home/presentation/widgets/PrayerItem.dart';

class PrayerTimesWidget extends StatefulWidget {
  const PrayerTimesWidget({super.key});

  @override
  State<PrayerTimesWidget> createState() => _PrayerTimesWidgetState();
}

class _PrayerTimesWidgetState extends State<PrayerTimesWidget> {
  late PrayerTimes prayerTimes;

  @override
  void initState() {
    super.initState();

    final coordinates = Coordinates(21.4225, 39.8262); // مكة
    final params = CalculationMethod.umm_al_qura.getParameters();

    prayerTimes = PrayerTimes(
      coordinates,
      DateComponents.from(DateTime.now()),
      params,
    );
  }

  String formatTime(DateTime time) {
    return DateFormat('h:mm').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColor.withe,
        border: Border.all(color: AppColor.goldenWithOpacity),
        borderRadius: BorderRadius.circular(40.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            offset: const Offset(0, 1),
            blurRadius: 3,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: -1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PrayerItem(
            name: "الفجر",
            time: formatTime(prayerTimes.fajr),
            icon: Icons.nightlight_round,
          ),
          PrayerItem(
            name: "الظهر",
            time: formatTime(prayerTimes.dhuhr),
            icon: Icons.wb_sunny_outlined,
          ), // يمكنك استبدالها بأيقونة SVG
          PrayerItem(
            name: "العصر",
            time: formatTime(prayerTimes.asr),
            icon: Icons.wb_sunny,
          ),
          PrayerItem(
            name: "المغرب",
            time: formatTime(prayerTimes.maghrib),
            icon: Icons.wb_twilight,
          ),
          PrayerItem(
            name: "العشاء",
            time: formatTime(prayerTimes.isha),
            icon: Icons.nights_stay,
          ),
        ],
      ),
    );
  }
}
