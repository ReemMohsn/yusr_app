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
          color: AppColor.withe.withOpacity(0.15), 
          borderRadius: BorderRadius.circular(28.r),
        ),
        child: Row(
          children: [
            ToggleTabItem(
              title: locale.saei,
              isSelected: !isTawaf,
              onTap: () => ref.read(counterTypeControllerProvider.notifier).setType(false),
            ),
            ToggleTabItem(
              title: locale.tawaf,
              isSelected: isTawaf,
              onTap: () => ref.read(counterTypeControllerProvider.notifier).setType(true),
            ),          
          ],
        ),
      ),
    );
  }
}