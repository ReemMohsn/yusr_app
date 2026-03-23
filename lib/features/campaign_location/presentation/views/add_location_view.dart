import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:yusr/core/common/widgets/custom_golden_back_button.dart';
import 'package:yusr/core/common/widgets/widget.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/core/common/widgets/custom_text_field.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/campaign_location/presentation/widgets/location_input_card.dart';
import 'package:yusr/features/campaign_location/providers/add_location_controller_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/features/campaign_location/providers/campaign_location_controller_provider.dart';

final nameControllerProvider = Provider.autoDispose((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose()); // تنظيف الذاكرة عند الانتهاء
  return controller;
});

final descControllerProvider = Provider.autoDispose((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

// تعديل الـ Position Provider ليكون autoDispose أيضاً لتصفير موقع الخريطة كل مرة
final selectedMapPositionProvider = StateProvider.autoDispose<LatLng>(
  (ref) => const LatLng(21.4225, 39.8262),
);

class AddLocationView extends ConsumerWidget {
  const AddLocationView({super.key});

  // التحكم في الحقول يتم عبر Controllers معرفة هنا أو في Provider
  // للتبسيط في الواجهة سنبقيها كـ final داخل الـ build (أو يفضل وضعها في الـ Controller لاحقاً)
  static final _formKey = GlobalKey<FormState>();
  static final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale;
    final theme = Theme.of(context).textTheme;
    // استدعاء الـ Providers هنا
    final nameController = ref.watch(nameControllerProvider);
    final descriptionController = ref.watch(descControllerProvider);
    final selectedPos = ref.watch(selectedMapPositionProvider);

    ref.listen(addLocationControllerProvider, (prev, next) {
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
        title: Text(locale.addLocation),
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: const UnconstrainedBox(child: CustomGoldenBackButton()),
        ),
      ),
      // إزالة SafeArea واستبدالها بـ Padding من ملف AppSize
      body: Padding(
        padding: const EdgeInsets.all(AppSize.paddingOfPage),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                // تم إزالة الأطوال الثابتة واستخدام التوسعة التلقائية مع البادينج
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      LocationInputCard(
                        title: locale.locationName,
                        child: CustomTextField(
                          controller: nameController,
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
                          controller: descriptionController,
                          hintText: locale.enterLocationDescription,
                          maxLines: 3,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      LocationInputCard(
                        title: locale.chooseCoordinates,
                        height: 340
                            .h, // بقاء الطول هنا مسموح لأن الخريطة تحتاج مساحة محددة
                        child: ClipRRect(
                          // ملاحظة: تم استخدام ClipRRect هنا لقص حواف الخريطة (Clipping)
                          // لضمان ظهور الزوايا المنحنية، لأن الخريطة بطبيعتها لا تحترم انحناءات العناصر الأب.
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16.r),
                            bottomRight: Radius.circular(16.r),
                          ),
                          child: Stack(
                            children: [
                              FlutterMap(
                                mapController: _mapController,
                                options: MapOptions(
                                  initialCenter: selectedPos,
                                  initialZoom: 15.0,
                                  onTap: (tapPosition, point) {
                                    HapticFeedback.lightImpact();
                                    // تحديث الموقع عبر ريفربود بدلاً من setState
                                    ref
                                            .read(
                                              selectedMapPositionProvider
                                                  .notifier,
                                            )
                                            .state =
                                        point;
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
                                  onPressed: () =>
                                      _mapController.move(selectedPos, 15),
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

            // حاوية الأزرار - بدون ارتفاع ثابت (تعتمد على البادينج والمحتوى)
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
                          ref
                              .read(addLocationControllerProvider.notifier)
                              .addNewLocation(
                                name: nameController.text.trim(),
                                description: descriptionController.text.trim(),
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
                            ), // استخدام ثيم النصوص
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
