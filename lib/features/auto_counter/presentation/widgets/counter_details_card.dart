import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/auto_counter/presentation/widgets/custom_info_display.dart';
import '../../providers/auto_counter_controller.dart';

class CounterDetailsCard extends ConsumerWidget {
  const CounterDetailsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale;
    final state = ref.watch(autoCounterControllerProvider);
    final notifier = ref.read(autoCounterControllerProvider.notifier);

    return Card(
      elevation: 0,
      color: AppColor.inputFieldColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(color: AppColor.inputFieldBoundaries),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            // ── الصف الأول: الخطوات والحالة ──────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomInfoDisplay(
                  label: locale.steps,
                  value: '${state.stepsInCurrentLap}',
                ),
                Container(width: 1, height: 30, color: AppColor.iconColors),
                CustomInfoDisplay(
                  label: locale.status,
                  value: state.isMoving ? locale.walking : locale.stopped,
                ),
              ],
            ),

            // ── أزرار التصحيح اليدوي (تظهر فقط أثناء التشغيل) ──
            if (state.isRunning) ...[
              SizedBox(height: 16.h),
              Row(
                children: [
                  // زر الإنقاص (-)
                  Expanded(
                    child: _CorrectionButton(
                      icon: Icons.remove,
                      label: 'شوط -',
                      enabled: state.currentLap > 1,
                      color: AppColor.danger,
                      onTap: () => notifier.decrementLap(),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  // زر الزيادة (+)
                  Expanded(
                    child: _CorrectionButton(
                      icon: Icons.add,
                      label: 'شوط +',
                      enabled: state.currentLap < 7,
                      color: AppColor.golden,
                      onTap: () => notifier.incrementLap(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              // تلميح صغير
              Text(
                'اضغط للتصحيح اليدوي في حال الخطأ',
                style: TextStyle(
                  color: AppColor.lightFontColor,
                  fontSize: 10.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            SizedBox(height: 16.h),

            // ── زر البدء / إعادة الضبط ──────────────────────
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                // تم تغيير ElevatedButton.icon إلى ElevatedButton
                onPressed: () {
                  if (state.isRunning) {
                    notifier.reset();
                  } else {
                    notifier.startTracking();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: state.isRunning
                      ? AppColor.lightdanger
                      : AppColor.golden,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // لضمان تمركز المحتوى
                  children: [
                    if (state.isRunning) ...[
                      Icon(Icons.refresh, color: AppColor.danger, size: 22.sp),
                      SizedBox(width: 8.w), // مسافة بين الأيقونة والنص
                    ],
                    Text(
                      state.isRunning ? locale.reset : locale.start,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: state.isRunning
                            ? AppColor.danger
                            : AppColor.withe,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ويدجت زر التصحيح
// ─────────────────────────────────────────────────────────────

class _CorrectionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled;
  final Color color;
  final VoidCallback onTap;

  const _CorrectionButton({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: enabled ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: enabled
                ? color.withOpacity(0.4)
                : AppColor.inputFieldBoundaries,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: enabled ? color : AppColor.iconColors,
              size: 18.sp,
            ),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                color: enabled ? color : AppColor.iconColors,
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
