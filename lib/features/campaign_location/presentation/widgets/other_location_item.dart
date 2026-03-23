import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/campaign_location/data/models/campaign_location_item_model.dart';
import 'package:yusr/features/campaign_location/data/models/campaign_location_model.dart';
import 'package:yusr/features/campaign_location/providers/campaign_location_controller_provider.dart';
import 'package:yusr/features/campaign_location/providers/get_locations_provider.dart';

class OtherLocationItem extends ConsumerWidget {
  final CampaignLocationItemModel location;
  const OtherLocationItem({super.key, required this.location});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // 3. أيقونة الموقع الذهبية (في أقصى اليمين)
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColor.golden.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.location_on, color: AppColor.golden, size: 20.sp),
          ),
          SizedBox(width: 10.w),
          // 2. اسم الموقع (مربوط بالـ API)
          Text(
            location.locationName,
            style: context.theme.textTheme.headlineSmall,
          ),
          const Spacer(),

          // 1. أزرار الحذف والتعديل (في جهة اليسار)
          _buildBtn(
            Icons.delete_outline,
            Colors.white,
            AppColor.golden,
            isBorder: true,
            onTap: () => _confirmDelete(context, ref),
          ),
          SizedBox(width: 6.w),
          _buildBtn(
            Icons.edit_outlined,
            Colors.white,
            AppColor.golden,
            isFilled: true,
            onTap: () => Navigator.pushNamed(
              context,
              AppRoute.editLocationView,
              arguments: location,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBtn(
    IconData icon,
    Color bg,
    Color iconColor, {
    bool isBorder = false,
    bool isFilled = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 36.w,
        height: 36.h,
        decoration: BoxDecoration(
          color: isFilled ? AppColor.golden : const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(10.r),
          border: isBorder ? Border.all(color: AppColor.golden) : null,
        ),
        child: Icon(
          icon,
          color: isFilled ? Colors.white : iconColor,
          size: 20.sp,
        ),
      ),
    );
  }

  // نافذة تأكيد الحذف مع توسيط الأزرار وربطها بالـ API
  // ... (بقيت أجزاء الكود كما هي حتى دالة _confirmDelete)

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    final locale = context.locale;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: AppColor.danger,
              size: 28.sp,
            ),
            SizedBox(width: 10.w),
            Text(
              locale.delete,
              style: context.theme.textTheme.bodySmall,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              locale.confirmDelete,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // زر الحذف المربوط بالـ API
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.danger,
                  ),
                  onPressed: () {
                    // 1. إغلاق دايلوج "هل أنت متأكد؟"
                    Navigator.of(context).pop();

                    // 2. بدء عملية الحذف
                    // الـ listen سيلتقط حالة الـ loading ويظهر الـ LoadingDialog تلقائياً
                    ref
                        .read(campaignLocationControllerProvider.notifier)
                        .removeLocation(location.locationId);
                  },
                  child: Text(locale.delete),
                ),
                SizedBox(width: 12.w),
                // زر الإلغاء
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    locale.cancel,
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: const [],
      ),
    );
  }
}
