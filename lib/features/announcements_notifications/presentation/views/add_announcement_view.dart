import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/common/widgets/custom_golden_back_button.dart';
import 'package:yusr/core/common/widgets/custom_text_field.dart';
import 'package:yusr/core/common/widgets/widget.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/core/extensions/async_value_ui.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/core/utils/app_validator.dart';
import 'package:yusr/features/announcements_notifications/data/enums/target_audience_enum.dart';
import 'package:yusr/features/announcements_notifications/presentation/widgets/confirm_announcement_dialog.dart';
import 'package:yusr/features/announcements_notifications/presentation/widgets/input_card_widget.dart';
import 'package:yusr/features/announcements_notifications/providers/add_announcement_provider.dart';
import 'package:yusr/features/announcements_notifications/providers/announcements_provider.dart';
import 'package:yusr/features/announcements_notifications/providers/selected_audience_provider.dart';
import 'package:yusr/features/home/providers/user_provider.dart';

class AddAnnouncementView extends ConsumerStatefulWidget {
  const AddAnnouncementView({super.key});

  @override
  ConsumerState<AddAnnouncementView> createState() =>
      _AddAnnouncementViewState();
}

class _AddAnnouncementViewState extends ConsumerState<AddAnnouncementView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  TargetAudience _selectedAudience = TargetAudience.all;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    // جلب بيانات المستخدم لمعرفة الدور الحالي
    final userProfileState = ref.watch(userProfileProvider);
    final userRole = userProfileState.value?.userRole.trim() ?? '';
    final bool isSupervisor = userRole == 'مشرف';

    // 1. قراءة القيمة الحالية من البروفايدر المُولد
    final selectedAudience = ref.watch(selectedAudienceProvider);

    // إعداد المتغيرات الخاصة بالدروب داون بناءً على الدور
    List<TargetAudience> audienceItems;

    if (isSupervisor) {
      // في حالة المشرف: نعرض خيار القروب فقط
      audienceItems = [TargetAudience.groupPilgrims];
    } else {
      // في حالة مدير الحملة: نعرض كل الخيارات ما عدا القروب
      audienceItems = TargetAudience.values
          .where((element) => element != TargetAudience.groupPilgrims)
          .toList();
    }

    // تحديد القيمة المختارة حالياً
    final TargetAudience currentAudience = isSupervisor
        ? TargetAudience.groupPilgrims
        : selectedAudience;

    // دالة التغيير: تمرير null يعطل الدروب داون للمشرف تلقائياً
    final void Function(TargetAudience?)? onAudienceChanged = isSupervisor
        ? null
        : (newValue) {
            if (newValue != null) {
              ref.read(selectedAudienceProvider.notifier).setAudience(newValue);
            }
          };

    // الاستماع لنتيجة الإضافة (نجاح أو فشل)
    ref.listen(addAnnouncementProvider, (_, state) {
      if (state.isLoading) {
        context.showLoadingDialog();
      } else if (state.hasError) {
        context.closeLoadingDialog();
        context.showErrorSnackBar(state.errorMessage);
      } else if (state.hasValue && state.value != null) {
        context.closeLoadingDialog();
        context.showSuccessSnackBar(state.value!.message);
        ref.invalidate(announcementsProvider);
        Navigator.pop(context);
      }
    });

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(locale.addAnnouncement),
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: const UnconstrainedBox(child: CustomGoldenBackButton()),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSize.paddingOfPage),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20.h),

              InputCardWidget(
                title: locale.announcementTitle,
                child: CustomTextField(
                  controller: _titleController,
                  hintText: locale.enterAnnouncementTitle,
                  validator: AppValidator.validateEmptyField,
                ),
              ),

              SizedBox(height: 16.h),

              InputCardWidget(
                title: locale.announcementContent,
                child: CustomTextField(
                  controller: _bodyController,
                  hintText: locale.writeAnnouncementContentHere,
                  maxLines: 5,
                  validator: AppValidator.validateEmptyField,
                ),
              ),

              SizedBox(height: 16.h),

              // كرت الفئة المستهدفة مع تعديل الـ Dropdown ليعمل بالـ Enum
              InputCardWidget(
                title: locale.targetAudience,
                icon: Icons.people_outline,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.backgroundColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<TargetAudience>(
                      isExpanded: true,
                      value: currentAudience,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: isSupervisor ? Colors.grey : AppColor.golden,
                      ),
                      // تحويل قيم الـ Enum إلى عناصر في القائمة
                      items: audienceItems.map((TargetAudience audience) {
                        return DropdownMenuItem<TargetAudience>(
                          value: audience,
                          child: Text(audience.name),
                        );
                      }).toList(),
                      onChanged: onAudienceChanged,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30.h),
              CustomBigButton(
                text: locale.publishAnnouncement,
                onPressed: () async {
                  // 1. التأكد من صحة الحقول أولاً
                  if (_formKey.currentState!.validate()) {
                    // 2. إظهار نافذة التأكيد وانتظار النتيجة
                    final bool? shouldSubmit = await showDialog<bool>(
                      context: context,
                      builder: (context) => ConfirmAnnouncementDialog(
                        title: _titleController.text,
                        body: _bodyController.text,
                        targetAudience:
                            _selectedAudience.name, // سيتم تمرير اسم الفئة هنا
                      ),
                    );

                    // 3. إذا ضغط المستخدم على "تأكيد الإرسال" (shouldSubmit == true) نقوم بتنفيذ الـ Provider
                    if (shouldSubmit == true) {
                      ref
                          .read(addAnnouncementProvider.notifier)
                          .createAnnouncement(
                            title: _titleController.text,
                            body: _bodyController.text,
                            targetAudienceId: _selectedAudience.id,
                          );
                    }
                  }
                },
              ),
              // SizedBox(
              //   width: double.infinity,
              //   height: 50.h,
              //   child:

              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.black,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(12.r),
              //     ),
              //   ),
              //   onPressed: () async {
              //     // 1. التأكد من صحة الحقول أولاً
              //     if (_formKey.currentState!.validate()) {
              //       // 2. إظهار نافذة التأكيد وانتظار النتيجة
              //       final bool? shouldSubmit = await showDialog<bool>(
              //         context: context,
              //         builder: (context) => ConfirmAnnouncementDialog(
              //           title: _titleController.text,
              //           body: _bodyController.text,
              //           targetAudience: _selectedAudience
              //               .name, // سيتم تمرير اسم الفئة هنا
              //         ),
              //       );

              //       // 3. إذا ضغط المستخدم على "تأكيد الإرسال" (shouldSubmit == true) نقوم بتنفيذ الـ Provider
              //       if (shouldSubmit == true) {
              //         ref
              //             .read(addAnnouncementProvider.notifier)
              //             .createAnnouncement(
              //               title: _titleController.text,
              //               body: _bodyController.text,
              //               targetAudienceId: _selectedAudience.id,
              //             );
              //       }
              //     }
              //   },

              //   // onPressed: () {
              //   //   if (_formKey.currentState!.validate()) {
              //   //     ref
              //   //         .read(addAnnouncementProvider.notifier)
              //   //         .createAnnouncement(
              //   //           title: _titleController.text,
              //   //           body: _bodyController.text,
              //   //           targetAudienceId: _selectedAudience.id,
              //   //         );
              //   //   }
              //   // },
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Text(
              //         'نشر الإعلان',
              //         style: TextStyle(
              //           color: AppColor.golden,
              //           fontSize: 16.sp,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //       SizedBox(width: 8.w),
              //       Icon(
              //         Icons.send_outlined,
              //         color: AppColor.golden,
              //         size: 20.sp,
              //       ),
              //     ],
              //   ),
              // ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
