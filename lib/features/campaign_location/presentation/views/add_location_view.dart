import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_map/flutter_map.dart'; 
import 'package:latlong2/latlong.dart'; 
import 'package:yusr/core/common/widgets/custom_golden_back_button.dart';
import 'package:yusr/core/common/widgets/widget.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/campaign_location/presentation/widgets/location_input_card.dart';
import 'package:yusr/features/campaign_location/providers/add_location_controller_provider.dart';

class AddLocationView extends ConsumerStatefulWidget {
  const AddLocationView({super.key});

  @override
  ConsumerState<AddLocationView> createState() => _AddLocationViewState();
}

class _AddLocationViewState extends ConsumerState<AddLocationView> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  LatLng _selectedPos = const LatLng(21.4225, 39.8262); 
  final MapController _mapController = MapController();

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
      backgroundColor: AppColor.backgroundColor,
       appBar: AppBar(
        elevation: 0,
        title: Text(locale.addLocation),
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: const UnconstrainedBox(child: CustomGoldenBackButton()),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      LocationInputCard(
                        title: locale.locationName,
                        child: _buildTextField(
                          _nameController, 
                          locale.enterLocationName, 
                          (v) => (v == null || v.isEmpty) ? locale.enterRequiredData : null
                        ),
                      ),
                      SizedBox(height: 16.h),

                      LocationInputCard(
                        title: locale.locationDescription, 
                        child: _buildTextField(
                          _descriptionController, 
                          locale.enterLocationDescription, 
                          null 
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
                                  initialCenter: _selectedPos,
                                  initialZoom: 15.0,
                                  onTap: (tapPosition, point) {
                                    HapticFeedback.lightImpact(); 
                                    setState(() => _selectedPos = point);
                                  },
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName: 'com.yusr.app',
                                  ),
                                  MarkerLayer(
                                    markers: [
                                      Marker(
                                        point: _selectedPos,
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
                                  child: const Icon(Icons.my_location, color: AppColor.golden),
                                  onPressed: () => _mapController.move(_selectedPos, 15),
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

            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.darkBlack,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        elevation: 0,
                      ),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState!.validate()) {
                          ref.read(addLocationControllerProvider.notifier).addNewLocation(
                            name: _nameController.text.trim(),
                            description: _descriptionController.text.trim(),
                            lat: _selectedPos.latitude,
                            lng: _selectedPos.longitude,
                          );
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save_rounded, color: AppColor.golden, size: 20.sp),
                          SizedBox(width: 8.w),
                          Text(
                            locale.saveLocation,
                            style: TextStyle(color: AppColor.golden, fontWeight: FontWeight.bold, fontSize: 16.sp),
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
                        side: const BorderSide(color: AppColor.inputFieldBoundaries),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        locale.cancel,
                        style: TextStyle(color: AppColor.midlineColor, fontWeight: FontWeight.bold, fontSize: 16.sp),
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

  Widget _buildTextField(TextEditingController controller, String hint, String? Function(String?)? validator) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.right,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppColor.lightFontColor, fontSize: 15.sp),
          filled: true,
          fillColor: AppColor.withe,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: AppColor.inputFieldBoundaries),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: AppColor.inputFieldBoundaries),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: AppColor.golden, width: 1.5),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
        ),
      ),
    );
  }
}
