import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/common/widgets/custom_golden_back_button.dart';
import 'package:yusr/core/common/widgets/widget.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_size.dart';
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
  bool _isInitialized = false;

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    final locationsAsync = ref.watch(getCampaignLocationsProvider);

    // الاستماع لنتائج الـ API
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
          context.showSuccessSnackBar(next.value!.message);
          Navigator.pop(context); 
        }
      },
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
      title: Text(
        locale.updateLocationTitle, 
        style: TextStyle(color: AppColor.golden, fontWeight: FontWeight.bold, fontSize: 18.sp),
      ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A1A1A),
        leading: const UnconstrainedBox(child: CustomGoldenBackButton()),
      ),
      body: locationsAsync.when(
        data: (data) {
          if (data == null) return Center(child: Text(locale.notFound));

          final allLocations = [
            if (data.currentLocation != null) data.currentLocation!,
            ...data.previousLocations
          ];

          // الحل الجذري: نستخدم تأخير بسيط جداً لتعيين القيمة الابتدائية خارج إطار الـ build
          if (!_isInitialized && data.currentLocation != null) {
            _isInitialized = true; // نمنع التكرار فوراً
            Future.delayed(Duration.zero, () {
              if (mounted) {
                setState(() {
                  _selectedLocationId = data.currentLocation!.locationId;
                });
              }
            });
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.all(20.w),
                  itemCount: allLocations.length,
                  separatorBuilder: (_, __) => SizedBox(height: 15.h),
                  itemBuilder: (context, index) {
                    final loc = allLocations[index];
                    // هنا المقارنة تتم على الـ ID فقط، مما يمنع التحديد المتعدد
                    final bool isSelected = _selectedLocationId == loc.locationId;

                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        setState(() {
                          _selectedLocationId = loc.locationId;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: isSelected ? AppColor.golden : Colors.transparent,
                            width: 1.5.w,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // أيقونة الموقع يسار
                            Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: AppColor.golden.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.location_on_rounded, color: AppColor.golden, size: 20.sp),
                            ),
                            const Spacer(),
                            // اسم الموقع منتصف
                            Text(
                              loc.locationName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                                color: const Color(0xFF101828),
                              ),
                            ),
                            SizedBox(width: 15.w),
                            // دائرة الاختيار يمين
                            Container(
                              height: 24.w,
                              width: 24.w,
                              padding: EdgeInsets.all(4.w),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? AppColor.golden : const Color(0xFF99A1AF),
                                  width: 2.w,
                                ),
                              ),
                              child: isSelected
                                  ? Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColor.golden,
                                      ),
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // أزرار الحفظ والإلغاء
              Container(
                padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 40.h),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF100F0B),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                          ),
                          onPressed: () {
                            if (_selectedLocationId != null) {
                              ref.read(setActiveLocationControllerProvider.notifier)
                                 .changeActiveLocation(_selectedLocationId!);
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.save_rounded, color: AppColor.golden, size: 20.sp),
                              SizedBox(width: 8.w),
                              Text(
                                locale.saveChanges,
                                style: TextStyle(color: AppColor.golden, fontWeight: FontWeight.bold, fontSize: 16.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFFE0E0E0)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.close_rounded, color: const Color(0xFF6A7282), size: 18.sp),
                              SizedBox(width: 4.w),
                              Text(
                                locale.cancel,
                                style: TextStyle(color: const Color(0xFF6A7282), fontWeight: FontWeight.bold, fontSize: 16.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColor.golden)),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}