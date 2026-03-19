import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/features/instructions/data/models/instruction_model.dart';

class HajjTypeCard extends StatelessWidget {
  final InstructionModel instruction;

  const HajjTypeCard({super.key, required this.instruction});

  @override
  Widget build(BuildContext context) {
    // All cards must use the project's golden theme
    final List<Color> cardGradient = [AppColor.brownGolden, AppColor.golden];

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoute.hajjDetailsView,
          arguments: instruction.title,
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.borderRadiusCard.r),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: cardGradient,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.darkBlack.withValues(alpha: 0.10),
              blurRadius: 15,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: AppColor.darkBlack.withValues(alpha: 0.10),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSize.borderRadiusCard.r),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(AppSize.paddingInsideCard.r),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        instruction.title,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                          color: AppColor.withe,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.right,
                      ),

                      SizedBox(height: AppSize.smallSpace.h),

                      Text(
                        instruction.subtitle,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.normal,
                          fontSize: 14.sp,
                          color: AppColor.withe.withValues(alpha: 0.9),
                          height: 1.625,
                        ),
                        textAlign: TextAlign.right,
                      ),

                      SizedBox(height: AppSize.smallSpace.h),

                      Text(
                        instruction.description,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.normal,
                          fontSize: 12.sp,
                          color: AppColor.withe.withValues(alpha: 0.8),
                          height: 1.625,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom shimmer divider decoration
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: AppSize.smallSpace.h,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.transparent,
                        Color(0x4DFFFFFF),
                        Colors.transparent,
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
