import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/auto_counter/presentation/widgets/switch_tracking_type_dialog.dart';
import 'package:yusr/features/auto_counter/providers/auto_counter_controller.dart';
import 'package:yusr/features/auto_counter/providers/counter_provider.dart';

class TawafSaeiToggle extends ConsumerWidget {
  const TawafSaeiToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale;
    final isTawaf = ref.watch(counterTypeControllerProvider);
    final isRunning = ref.watch(
      autoCounterControllerProvider.select((s) => s.isRunning),
    );

    return Container(
      height: 50.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColor.lightBlack,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Stack(
        children: [
          // المؤشر الذهبي المتحرك
          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            // alignment: isTawaf ? Alignment.centerRight : Alignment.centerLeft,
            alignment: isTawaf ? Alignment.centerLeft : Alignment.centerRight,

            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.golden,
                  borderRadius: BorderRadius.circular(25.r),
                ),
              ),
            ),
          ),

          // النصوص فوق المؤشر
          Row(
            children: [
              // زر السعي (يسار)
              Expanded(
                child: GestureDetector(
                  onTap: () => _onToggle(
                    context: context,
                    ref: ref,
                    isRunning: isRunning,
                    currentIsTawaf: isTawaf,
                    targetIsTawaf: false,
                  ),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    style: TextStyle(
                      color: !isTawaf ? AppColor.darkBlack : AppColor.withe,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                      fontFamily: 'Cairo',
                    ),
                    child: Center(child: Text(locale.saei)),
                  ),
                ),
              ),

              // زر الطواف (يمين)
              Expanded(
                child: GestureDetector(
                  onTap: () => _onToggle(
                    context: context,
                    ref: ref,
                    isRunning: isRunning,
                    currentIsTawaf: isTawaf,
                    targetIsTawaf: true,
                  ),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    style: TextStyle(
                      color: isTawaf ? AppColor.darkBlack : AppColor.withe,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                      fontFamily: 'Cairo',
                    ),
                    child: Center(child: Text(locale.tawaf)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _onToggle({
    required BuildContext context,
    required WidgetRef ref,
    required bool isRunning,
    required bool currentIsTawaf,
    required bool targetIsTawaf,
  }) async {
    if (currentIsTawaf == targetIsTawaf) return;

    if (!isRunning) {
      ref.read(counterTypeControllerProvider.notifier).setType(targetIsTawaf);
      return;
    }

    final confirmed = await SwitchTrackingTypeDialog.show(
      context,
      toTawaf: targetIsTawaf,
    );
    if (confirmed != true) return;

    ref.read(autoCounterControllerProvider.notifier).reset();
    ref.read(counterTypeControllerProvider.notifier).setType(targetIsTawaf);
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:yusr/core/constants/app_color.dart';
// import 'package:yusr/core/extensions/context_extension.dart';
// import 'package:yusr/features/auto_counter/presentation/widgets/switch_tracking_type_dialog.dart';
// import 'package:yusr/features/auto_counter/providers/auto_counter_controller.dart';
// import 'package:yusr/features/auto_counter/providers/counter_provider.dart';

// class TawafSaeiToggle extends ConsumerWidget {
//   const TawafSaeiToggle({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final locale = context.locale;
//     final isTawaf = ref.watch(counterTypeControllerProvider);
//     final isRunning = ref.watch(
//       autoCounterControllerProvider.select((s) => s.isRunning),
//     );

//     return Container(
//       height: 50.h,
//       padding: EdgeInsets.all(4.w),
//       decoration: BoxDecoration(
//         color: AppColor.lightBlack,
//         borderRadius: BorderRadius.circular(30.r),
//       ),
//       child: Stack(
//         children: [
//           // ── المؤشر الذهبي المتحرك ──────────────────────────
//           // الطواف على اليسار → isTawaf=true → centerLeft
//           // السعي  على اليمين → isTawaf=false → centerRight
//           AnimatedAlign(
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeInOut,
//             alignment: isTawaf ? Alignment.centerLeft : Alignment.centerRight,
//             child: FractionallySizedBox(
//               widthFactor: 0.5,
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: AppColor.golden,
//                   borderRadius: BorderRadius.circular(25.r),
//                 ),
//               ),
//             ),
//           ),

//           // ── النصوص فوق المؤشر ────────────────────────────
//           Row(
//             children: [
//               // زر الطواف (يسار) — الافتراضي
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () => _onToggle(
//                     context: context,
//                     ref: ref,
//                     isRunning: isRunning,
//                     currentIsTawaf: isTawaf,
//                     targetIsTawaf: true,
//                   ),
//                   behavior: HitTestBehavior.opaque,
//                   child: AnimatedDefaultTextStyle(
//                     duration: const Duration(milliseconds: 300),
//                     curve: Curves.easeInOut,
//                     style: TextStyle(
//                       color: isTawaf ? AppColor.darkBlack : AppColor.withe,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14.sp,
//                       fontFamily: 'Cairo',
//                     ),
//                     child: Center(child: Text(locale.tawaf)),
//                   ),
//                 ),
//               ),

//               // زر السعي (يمين)
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () => _onToggle(
//                     context: context,
//                     ref: ref,
//                     isRunning: isRunning,
//                     currentIsTawaf: isTawaf,
//                     targetIsTawaf: false,
//                   ),
//                   behavior: HitTestBehavior.opaque,
//                   child: AnimatedDefaultTextStyle(
//                     duration: const Duration(milliseconds: 300),
//                     curve: Curves.easeInOut,
//                     style: TextStyle(
//                       color: !isTawaf ? AppColor.darkBlack : AppColor.withe,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14.sp,
//                       fontFamily: 'Cairo',
//                     ),
//                     child: Center(child: Text(locale.saei)),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _onToggle({
//     required BuildContext context,
//     required WidgetRef ref,
//     required bool isRunning,
//     required bool currentIsTawaf,
//     required bool targetIsTawaf,
//   }) async {
//     // نقر على نفس الخيار المحدد → لا شيء
//     if (currentIsTawaf == targetIsTawaf) return;

//     // لا يوجد تشغيل نشط → غيّر مباشرة
//     if (!isRunning) {
//       ref.read(counterTypeControllerProvider.notifier).setType(targetIsTawaf);
//       return;
//     }

//     // يوجد تشغيل نشط → dialog التأكيد
//     final confirmed = await SwitchTrackingTypeDialog.show(
//       context,
//       toTawaf: targetIsTawaf,
//     );
//     if (confirmed != true) return;

//     ref.read(autoCounterControllerProvider.notifier).reset();
//     ref.read(counterTypeControllerProvider.notifier).setType(targetIsTawaf);
//   }
// }
