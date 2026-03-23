import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:yusr/core/common/widgets/custom_golden_back_button.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/campaign_location/data/models/campaign_location_item_model.dart';
import 'package:yusr/features/campaign_location/presentation/widgets/location_input_card.dart';
import 'package:yusr/features/campaign_location/providers/edit_location_controller_provider.dart';
import 'package:yusr/core/common/widgets/custom_text_field.dart'; // تأكدي من المسار الصحيح

class EditLocationView extends ConsumerStatefulWidget {
  final CampaignLocationItemModel location;
  const EditLocationView({super.key, required this.location});

  @override
  ConsumerState<EditLocationView> createState() => _EditLocationViewState();
}

class _EditLocationViewState extends ConsumerState<EditLocationView> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();
  final MapController _mapController = MapController();

  // استخدام ValueNotifier لتجنب setState نهائياً عند تغيير الإحداثيات
  late ValueNotifier<LatLng> _selectedPosNotifier;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.location.locationName);
    _descriptionController = TextEditingController(
      text: widget.location.description ?? "",
    );
    _selectedPosNotifier = ValueNotifier(
      LatLng(widget.location.latitude, widget.location.longitude),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _mapController.dispose();
    _selectedPosNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    final theme = Theme.of(context).textTheme;

    // الاستماع لحالة الـ Provider للتعامل مع التحميل والأخطاء
    ref.listen(editLocationControllerProvider, (prev, next) {
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
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(locale.updateLocationTitle),
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: const UnconstrainedBox(child: CustomGoldenBackButton()),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: AppSize.paddingOfPage.h),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.paddingOfPage.w,
                  vertical: 10.h,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // حقل اسم الموقع باستخدام CustomTextField
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

                      // حقل وصف الموقع باستخدام CustomTextField
                      LocationInputCard(
                        title: locale.locationDescription,
                        child: CustomTextField(
                          controller: _descriptionController,
                          hintText: locale.enterLocationDescription,
                          maxLines: 3,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // منطقة الخريطة
                      LocationInputCard(
                        title: locale.chooseCoordinates,
                        height: 340.h,
                        child: ClipRRect(
                          // ملاحظة: تم استخدام ClipRRect هنا لقص حواف الخريطة (Clipping)
                          // لضمان ظهور الزوايا المنحنية، لأن الخريطة بطبيعتها لا تحترم انحناءات العناصر الأب.
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16.r),
                            bottomRight: Radius.circular(16.r),
                          ),
                          child: Stack(
                            children: [
                              ValueListenableBuilder<LatLng>(
                                valueListenable: _selectedPosNotifier,
                                builder: (context, pos, child) {
                                  return FlutterMap(
                                    mapController: _mapController,
                                    options: MapOptions(
                                      initialCenter: pos,
                                      initialZoom: 15.0,
                                      onTap: (tapPosition, point) {
                                        HapticFeedback.lightImpact();
                                        _selectedPosNotifier.value = point;
                                      },
                                    ),
                                    children: [
                                      TileLayer(
                                        urlTemplate:
                                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                        userAgentPackageName: 'com.yusr.app',
                                      ),
                                      MarkerLayer(
                                        markers: [
                                          Marker(
                                            point: pos,
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
                                  );
                                },
                              ),
                              Positioned(
                                bottom: 10.h,
                                right: 10.w,
                                child: FloatingActionButton.small(
                                  heroTag: "btn_edit_location_map",
                                  backgroundColor: AppColor.withe,
                                  elevation: 2,
                                  child: const Icon(
                                    Icons.my_location,
                                    color: AppColor.golden,
                                  ),
                                  onPressed: () => _mapController.move(
                                    _selectedPosNotifier.value,
                                    15,
                                  ),
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

            // منطقة الأزرار السفلية
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.paddingOfPage.w,
                vertical: 15.h,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, -4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                children: [
                  // زر الحفظ
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
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState!.validate()) {
                          await ref
                              .read(editLocationControllerProvider.notifier)
                              .updateExistingLocation(
                                id: widget.location.locationId,
                                name: _nameController.text.trim(),
                                description: _descriptionController.text.trim(),
                                lat: _selectedPosNotifier.value.latitude,
                                lng: _selectedPosNotifier.value.longitude,
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
                  // زر الإلغاء
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColor.withe,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        side: const BorderSide(
                          color: AppColor.inputFieldBoundaries,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
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
