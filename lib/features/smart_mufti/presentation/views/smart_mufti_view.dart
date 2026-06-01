import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/common/widgets/custom_big_button.dart';
import 'package:yusr/core/extensions/async_value_ui.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/core/services/errors/exception.dart';
import 'package:yusr/features/smart_mufti/data/models/mufti_response_model.dart';
import 'package:yusr/features/smart_mufti/presentation/widgets/mufti_header_section_widget.dart';
import 'package:yusr/features/smart_mufti/presentation/widgets/question_card_widget.dart';
import 'package:yusr/features/smart_mufti/presentation/widgets/sharia_answer_card_widget.dart';
import 'package:yusr/features/smart_mufti/presentation/widgets/smart_mufti_button_widget.dart';
import 'package:yusr/features/smart_mufti/providers/mufti_controller_provider.dart';

class SmartMuftiView extends ConsumerStatefulWidget {
  const SmartMuftiView({super.key});

  @override
  ConsumerState<SmartMuftiView> createState() => _SmartMuftiViewState();
}

class _SmartMuftiViewState extends ConsumerState<SmartMuftiView> {
  // 1. تعريف الكنترولر بشكل مباشر تماماً مثل صفحة الإعلانات والموقع
  final TextEditingController _questionController = TextEditingController();

  @override
  void dispose() {
    // التأكد من تدمير الكنترولر وتنظيف الذاكرة فور إغلاق الشاشة
    _questionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // تصفير حالة الإجابة فور الدخول للشاشة لكي تبدأ نظيفة ومستقرة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(muftiControllerProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    // مراقبة حالة المفتي (الـ State الخاص بالـ API)
    final muftiState = ref.watch(muftiControllerProvider);

    // 2. الاستماع للحالات (نفس الأسلوب الموحد والمختصر للمشروع) بدون LoadingDialog
    ref.listen(muftiControllerProvider, (_, state) {
      if (!state.isLoading && state.hasError) {
        context.showErrorSnackBar(state.errorMessage);
      } else if (state.hasValue && !state.isLoading && state.value != null) {
        // تم إلغاء _questionController.clear() لتبقى تجربة المستخدم سلسة ويقرأ سؤاله مع الإجابة
        // يمكنكِ هنا فقط إظهار رسالة تنبيهية خفيفة بالنجاح إذا أردتِ
      }
    });

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MuftiHeaderSection(
            title: locale.askForFatwa,
            subtitle: locale.smartMuftiHelper,
          ),

          SizedBox(height: 24.h),

          QuestionCard(
            label: locale.yourQuestion,
            hint: locale.questionExample,
            controller: _questionController,
          ),

          SizedBox(height: 20.h),

          SizedBox(
            width: double.infinity,
            child: SmartMuftiButtonWidget(
              text: locale.getAnswer,
              icon: Icons.auto_awesome,
              // 4. تمرير حالة التحميل للزر مباشرة ليظهر مؤشر التحميل داخله
              isLoading: muftiState.isLoading,
              onPressed: muftiState.isLoading
                  ? () {} // تعطيل الزر أثناء التحميل لمنع تكرار الطلبات
                  : () {
                      if (_questionController.text.trim().isNotEmpty) {
                        FocusScope.of(context).unfocus();
                        ref
                            .read(muftiControllerProvider.notifier)
                            .sendQuestion(_questionController.text.trim());
                      } else {
                        context.showErrorSnackBar(locale.fieldRequired);
                      }
                    },
            ),
          ),

          SizedBox(height: 24.h),

          ShariaAnswerCardWidget(
            title: locale.shariaAnswer,
            isLoading: muftiState.isLoading,
            content: muftiState.when(
              // حالة النجاح: عرض الإجابة أو الـ Placeholder من ملف الترجمة
              data: (response) =>
                  response?.data?.answer ?? locale.shariaAnswerPlaceholder,

              // حالة الخطأ: التعديل المطلوب لعرض رسالة السيرفر أو رسالة الخطأ الافتراضية
              error: (err, stack) {
                // إذا كان الخطأ يحتوي على رسالة من السيرفر (detail) نعرضها
                // وإلا نعود لملف الترجمة الموحد للمشروع
                if (err is ServerException &&
                    err.errModel.errorMessage.isNotEmpty) {
                  return err.errModel.errorMessage;
                }
                return locale.fetchDataError;
              },

              loading: () => "",
            ),
          ),

          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
