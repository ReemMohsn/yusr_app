// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:yusr/core/common/widgets/custom_golden_back_button.dart';
// import 'package:yusr/core/common/widgets/custom_text_field.dart';
// import 'package:yusr/core/constants/app_size.dart';
// import 'package:yusr/core/extensions/context_extension.dart';
// import 'package:yusr/features/announcements_notifications/presentation/widgets/add_botton.dart';
// import 'package:yusr/features/announcements_notifications/presentation/widgets/announcement_card.dart';

// class AnnouncementsView extends ConsumerStatefulWidget {
//   const AnnouncementsView({super.key});

//   @override
//   ConsumerState<AnnouncementsView> createState() => _AnnouncementsViewState();
// }

// class _AnnouncementsViewState extends ConsumerState<AnnouncementsView> {
//   @override
//   Widget build(BuildContext context) {
//     final locale = context.locale;
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         title: Text('الإعلانات'),
//         leading: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 10.w),
//           child: const UnconstrainedBox(child: CustomGoldenBackButton()),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(AppSize.paddingOfPage),
//         child: ListView(
//           physics: const BouncingScrollPhysics(),
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: CustomTextField(
//                     hintText: 'ابحث عن إعلان...',
//                     prefixIcon: Icons.search,
//                     textInputAction: TextInputAction.search,
//                   ),
//                 ),
//                 SizedBox(width: 12.w),

//                 AddBotton(),
//               ],
//             ),
//             const SizedBox(height: 20),

//             AnnouncementCard(
//               date: '١٥ يناير ٢٠٢٦',
//               title: 'تحديث مواعيد الإفطار الجماعي',
//               description:
//                   'يُرجى العلم بأن تم تعديل مواعيد الإفطار الجماعي في الخيام المركزية لتبدأ من الساعة السادسة مساءً',
//               time: '14:30',
//               tag: 'جميع الحجاج',
//             ),
//             AnnouncementCard(
//               date: '١٥ يناير ٢٠٢٦',
//               title: 'إرشادات السلامة في المشاعر المقدسة',
//               description:
//                   'نود تذكيركم بضرورة الالتزام بإرشادات السلامة أثناء التنقل بين المشاعر المقدسة، والحفاظ على ...',
//               time: '14:30',
//               tag: 'جميع الحجاج',
//             ),
//             AnnouncementCard(
//               date: '١٥ يناير ٢٠٢٦',
//               title: 'توزيع الحقائب الطبية',
//               description:
//                   'سيتم توزيع الحقائب الطبية الإسعافية على جميع المجموعات في تمام الساعة الثانية عصراً يوم غد،',
//               time: '14:30',
//               tag: 'المشرفين',
//             ),
//             AnnouncementCard(
//               date: '١٥ يناير ٢٠٢٦',
//               title: 'تنبيه حالة الطقس',
//               description:
//                   'تشير التوقعات الجوية إلى ارتفاع في درجات الحرارة خلال الأيام القادمة، يُرجى أخذ الاحتياطات',
//               time: '14:30',
//               tag: 'جميع الحجاج',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/common/widgets/custom_golden_back_button.dart';
import 'package:yusr/core/common/widgets/custom_text_field.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/announcements_notifications/presentation/widgets/add_botton.dart';
import 'package:yusr/features/announcements_notifications/presentation/widgets/announcement_card.dart';
import 'package:yusr/features/announcements_notifications/providers/announcements_provider.dart';
// استدعِ ملفات الكنترولر والموديل هنا

class AnnouncementsView extends ConsumerStatefulWidget {
  const AnnouncementsView({super.key});

  @override
  ConsumerState<AnnouncementsView> createState() => _AnnouncementsViewState();
}

class _AnnouncementsViewState extends ConsumerState<AnnouncementsView> {
  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    // 🌟 مراقبة حالة الإعلانات (تحميل، خطأ، أو داتا)
    final announcementsState = ref.watch(announcementsProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(locale.announcements),
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: const UnconstrainedBox(child: CustomGoldenBackButton()),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSize.paddingOfPage),
        child: Column(
          children: [
            // 🌟 قسم البحث وزر الإضافة (ثابت في الأعلى)
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    hintText: locale.announcementSearch,
                    prefixIcon: Icons.search,
                    textInputAction: TextInputAction.search,
                  ),
                ),
                SizedBox(width: 12.w),
                AddBotton(
                  onTap: () {
                    Navigator.of(
                      context,
                    ).pushNamed(AppRoute.addAnnouncementView);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 🌟 قائمة الإعلانات (تتعامل مع جميع حالات الـ API)
            Expanded(
              child: announcementsState.when(
                // 1. حالة التحميل
                loading: () => const Center(child: CircularProgressIndicator()),

                // 2. حالة الخطأ
                error: (error, stackTrace) => Center(
                  child: Text(
                    '${locale.errorFetchingAnnouncements}\n$error',
                    textAlign: TextAlign.center,
                  ),
                ),

                // 3. حالة النجاح ووجود البيانات
                data: (announcementsList) {
                  if (announcementsList.isEmpty) {
                    return Center(
                      child: Text('${locale.noAnnouncementsCurrently}'),
                    );
                  }

                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: announcementsList.length,
                    itemBuilder: (context, index) {
                      final announcement = announcementsList[index];
                      return AnnouncementCard(
                        date: announcement.sentAtDate, // تمرير التاريخ
                        title: announcement.title, // تمرير العنوان
                        description: announcement.body, // تمرير التفاصيل
                        time: announcement.sentAtTime, // تمرير الوقت
                        tag: announcement
                            .targetAudienceName, // تمرير الجمهور المستهدف
                      );
                    },
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
