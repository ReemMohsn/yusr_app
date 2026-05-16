// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // // import 'package:yusr/core/constants/app_color.dart';
// // // import 'package:yusr/core/extensions/context_extension.dart';
// // // import 'package:yusr/features/auto_counter/presentation/widgets/toggle_tab_item.dart';
// // // import 'package:yusr/features/auto_counter/providers/counter_provider.dart';

// // // class TawafSaeiToggle extends ConsumerWidget {
// // //   const TawafSaeiToggle({super.key});

// // //   @override
// // //   Widget build(BuildContext context, WidgetRef ref) {
// // //     final locale = context.locale;
// // //     final isTawaf = ref.watch(counterTypeControllerProvider);

// // //     return Container(
// // //       height: 50.h,
// // //       padding: EdgeInsets.all(4.w),
// // //       decoration: BoxDecoration(
// // //         color: AppColor.lightBlack,
// // //         borderRadius: BorderRadius.circular(30.r),
// // //       ),
// // //       child: Container(
// // //         decoration: BoxDecoration(
// // //           color: AppColor.withe.withOpacity(0.15),
// // //           borderRadius: BorderRadius.circular(28.r),
// // //         ),
// // //         child: Row(
// // //           children: [
// // //             ToggleTabItem(
// // //               title: locale.saei,
// // //               isSelected: !isTawaf,
// // //               onTap: () => ref.read(counterTypeControllerProvider.notifier).setType(false),
// // //             ),
// // //             ToggleTabItem(
// // //               title: locale.tawaf,
// // //               isSelected: isTawaf,
// // //               onTap: () => ref.read(counterTypeControllerProvider.notifier).setType(true),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // //////////////////////////
// // ///
// // ///
// // // ============================================================
// // // tawaf_counter_view.dart
// // // الواجهة الرئيسية — بدون تغييرات جوهرية
// // // تستخدم autoCounterControllerProvider الصحيح
// // // ============================================================

// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:yusr/core/constants/app_color.dart';
// // import 'package:yusr/core/extensions/context_extension.dart';
// // import 'package:yusr/features/auto_counter/presentation/widgets/circular_counter_widget.dart';
// // import 'package:yusr/features/auto_counter/presentation/widgets/counter_details_card.dart';
// // import 'package:yusr/features/auto_counter/presentation/widgets/success_greeting_card_widget.dart';
// // import 'package:yusr/features/auto_counter/presentation/widgets/tawaf_saei_toggle.dart';
// // import 'package:yusr/features/auto_counter/presentation/widgets/success_bottom_sheet_widget.dart';
// // import 'package:yusr/features/auto_counter/providers/auto_counter_controller.dart';

// // class TawafCounterView extends ConsumerWidget {
// //   const TawafCounterView({super.key});

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final locale = context.locale;
// //     final counterState = ref.watch(autoCounterControllerProvider);

// //     // ── الاستماع لتغير الأشواط → اهتزاز haptic ──
// //     ref.listen<int>(autoCounterControllerProvider.select((s) => s.currentLap), (
// //       previous,
// //       next,
// //     ) {
// //       final isRunning = ref.read(autoCounterControllerProvider).isRunning;
// //       if (isRunning && previous != null && next > previous && next <= 7) {
// //         HapticFeedback.heavyImpact();
// //       }
// //     });

// //     // ── الاستماع لاكتمال النسك → Bottom Sheet ──
// //     ref.listen<bool>(
// //       autoCounterControllerProvider.select((s) => s.isCompleted),
// //       (previous, next) {
// //         if (next == true) {
// //           SuccessBottomSheet.show(context, locale.tawaf_saei_success_msg);
// //         }
// //       },
// //     );

// //     return Scaffold(
// //       body: SafeArea(
// //         top: false,
// //         child: SingleChildScrollView(
// //           physics: const BouncingScrollPhysics(),
// //           child: Column(
// //             children: [
// //               // ── زر التبديل (طواف / سعي) ──────────────────
// //               Container(
// //                 width: double.infinity,
// //                 padding: EdgeInsets.fromLTRB(30.w, 30.h, 30.w, 20.h),
// //                 child: const TawafSaeiToggle(),
// //               ),

// //               // ── العداد الدائري ────────────────────────────
// //               const CircularCounterWidget(),

// //               // ── رسالة خطأ الحساس ─────────────────────────
// //               if (counterState.permissionError != null)
// //                 Padding(
// //                   padding: EdgeInsets.symmetric(
// //                     horizontal: 25.w,
// //                     vertical: 10.h,
// //                   ),
// //                   child: Container(
// //                     padding: EdgeInsets.all(12.w),
// //                     decoration: BoxDecoration(
// //                       color: AppColor.danger.withOpacity(0.1),
// //                       borderRadius: BorderRadius.circular(12.r),
// //                       border: Border.all(
// //                         color: AppColor.danger.withOpacity(0.3),
// //                       ),
// //                     ),
// //                     child: Row(
// //                       children: [
// //                         Icon(
// //                           Icons.warning_amber_rounded,
// //                           color: AppColor.danger,
// //                           size: 18.sp,
// //                         ),
// //                         SizedBox(width: 8.w),
// //                         Expanded(
// //                           child: Text(
// //                             counterState.permissionError!,
// //                             style: TextStyle(
// //                               color: AppColor.danger,
// //                               fontSize: 12.sp,
// //                               fontWeight: FontWeight.w600,
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),

