import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/campaign_location/data/models/campaign_location_item_model.dart';
// import 'package:yusr/features/campaign_location/providers/campaign_location_controller_provider.dart';
import 'package:yusr/features/campaign_location/presentation/widgets/confirm_delete_dialog.dart';
import 'package:yusr/features/campaign_location/providers/delete_location_controller_provider.dart';
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
          // أيقونة الموقع الذهبية
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColor.golden.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.location_on, color: AppColor.golden, size: 20.sp),
          ),
          SizedBox(width: 10.w),
          
          // اسم الموقع
          Text(
            location.locationName,
            style: context.theme.textTheme.headlineSmall,
          ),
          const Spacer(),

          // أزرار الحذف والتعديل
          _buildBtn(
            Icons.delete_outline,
            Colors.white,
            AppColor.golden,
            isBorder: true,
            onTap: () => _confirmDelete(context, ref), // استدعاء الدالة الجديدة المحدثة
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

  // دالة الحذف الجديدة المستدعاة والمطابقة لصفحة الإعلانات 100%
  void _confirmDelete(BuildContext context, WidgetRef ref) async {
    // إظهار نافذة التأكيد الموحدة وانتظار رد المستخدم (true أو false)
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => const ConfirmDeleteDialog(),
    );

    // إذا ضغط المستخدم على زر "حذف" وتم إرجاع قيمة true
    //  الكود الجديد الصحيح
      if (shouldDelete == true) {
        ref
            .read(deleteLocationControllerProvider.notifier)
            .removeLocation(location.locationId);
      }
  }
}

