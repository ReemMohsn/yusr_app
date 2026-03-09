import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/common/widgets/custom_golden_back_button.dart';
import 'package:yusr/core/common/widgets/custom_text_field.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/announcements_notifications/presentation/widgets/add_botton.dart';
import 'package:yusr/features/announcements_notifications/presentation/widgets/announcement_card.dart';

class AnnouncementsView extends ConsumerStatefulWidget {
  const AnnouncementsView({super.key});

  @override
  ConsumerState<AnnouncementsView> createState() => _AnnouncementsViewState();
}

class _AnnouncementsViewState extends ConsumerState<AnnouncementsView> {
  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('الإعلانات'),
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: const UnconstrainedBox(child: CustomGoldenBackButton()),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSize.paddingOfPage),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    hintText: 'ابحث عن إعلان...',
                    prefixIcon: Icons.search,
                    textInputAction: TextInputAction.search,
                  ),
                ),
                SizedBox(width: 12.w),

                AddBotton(),
              ],
            ),
            const SizedBox(height: 20),

            AnnouncementCard(
              date: '١٥ يناير ٢٠٢٦',
              title: 'تحديث مواعيد الإفطار الجماعي',
              description:
                  'يُرجى العلم بأن تم تعديل مواعيد الإفطار الجماعي في الخيام المركزية لتبدأ من الساعة السادسة مساءً',
              time: '14:30',
              tag: 'جميع الحجاج',
            ),
            AnnouncementCard(
              date: '١٥ يناير ٢٠٢٦',
              title: 'إرشادات السلامة في المشاعر المقدسة',
              description:
                  'نود تذكيركم بضرورة الالتزام بإرشادات السلامة أثناء التنقل بين المشاعر المقدسة، والحفاظ على ...',
              time: '14:30',
              tag: 'جميع الحجاج',
            ),
            AnnouncementCard(
              date: '١٥ يناير ٢٠٢٦',
              title: 'توزيع الحقائب الطبية',
              description:
                  'سيتم توزيع الحقائب الطبية الإسعافية على جميع المجموعات في تمام الساعة الثانية عصراً يوم غد،',
              time: '14:30',
              tag: 'المشرفين',
            ),
            AnnouncementCard(
              date: '١٥ يناير ٢٠٢٦',
              title: 'تنبيه حالة الطقس',
              description:
                  'تشير التوقعات الجوية إلى ارتفاع في درجات الحرارة خلال الأيام القادمة، يُرجى أخذ الاحتياطات',
              time: '14:30',
              tag: 'جميع الحجاج',
            ),
          ],
        ),
      ),
    );
  }
}
