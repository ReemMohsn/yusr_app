import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/common/widgets/custom_golden_back_button.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/instructions/presentation/widgets/hajj_type_card.dart';
import 'package:yusr/features/instructions/providers/instructions_provider.dart';

class InstructionsView extends ConsumerWidget {
  const InstructionsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.locale;
    final instructionsList = ref.watch(instructionsProvider(l10n: l10n));

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(l10n.instructions),
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: const UnconstrainedBox(child: CustomGoldenBackButton()),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: 30.h,
            left: AppSize.paddingOfPage,
            right: AppSize.paddingOfPage,
            bottom: 40.h,
          ),
          child: Column(
            children: [
              for (int i = 0; i < instructionsList.length; i++) ...[
                HajjTypeCard(instruction: instructionsList[i]),
                if (i < instructionsList.length - 1)
                  SizedBox(height: AppSize.spaceBetweenCards.h),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
