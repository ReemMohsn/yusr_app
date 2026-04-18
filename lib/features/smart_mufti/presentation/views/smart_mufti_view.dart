// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:yusr/core/common/widgets/widget.dart';
// import 'package:yusr/core/extensions/context_extension.dart';
// import 'package:yusr/features/smart_mufti/presentation/widgets/mufti_header_section_widget.dart';
// import 'package:yusr/features/smart_mufti/presentation/widgets/question_card_widget.dart';
// import 'package:yusr/features/smart_mufti/presentation/widgets/sharia_answer_card_widget.dart';

// class SmartMuftiView extends ConsumerWidget {
//   const SmartMuftiView({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final locale = context.locale;

//     // نرجّع محتوى الشاشة فقط (بدون AppBar أو BottomBar)
//     return SingleChildScrollView(
//       physics: const BouncingScrollPhysics(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // 1. العنوان والوصف (تم استدعاؤها من locale)
//           MuftiHeaderSection(
//             title: locale.smartMufti,
//             subtitle: locale.ritualsPreparationDesc,
//           ),
          
//           SizedBox(height: 24.h),

//           // 2. كرت إدخال السؤال (تم استبدال النص المباشر بـ locale)
//           QuestionCard(
//             label: locale.enterRequiredData,
//             hint: locale.writeYourFatwaQuestion,
//           ),
          
//           SizedBox(height: 20.h),

//           // 3. زر الحصول على الفتوى (تم استبدال النص المباشر بـ locale)
//           SizedBox(
//             width: double.infinity,
//             child: CustomBigButton(
//               text: locale.sendQuestion, 
//               onPressed: () {
//                 // هنا نربط الـ Logic مستقبلاً
//               },
//             ),
//           ),
          
//           SizedBox(height: 24.h),

//           // 4. كرت عرض الإجابة (تم استبدال النصوص المباشرة بـ locale)
//           ShariaAnswerCard(
//             title: locale.detiles,
//             content: locale.waitingForYourQuestion,
//           ),

//           // مسافة إضافية عشان ما يختفي المحتوى تحت الشريط السفلي
//           SizedBox(height: 40.h),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:yusr/core/common/widgets/widget.dart';
// import 'package:yusr/core/extensions/context_extension.dart';
// import 'package:yusr/features/smart_mufti/data/models/mufti_response_model.dart';
// import 'package:yusr/features/smart_mufti/presentation/widgets/mufti_header_section_widget.dart';
// import 'package:yusr/features/smart_mufti/presentation/widgets/question_card_widget.dart';
// import 'package:yusr/features/smart_mufti/presentation/widgets/sharia_answer_card_widget.dart';
// import 'package:yusr/features/smart_mufti/presentation/widgets/smart_mufti_button_widget.dart';
// import 'package:yusr/features/smart_mufti/providers/mufti_controller_provider.dart'; // استيراد البروفايدر

// class SmartMuftiView extends ConsumerWidget {
//   const SmartMuftiView({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final locale = context.locale;
//     // تعريف المتحكم هنا (داخل الـ build في ConsumerWidget مسموح لأنه Stateless)
//     final questionController = TextEditingController();
    
//     // مراقبة حالة الكنترولر لعرض الإجابة
//     final muftiState = ref.watch(muftiControllerProvider);

//     // الاستماع للحالات (تحميل، خطأ، نجاح) مثل مثال الفريق
//     ref.listen<AsyncValue<MuftiState>>(
//       muftiControllerProvider,
//       (prev, next) {
//         if (next.isLoading) {
//           context.showLoadingDialog();
//         } else if (next.hasError) {
//           context.closeLoadingDialog();
//           context.showErrorSnackBar(next.error.toString());
//         } else if (next.hasValue && !next.isLoading && next.value != null) {
//           context.closeLoadingDialog();
//           // عرض رسالة نجاح إذا أردتِ أو الاكتفاء بعرض الإجابة في الكرت
//         }
//       },
//     );

//     return SingleChildScrollView(
//       physics: const BouncingScrollPhysics(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           MuftiHeaderSection(
//             title: locale.askForFatwa,
//             subtitle: locale.smartMuftiHelper,
//           ),
          
//           SizedBox(height: 24.h),

//           QuestionCard(
//             label: locale.yourQuestion,
//             hint: locale.questionExample,
//             controller: questionController, // تمرير المتحكم
//           ),
          
//           SizedBox(height: 20.h),

//           SizedBox(
//             width: double.infinity,
//             child: SmartMuftiButtonWidget(
//               text: locale.getAnswer, 
//               icon: Icons.auto_awesome, // هذه هي الأيقونة المطلوبة من الصورة
//               onPressed: () {
//                 if (questionController.text.trim().isNotEmpty) {
//                   FocusScope.of(context).unfocus(); 
//                   ref.read(muftiControllerProvider.notifier)
//                       .sendQuestion(questionController.text.trim());
//                 } else {
//                   context.showErrorSnackBar(locale.fieldRequired); 
//                 }
//               },
//             ),
//           ),
          
