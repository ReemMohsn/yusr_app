import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/common/widgets/custom_golden_back_button.dart';
import 'package:yusr/core/common/widgets/custom_text_field.dart';
import 'package:yusr/core/common/widgets/custom_big_button.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/core/extensions/async_value_ui.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/core/utils/app_validator.dart';
import 'package:yusr/features/announcements_notifications/data/models/target_audience_model.dart';
import 'package:yusr/features/announcements_notifications/presentation/widgets/confirm_announcement_dialog.dart';
import 'package:yusr/features/announcements_notifications/presentation/widgets/input_card_widget.dart';
import 'package:yusr/features/announcements_notifications/providers/add_announcement_provider.dart';
import 'package:yusr/features/announcements_notifications/providers/announcements_provider.dart';
import 'package:yusr/features/announcements_notifications/providers/selected_audience_provider.dart';
import 'package:yusr/features/announcements_notifications/providers/target_audiences_provider.dart';

class AddAnnouncementView extends ConsumerStatefulWidget {
  const AddAnnouncementView({super.key});

  @override
  ConsumerState<AddAnnouncementView> createState() =>
      _AddAnnouncementViewState();
}

class _AddAnnouncementViewState extends ConsumerState<AddAnnouncementView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
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

    // جلب الفئات المستهدفة من الـ API (الـ backend يفلترها تلقائياً حسب دور المستخدم)
    final audiencesAsync = ref.watch(targetAudiencesProvider);

    // قراءة الـ ID المحدد حالياً
    final selectedAudienceId = ref.watch(selectedAudienceProvider);

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

              InputCardWidget(
                title: locale.targetAudience,
                icon: Icons.people_outline,
                child: audiencesAsync.when(
                  loading: () => const SizedBox(
                    height: 48,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, _) => Text(
                    'تعذّر تحميل الفئات',
                    style: TextStyle(color: Colors.red, fontSize: 14.sp),
                  ),
                  data: (List<TargetAudienceModel> audiences) {
                    // ضبط القيمة الافتراضية عند أول تحميل
                    if (selectedAudienceId == null && audiences.isNotEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ref
                            .read(selectedAudienceProvider.notifier)
                            .setAudienceId(audiences.first.targetAudienceId);
                      });
                    }

                    final currentId =
                        selectedAudienceId ??
                        (audiences.isNotEmpty
                            ? audiences.first.targetAudienceId
                            : null);

                    final bool singleItem = audiences.length == 1;

                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.backgroundColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          isExpanded: true,
                          value: currentId,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: singleItem ? Colors.grey : AppColor.golden,
                          ),
                          items: audiences.map((TargetAudienceModel audience) {
                            return DropdownMenuItem<int>(
                              value: audience.targetAudienceId,
                              child: Text(audience.targetAudienceName),
                            );
                          }).toList(),
                          // إذا كان عنصر واحد فقط (مشرف) يتم تعطيل الدروب داون
                          onChanged: singleItem
                              ? null
                              : (int? newId) {
                                  if (newId != null) {
                                    ref
                                        .read(selectedAudienceProvider.notifier)
                                        .setAudienceId(newId);
                                  }
                                },
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 30.h),
              CustomBigButton(
                text: locale.publishAnnouncement,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final audiences = ref.read(targetAudiencesProvider).value;
                    final int? audienceId =
                        selectedAudienceId ??
                        (audiences != null && audiences.isNotEmpty
                            ? audiences.first.targetAudienceId
                            : null);

                    if (audienceId == null) return;

                    // اسم الفئة المختارة لعرضه في نافذة التأكيد
                    final String audienceName =
                        audiences
                            ?.firstWhere(
                              (a) => a.targetAudienceId == audienceId,
                              orElse: () => TargetAudienceModel(
                                targetAudienceId: audienceId,
                                targetAudienceName: '',
                              ),
                            )
                            .targetAudienceName ??
                        '';

                    final bool? shouldSubmit = await showDialog<bool>(
                      context: context,
                      builder: (context) => ConfirmAnnouncementDialog(
                        title: _titleController.text,
                        body: _bodyController.text,
                        targetAudience: audienceName,
                      ),
                    );

                    if (shouldSubmit == true) {
                      ref
                          .read(addAnnouncementProvider.notifier)
                          .createAnnouncement(
                            title: _titleController.text,
                            body: _bodyController.text,
                            targetAudienceId: audienceId,
                          );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
