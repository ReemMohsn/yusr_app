import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/auto_counter/presentation/widgets/toggle_tab_item.dart';
import 'package:yusr/features/auto_counter/providers/counter_provider.dart';

class TawafSaeiToggle extends StatelessWidget {
  final WidgetRef ref; 

  const TawafSaeiToggle({super.key, required this.ref});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    final isTawaf = ref.watch(counterTypeProvider);

    return Container(
      height: 50.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColor.lightBlack,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15), 
          borderRadius: BorderRadius.circular(28.r),
        ),
        child: Row(
          children: [
            ToggleTabItem(
              title: locale.saei,
              isSelected: !isTawaf,
              onTap: () => ref.read(counterTypeProvider.notifier).state = false,
            ),
            ToggleTabItem(
              title: locale.tawaf,
              isSelected: isTawaf,
              onTap: () => ref.read(counterTypeProvider.notifier).state = true,
            ),          
          ],
        ),
      ),
    );
  }
}