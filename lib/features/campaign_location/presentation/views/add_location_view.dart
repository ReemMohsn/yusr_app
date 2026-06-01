import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:yusr/core/common/widgets/custom_golden_back_button.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/core/common/widgets/custom_text_field.dart';
import 'package:yusr/core/extensions/async_value_ui.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/campaign_location/presentation/widgets/location_input_card.dart';
import 'package:yusr/features/campaign_location/providers/add_location_controller_provider.dart';
// استيراد الكنترولر الجديد المعتمد على الـ Code Generation
import 'package:yusr/features/campaign_location/providers/add_location_map_controller.dart'; 

class AddLocationView extends ConsumerStatefulWidget {
  const AddLocationView({super.key});

  @override
  ConsumerState<AddLocationView> createState() => _AddLocationViewState();
}

class _AddLocationViewState extends ConsumerState<AddLocationView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final MapController _mapController = MapController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // استدعاء دالة جلب الموقع الحقيقي وتحريك الخريطة عبر الكنترولر الجديد المولد
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(addLocationMapControllerProvider.notifier).initializeUserLocation(
            mapController: _mapController,
          );
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    final theme = Theme.of(context).textTheme;
    
    // الاستماع لحالة الإحداثيات المحدثة من الكنترولر المولد تلقائياً
    final selectedPos = ref.watch(addLocationMapControllerProvider);

    // الاستماع لنتيجة عملية حفظ وإضافة الموقع
    ref.listen(addLocationControllerProvider, (_, state) {
      if (state.isLoading) {
        context.showLoadingDialog();
      } else if (state.hasError) {
        context.closeLoadingDialog();
        context.showErrorSnackBar(state.errorMessage); 
      } else if (state.hasValue && state.value != null) {
        context.closeLoadingDialog();
        context.showSuccessSnackBar(state.value!.message);
        Navigator.pop(context);
      }
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(locale.addLocation),
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: const UnconstrainedBox(child: CustomGoldenBackButton()),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.paddingOfPage.w,
          vertical: 10.h,
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      LocationInputCard(
                        title: locale.locationName,
                        child: CustomTextField(
                          controller: _nameController,
                          hintText: locale.enterLocationName,
                          validator: (v) => (v == null || v.isEmpty)
                              ? locale.enterRequiredData
                              : null,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      LocationInputCard(
                        title: locale.locationDescription,
                        child: CustomTextField(
                          controller: _descriptionController,
                          hintText: locale.enterLocationDescription,
                          maxLines: 3,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      LocationInputCard(
                        title: locale.chooseCoordinates,
                        height: 340.h, 
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16.r),
                            bottomRight: Radius.circular(16.r),
                          ),
                          child: Stack(
                            children: [
                              FlutterMap(
                                mapController: _mapController,
                                options: MapOptions(
                                  initialCenter: selectedPos, // الموقع الافتراضي الأولي (يفضل أن يبدأ بمكة المكرمة)
                                  initialZoom: 15.0,
                                  maxZoom: 20.0,      // 🔥 تمكين التقريب لأقصى درجة لرؤية تفاصيل الأبراج والفنادق والبيوت بدقة جوجل ماب
                                  minZoom: 3.0,       // منع تصغير الخريطة بشكل مفرط
                                  
                                  // 🔥 تفعيل السحب والتكبير والتنقل الحر الكامل للمستخدم للبحث عن الموقع المراد إضافته
                                  interactionOptions: const InteractionOptions(
                                    flags: InteractiveFlag.all, 
                                  ),
                                  
                                  onTap: (tapPosition, point) {
                                    HapticFeedback.lightImpact();
                                    // تحديث الإحداثيات عبر استدعاء أكشن الكنترولر المولد
                                    ref.read(addLocationMapControllerProvider.notifier)
                                      .updateSelectedPosition(point);
                                  },
                                ),
                                children: [
                                  
                                  TileLayer(
                      // رابط سيرفرات جوجل ماب الرسمية (النسخة العادية التفصيلية الملونة)
                                      urlTemplate: 'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                                      
                                      // لضمان تحميل المربعات بأعلى سرعة وأمان
                                      userAgentPackageName: 'net.runasp.yusrapp.volunteer_app_final_release',
                                    ),
                                  MarkerLayer(
                                    markers: [
                                      Marker(
                                        point: selectedPos,
                                        width: 45.w,
                                        height: 45.h,
                                        alignment: Alignment.topCenter,
                                        child: Icon(
                                          Icons.location_on,
                                          color: AppColor.golden,
                                          size: 38.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Positioned(
                                bottom: 10.h,
                                right: 10.w,
                                child: FloatingActionButton.small(
                                  heroTag: "btn_add_location_map",
                                  backgroundColor: AppColor.withe,
                                  elevation: 2,
                                  child: const Icon(
                                    Icons.my_location,
                                    color: AppColor.golden,
                                  ),
                                  onPressed: () => _mapController.move(selectedPos, 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.darkBlack,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        elevation: 0,
                      ),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState!.validate()) {
                          ref.read(addLocationControllerProvider.notifier).addNewLocation(
                                name: _nameController.text.trim(),
                                description: _descriptionController.text.trim(),
                                lat: selectedPos.latitude,
                                lng: selectedPos.longitude,
                              );
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.save_rounded,
                            color: AppColor.golden,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            locale.saveLocation,
                            style: theme.bodyLarge?.copyWith(
                              color: AppColor.golden,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: AppColor.inputFieldBoundaries,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.close_rounded,
                            color: AppColor.midlineColor,
                            size: 18.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            locale.cancel,
                            style: theme.bodyLarge?.copyWith(
                              color: AppColor.midlineColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}