// //               // ── بطاقة التفاصيل (مع أزرار التصحيح) ────────
// //               Padding(
// //                 padding: EdgeInsets.symmetric(horizontal: 20.w),
// //                 child: const CounterDetailsCard(),
// //               ),

// //               // ── بطاقة التهنئة عند الانتهاء ───────────────
// //               if (counterState.isCompleted) const SuccessGreetingCard(),

// //               // ── النص التوضيحي السفلي ──────────────────────
// //               Padding(
// //                 padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 25.h),
// //                 child: Text(
// //                   locale.tawafDescription,
// //                   textAlign: TextAlign.center,
// //                   style: TextStyle(
// //                     color: AppColor.lightFontColor,
// //                     fontSize: 11.sp,
// //                     height: 1.5,
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// /////////////////////
// ///
// ///
// // ============================================================
// // tawaf_counter_view.dart
// // الواجهة الرئيسية — بدون تغييرات جوهرية
// // تستخدم autoCounterControllerProvider الصحيح
// // ============================================================

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:yusr/core/constants/app_color.dart';
// import 'package:yusr/core/extensions/context_extension.dart';
// import 'package:yusr/features/auto_counter/presentation/widgets/circular_counter_widget.dart';
// import 'package:yusr/features/auto_counter/presentation/widgets/counter_details_card.dart';
// import 'package:yusr/features/auto_counter/presentation/widgets/success_greeting_card_widget.dart';
// import 'package:yusr/features/auto_counter/presentation/widgets/tawaf_saei_toggle.dart';
// import 'package:yusr/features/auto_counter/presentation/widgets/success_bottom_sheet_widget.dart';
// import 'package:yusr/features/auto_counter/providers/auto_counter_controller.dart';

// class TawafCounterView extends ConsumerWidget {
//   const TawafCounterView({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final locale = context.locale;
//     final counterState = ref.watch(autoCounterControllerProvider);

//     // ── الاستماع لتغير الأشواط → اهتزاز haptic ──
//     ref.listen<int>(autoCounterControllerProvider.select((s) => s.currentLap), (
//       previous,
//       next,
//     ) {
//       final isRunning = ref.read(autoCounterControllerProvider).isRunning;
//       if (isRunning && previous != null && next > previous && next <= 7) {
//         HapticFeedback.heavyImpact();
//       }
//     });

//     // ── الاستماع لاكتمال النسك → Bottom Sheet ──
//     ref.listen<bool>(
//       autoCounterControllerProvider.select((s) => s.isCompleted),
//       (previous, next) {
//         if (next == true) {
//           SuccessBottomSheet.show(context, locale.tawaf_saei_success_msg);
//         }
//       },
//     );

//     return Scaffold(
//       body: SafeArea(
//         top: false,
//         child: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: Column(
//             children: [
//               // ── زر التبديل (طواف / سعي) ──────────────────
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.fromLTRB(30.w, 30.h, 30.w, 20.h),
//                 child: const TawafSaeiToggle(),
//               ),

//               // ── العداد الدائري ────────────────────────────
//               const CircularCounterWidget(),

//               // ── رسالة خطأ الحساس ─────────────────────────
//               if (counterState.permissionError != null)
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 25.w,
//                     vertical: 10.h,
//                   ),
//                   child: Container(
//                     padding: EdgeInsets.all(12.w),
//                     decoration: BoxDecoration(
//                       color: AppColor.danger.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(12.r),
//                       border: Border.all(
//                         color: AppColor.danger.withOpacity(0.3),
//                       ),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(
//                           Icons.warning_amber_rounded,
//                           color: AppColor.danger,
//                           size: 18.sp,
//                         ),
//                         SizedBox(width: 8.w),
//                         Expanded(
//                           child: Text(
//                             counterState.permissionError!,
//                             style: TextStyle(
//                               color: AppColor.danger,
//                               fontSize: 12.sp,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//               // ── بطاقة التفاصيل (مع أزرار التصحيح) ────────
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20.w),
//                 child: const CounterDetailsCard(),
//               ),

//               // ── بطاقة التهنئة عند الانتهاء ───────────────
//               if (counterState.isCompleted) const SuccessGreetingCard(),

//               // ── النص التوضيحي السفلي ──────────────────────
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 25.h),
//                 child: Text(
//                   locale.tawafDescription,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: AppColor.lightFontColor,
//                     fontSize: 11.sp,
//                     height: 1.5,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
///////////////////////////
///
///
///
///
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/auto_counter/presentation/widgets/toggle_tab_item.dart';
import 'package:yusr/features/auto_counter/providers/counter_provider.dart';

class TawafSaeiToggle extends ConsumerWidget {
  const TawafSaeiToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale;
    final isTawaf = ref.watch(counterTypeControllerProvider);

    return Container(
      height: 50.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColor.lightBlack,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.withe.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(28.r),
        ),
        child: Row(
          children: [
            ToggleTabItem(
              title: locale.saei,
              isSelected: !isTawaf,
              onTap: () => ref
                  .read(counterTypeControllerProvider.notifier)
                  .setType(false),
            ),
            ToggleTabItem(
              title: locale.tawaf,
              isSelected: isTawaf,
              onTap: () => ref
                  .read(counterTypeControllerProvider.notifier)
                  .setType(true),
            ),
          ],
        ),
      ),
    );
  }
}
