import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/common/widgets/custom_golden_back_button.dart';
import 'package:yusr/core/common/widgets/widget.dart';
import 'package:yusr/core/constants/app_color.dart'; // استخدام الكلاس الخاص بكِ
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/core/services/API/ApiResponse.dart';
import 'package:yusr/features/campaign_location/providers/get_locations_provider.dart';
import 'package:yusr/features/campaign_location/providers/set_active_location_controller.dart';

class SetLocationView extends ConsumerStatefulWidget {
  const SetLocationView({super.key});

  @override
  ConsumerState<SetLocationView> createState() => _SetLocationViewState();
}

class _SetLocationViewState extends ConsumerState<SetLocationView> {
  int? _selectedLocationId;
  int? _initialActiveId; 
  bool _isInitialized = false;

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    final locationsAsync = ref.watch(getCampaignLocationsProvider);

    ref.listen<AsyncValue<ApiResponse<dynamic>?>>(
      setActiveLocationControllerProvider,
      (prev, next) {
        if (next.isLoading) {
          context.showLoadingDialog();
        } else if (next.hasError) {
          context.closeLoadingDialog();
          context.showErrorSnackBar(next.error.toString());
        } else if (next.hasValue && next.value != null) {
          context.closeLoadingDialog();
          context.showSuccessSnackBar(locale.updateSuccess); 
          Navigator.pop(context); 
        }
      },
    );

    return Scaffold(
      backgroundColor: AppColor.backgroundColor, // تم التغيير لـ AppColor
      appBar: AppBar(
        title: Text(
          locale.locationList,
          style: TextStyle(color: AppColor.golden, fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        centerTitle: true,
        backgroundColor: AppColor.baseFontColor, // استخدام اللون الأساسي للأسود
        elevation: 0,
        leading: const UnconstrainedBox(child: CustomGoldenBackButton()),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: locationsAsync.when(
          data: (data) {
            if (data == null) return Center(child: Text(locale.notFound));

            final allLocations = [
              if (data.currentLocation != null) data.currentLocation!,
              ...data.previousLocations
            ];

            if (!_isInitialized && data.currentLocation != null) {
              _isInitialized = true;
              _initialActiveId = data.currentLocation!.locationId;
              Future.delayed(Duration.zero, () {
                if (mounted) {
                  setState(() => _selectedLocationId = data.currentLocation!.locationId);
                }
              });
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.all(20.w),
                    itemCount: allLocations.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final loc = allLocations[index];
                      final bool isSelected = _selectedLocationId == loc.locationId;
                      final bool isCurrentlyActive = loc.locationId == _initialActiveId;

                      return _buildLocationItem(loc, isSelected, isCurrentlyActive, locale);
                    },
                  ),
                ),
                _buildActionButtons(locale),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: AppColor.golden)),
          error: (e, _) => Center(child: Text(locale.fetchDataError)), 
        ),
      ),
    );
  }

  Widget _buildLocationItem(dynamic loc, bool isSelected, bool isCurrentlyActive, var locale) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        setState(() => _selectedLocationId = loc.locationId);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
        decoration: BoxDecoration(
          color: AppColor.withe, // استخدام المتغير الأبيض
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppColor.golden : (isCurrentlyActive ? AppColor.golden.withOpacity(0.3) : Colors.transparent),
            width: 1.5.w,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? AppColor.golden.withOpacity(0.08) : AppColor.baseFontColor.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4)
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 22.w,
                  width: 22.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColor.golden : AppColor.lightFontColor,
                      width: 2.w,
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    height: 12.w,
                    width: 12.w,
                    decoration: const BoxDecoration(color: AppColor.golden, shape: BoxShape.circle),
                  ),
              ],
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.locationName,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                      fontSize: 15.sp,
                      color: isSelected ? AppColor.baseFontColor : AppColor.midlineColor,
                    ),
                  ),
                  if (isCurrentlyActive)
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: Text(
                        locale.currentLocation,
                        style: TextStyle(fontSize: 11.sp, color: AppColor.golden, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.location_on_rounded, 
              color: isSelected ? AppColor.golden : AppColor.inputFieldBoundaries, 
              size: 24.sp
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(var locale) {
    final bool canSave = _selectedLocationId != _initialActiveId;

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 40.h),

      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: canSave ? AppColor.darkBlack : AppColor.inputFieldBoundaries,
                padding: EdgeInsets.symmetric(vertical: 15.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                elevation: canSave ? 2 : 0,
              ),
              onPressed: canSave ? () {
                ref.read(setActiveLocationControllerProvider.notifier)
                    .changeActiveLocation(_selectedLocationId!);
              } : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(Icons.save_outlined, color: canSave ? AppColor.golden : AppColor.lightFontColor, size: 22.sp),
                   SizedBox(width: 8.w),
                   Text(
                    locale.saveChanges,
                    style: TextStyle(
                      color: canSave ? AppColor.golden : AppColor.lightFontColor, 
                      fontWeight: FontWeight.bold, 
                      fontSize: 16.sp
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 15.w),
          Expanded(
            flex: 1,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColor.withe,
                padding: EdgeInsets.symmetric(vertical: 15.h),
                side: const BorderSide(color: AppColor.inputFieldBoundaries),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
              ),
              onPressed: () => Navigator.pop(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // إضافة أيقونة زر الإلغاء (close/cancel)
                  Icon(Icons.close_rounded, color: AppColor.midlineColor, size: 18.sp),
                  SizedBox(width: 4.w),
                  Text(
                    locale.cancel,
                    style: TextStyle(
                      color: AppColor.midlineColor, 
                      fontWeight: FontWeight.bold, 
                      fontSize: 16.sp
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}