//           SizedBox(height: 24.h),

//           // كرت عرض الإجابة مع التعامل مع الحالات
//           ShariaAnswerCardWidget(
//             title: locale.shariaAnswer,
//             isLoading: muftiState.isLoading, // هنا يتم الربط التلقائي
//             content: muftiState.when(
//               data: (response) => response?.data?.answer ?? locale.shariaAnswerPlaceholder,
//               error: (err, stack) => locale.fetchDataError, // نص من الترجمة
//               // التغيير هنا: بدلاً من النص، نضع الـ Shimmer
//                loading: () => "", // نترك النص فارغاً لأننا سنعرض Shimmer فوق الكرت أو داخله
//             ),
           
//           ),

//           SizedBox(height: 40.h),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/common/widgets/widget.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/core/services/errors/exception.dart';
import 'package:yusr/features/smart_mufti/data/models/mufti_response_model.dart';
import 'package:yusr/features/smart_mufti/presentation/widgets/mufti_header_section_widget.dart';
import 'package:yusr/features/smart_mufti/presentation/widgets/question_card_widget.dart';
import 'package:yusr/features/smart_mufti/presentation/widgets/sharia_answer_card_widget.dart';
import 'package:yusr/features/smart_mufti/presentation/widgets/smart_mufti_button_widget.dart';
import 'package:yusr/features/smart_mufti/providers/mufti_controller_provider.dart';

// 1. تعريف الكنترولر باستخدام Provider لضمان ثبات النص وتنظيف الذاكرة تلقائياً
final questionTextControllerProvider = Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  // التأكد من حذف الكنترولر من الذاكرة فور إغلاق الشاشة
  ref.onDispose(() => controller.dispose());
  return controller;
});

class SmartMuftiView extends ConsumerWidget {
  const SmartMuftiView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale;
    
    // 2. استدعاء الكنترولر ومراقبة حالة المفتي
    final questionController = ref.watch(questionTextControllerProvider);
    final muftiState = ref.watch(muftiControllerProvider);

    // 3. الاستماع للحالات (فقط للأخطاء أو النجاح النهائي) بدون LoadingDialog
    ref.listen<AsyncValue<MuftiState>>(
      muftiControllerProvider,
      (prev, next) {
        if (!next.isLoading && next.hasError) { 
      context.showErrorSnackBar(locale.fetchDataError);
        // if (next.hasError) {
        //   // في حالة الخطأ، نعرض رسالة ونترك النص كما هو ليعدله المستخدم
        //   context.showErrorSnackBar(locale.fetchDataError);
        } else if (next.hasValue && !next.isLoading && next.value != null) {
          // في حالة النجاح التام، يمكنكِ مسح النص هنا إذا رغبتِ
          // questionController.clear(); 
        }
      },
    );

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
            controller: questionController,
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
                    if (questionController.text.trim().isNotEmpty) {
                      FocusScope.of(context).unfocus(); 
                      ref.read(muftiControllerProvider.notifier)
                          .sendQuestion(questionController.text.trim());
                    } else {
                      context.showErrorSnackBar(locale.fieldRequired); 
                    }
                  },
            ),
          ),
          
          SizedBox(height: 24.h),

          // 5. كرت عرض الإجابة مع الـ Shimmer التلقائي
          // ShariaAnswerCardWidget(
          //   title: locale.shariaAnswer,
          //   isLoading: muftiState.isLoading, 
          //   content: muftiState.when(
          //     data: (response) => response?.data?.answer ?? locale.shariaAnswerPlaceholder,
          //     error: (err, stack) => locale.fetchDataError,
          //     loading: () => "", // يترك فارغاً لأن الـ Shimmer سيعمل بسبب isLoading: true
          //   ),
          // ),
          ShariaAnswerCardWidget(
            title: locale.shariaAnswer,
            isLoading: muftiState.isLoading, 
            content: muftiState.when(
              // حالة النجاح: عرض الإجابة أو الـ Placeholder من ملف الترجمة
              data: (response) => response?.data?.answer ?? locale.shariaAnswerPlaceholder,
              
              // حالة الخطأ: التعديل المطلوب لعرض رسالة السيرفر أو رسالة الخطأ الافتراضية
              error: (err, stack) {
                // إذا كان الخطأ يحتوي على رسالة من السيرفر (detail) نعرضها
                // وإلا نعود لملف الترجمة الموحد للمشروع
                if (err is ServerException && err.errModel.errorMessage.isNotEmpty) {
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