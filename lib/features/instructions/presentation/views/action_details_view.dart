import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/common/widgets/custom_golden_back_button.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/features/instructions/data/models/hajj_action_model.dart';
import 'package:yusr/features/instructions/presentation/widgets/action_section_card.dart';

class ActionDetailsView extends StatelessWidget {
  final HajjActionModel action;

  const ActionDetailsView({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(action.name),
        leading: const CustomGoldenBackButton(),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(AppSize.paddingOfPage.w),
        itemCount: action.sections.length + 1,
        itemBuilder: (context, index) {
          // First item: large emoji header
          if (index == 0) {
            return Column(
              children: [
                Hero(
                  tag: action.name,
                  child: Text(action.emoji, style: TextStyle(fontSize: 70.sp)),
                ),
                SizedBox(height: AppSize.spaceBetweenCards.h),
              ],
            );
          }
          // Remaining items: section cards
          return ActionSectionCard(section: action.sections[index - 1]);
        },
      ),
    );
  }
}
