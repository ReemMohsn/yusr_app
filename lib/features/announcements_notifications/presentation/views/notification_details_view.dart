
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/common/widgets/custom_golden_back_button.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/announcements_notifications/data/models/notifications_model.dart';

class NotificationDetailsView extends StatelessWidget {
  final NotificationModel notification;

  const NotificationDetailsView({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          locale.detiles,
        ),
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: const UnconstrainedBox(child: CustomGoldenBackButton()),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(AppSize.paddingOfPage),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColor.withe,
            borderRadius: BorderRadius.circular(16.r),
            // إضافة الخط الذهبي العلوي للبطاقة الرئيسية
            border: Border(
              top: BorderSide(color: AppColor.golden, width: 4.h),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColor.golden,
                offset: const Offset(
                  3,
                  0,
                ), // نفس تأثير الظل الذهبي الرائع الخاص بك
                blurRadius: 0,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2), // ظل ناعم جداً
                offset: const Offset(0, 4),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. العنوان
              Text(
                notification.title,
                style: context.theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColor.baseFontColor,
                  // fontSize: 18.sp,
                ),
              ),

              SizedBox(height: 16.h),

              // 2. المرسل والتاريخ
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // المرسل (يمين)
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.background,
                        ),
                        child: Icon(
                          Icons.person_outline,
                          color: AppColor.iconColors,
                          size: 20.sp,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        notification.senderName, // أو 'مدير الحملة'
                        style: context.theme.textTheme.bodySmall?.copyWith(
                          // color: AppColor.midlineColor,
                          // fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  // التاريخ (يسار)
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.background,
                        ),
                        child: Icon(
                          Icons.calendar_today_outlined,
                          color: AppColor.iconColors,
                          size: 18.sp,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        notification.sentAtDate,
                        style: context.theme.textTheme.bodySmall?.copyWith(
                          // color: AppColor.midlineColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              // خط فاصل
              Divider(
                color: AppColor.backgroundColor,
                thickness: 1,
                height: 1.h,
              ),

              SizedBox(height: 24.h),

              // 3. عنوان المحتوى (محتوى الرسالة)
              Text(
                locale.messageContent, // "محتوى الرسالة"
                style: context.theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  // color: AppColor.baseFontColor,
                ),
              ),

              SizedBox(height: 12.h),

              // 4. الحاوية الداخلية للمحتوى (ذات الخط الذهبي)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColor.inputFieldColor, // خلفية رمادية فاتحة
                  borderRadius: BorderRadius.circular(12.r),
                  // استخدام BorderDirectional لضمان ظهور الخط يميناً في الواجهة العربية
                  border: BorderDirectional(
                    start: BorderSide(color: AppColor.golden, width: 3.w),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // النص الفعلي للإعلان
                    Text(
                      notification.body,
                      style: context.theme.textTheme.bodySmall,
                    ),

                    SizedBox(height: 30.h),

                    // 5. التوقيت (في أسفل اليسار كما في الصورة)
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.end, // لجعله في اليسار
                      children: [
                        Icon(
                          Icons.access_time,
                          color: AppColor.iconColors,
                          size: 18.sp,
                        ),
                        SizedBox(width: 6.w),

                        Text(
                          notification.sentAtTime,
                          textDirection: TextDirection.ltr,
                          style: context.theme.textTheme.bodyMedium?.copyWith(
                            color: AppColor.lightFontColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
