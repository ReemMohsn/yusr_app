import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/common/widgets/custom_golden_back_button.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/be_leader/presentation/widgets/pilgrim_list_item_widget.dart';
import 'package:yusr/features/be_leader/presentation/widgets/stat_card_widget.dart';
import 'package:yusr/features/be_leader/providers/pilgrims_list_provider.dart';

class LeaderPilgrimsListView extends ConsumerWidget {
  final int sessionId;

  const LeaderPilgrimsListView({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale;

    // مراقبة البروفايدر الذي يجلب قائمة الحجاج بناءً على رقم الجلسة
    final pilgrimsAsyncValue = ref.watch(pilgrimsListProvider(sessionId));

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(locale.becomeALeader),
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: const UnconstrainedBox(child: CustomGoldenBackButton()),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            // زر عرض الخريطة
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.golden,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AppRoute.leaderMapTrackingView,
                    arguments: sessionId,
                  );
                },
                icon: Icon(Icons.map_outlined, color: AppColor.withe),
                label: Text(
                  locale.showMap,
                  style: TextStyle(color: AppColor.withe, fontSize: 14.sp),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // التعامل مع حالات جلب البيانات (تحميل، خطأ، نجاح)
            Expanded(
              child: pilgrimsAsyncValue.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColor.golden),
                ),
                error: (error, stack) =>
                    Center(child: Text('${locale.errorOccurred}: $error')),
                data: (pilgrimsList) {
                  // حساب الإحصائيات من القائمة الحقيقية
                  final acceptedCount = pilgrimsList
                      .where((p) => p.statusId == 2)
                      .length;
                  final pendingCount = pilgrimsList
                      .where((p) => p.statusId == 1)
                      .length;
                  final rejectedCount = pilgrimsList
                      .where((p) => p.statusId == 3)
                      .length;
                  final notActiveCount = pilgrimsList
                      .where((p) => p.statusId == 4)
                      .length;
                  return Column(
                    children: [
                      // 1. بطاقات الإحصائيات (مربوطة بالبيانات)
                      SizedBox(
                        height: 100.h, // تحديد ارتفاع مناسب للحاوية
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            StatCardWidget(
                              title: locale.accepted,
                              count: acceptedCount.toString(),
                              color: Colors.green,
                              icon: Icons.check_circle_outline,
                            ),
                            SizedBox(width: 12.w),
                            StatCardWidget(
                              title: locale.pending,
                              count: pendingCount.toString(),
                              color: Colors.orange,
                              icon: Icons.access_time,
                            ),
                            SizedBox(width: 12.w),
                            StatCardWidget(
                              title: locale.rejected,
                              count: rejectedCount.toString(),
                              color: Colors.red,
                              icon: Icons.cancel_outlined,
                            ),
                            SizedBox(width: 12.w),
                            StatCardWidget(
                              title: locale.notActive,
                              count: notActiveCount.toString(),
                              color: Colors.grey,
                              icon: Icons.do_not_disturb_on_outlined,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // 2. عنوان قائمة الحجاج
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        decoration: BoxDecoration(
                          color: AppColor.golden,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          locale.pilgrimsListTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColor.withe,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),

                      // 3. عرض قائمة الحجاج
                      Expanded(
                        child: pilgrimsList.isEmpty
                            ? Center(child: Text(locale.noPilgrimsInSession))
                            : ListView.separated(
                                itemCount: pilgrimsList.length,
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 8.h),
                                itemBuilder: (context, index) {
                                  final pilgrim = pilgrimsList[index];
                                  return PilgrimListItemWidget(
                                    pilgrim: pilgrim,
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
