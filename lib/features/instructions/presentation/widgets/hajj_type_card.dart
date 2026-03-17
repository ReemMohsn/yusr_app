import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/features/instructions/data/models/instruction_model.dart';

class HajjTypeCard extends StatelessWidget {
  final InstructionModel instruction;

  const HajjTypeCard({super.key, required this.instruction});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: instruction.gradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: EdgeInsets.all(24.r),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      instruction.title,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                        color: Colors.white,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.right,
                    ),

                    SizedBox(height: 4.h),

                    // Subtitle
                    Text(
                      instruction.subtitle,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.normal,
                        fontSize: 14.sp,
                        color: Colors.white.withValues(alpha: 0.9),
                        height: 1.625,
                      ),
                      textAlign: TextAlign.right,
                    ),

                    SizedBox(height: 4.h),

                    // Description
                    Text(
                      instruction.description,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.normal,
                        fontSize: 12.sp,
                        color: Colors.white.withValues(alpha: 0.8),
                        height: 1.625,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ),

            // Bottom shimmer divider line
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 4.h,
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
    );
  }
}
