import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/auto_counter/presentation/widgets/switch_tracking_type_dialog.dart';
import 'package:yusr/features/auto_counter/presentation/widgets/toggle_tab_item.dart';
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
              onTap: () => _onToggle(
                context: context,
                ref: ref,
                isRunning: isRunning,
                currentIsTawaf: isTawaf,
                targetIsTawaf: false,
              ),
            ),
            ToggleTabItem(
              title: locale.tawaf,
              isSelected: isTawaf,
              onTap: () => _onToggle(
                context: context,
                ref: ref,
                isRunning: isRunning,
                currentIsTawaf: isTawaf,
                targetIsTawaf: true,
              ),
            ),
          ],
        ),
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
    // لو نقر على نفس الخيار المحدد حالياً  لا تفعل شيئاً
    if (currentIsTawaf == targetIsTawaf) return;

    // اذا لم يكن النسك شغال بدل فورا دون ظهور daiolg
    if (!isRunning) {
      ref.read(counterTypeControllerProvider.notifier).setType(targetIsTawaf);
      return;
    }

    // اذا كان النسك شغال أظهر الdailog
    final confirmed = await SwitchTrackingTypeDialog.show(
      context,
      toTawaf: targetIsTawaf,
    );

    // إذا لم يؤكد لاتغير شي
    if (confirmed != true) return;

    // إذا أكّد أعد الضبط وغيّر النوع
    ref.read(autoCounterControllerProvider.notifier).reset();
    ref.read(counterTypeControllerProvider.notifier).setType(targetIsTawaf);
  }
}
