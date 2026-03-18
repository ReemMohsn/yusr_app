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
import 'package:yusr/features/campaign_location/data/models/campaign_location_model.dart';
import 'package:yusr/features/campaign_location/presentation/widgets/location_input_card.dart';
import 'package:yusr/features/campaign_location/providers/edit_location_controller_provider.dart';

class EditLocationView extends ConsumerStatefulWidget {
  final CampaignLocationItemModel location; 
  const EditLocationView({super.key, required this.location});

  @override
  ConsumerState<EditLocationView> createState() => _EditLocationViewState();
}

class _EditLocationViewState extends ConsumerState<EditLocationView> {
  late TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();
  
  late LatLng _selectedPos; 
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.location.locationName);
    _selectedPos = LatLng(widget.location.latitude, widget.location.longitude);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    // مراقبة حالة الـ API
// مراقبة حالة الـ API في EditLocationView
ref.listen(editLocationControllerProvider, (prev, next) {
  if (next.isLoading) {
    context.showLoadingDialog();
  } else if (next.hasError) {
    context.closeLoadingDialog();
    context.showErrorSnackBar(next.error.toString());
  } else if (next.hasValue && next.value != null) {
    context.closeLoadingDialog();
    
    // إظهار رسالة النجاح من ملفات التعريف (locale)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 10.w),
            Text(
              context.locale.updateSuccess, // استخدام القيمة التي عرفناها في ملف الـ json
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: AppColor.golden,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        margin: EdgeInsets.all(20.w),
      ),
    );

    Navigator.pop(context); // العودة للشاشة السابقة بعد نجاح التعديل
  }
});

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        centerTitle: true,
        title: Text(
          locale.updateLocationTitle, 
          style: TextStyle(color: AppColor.golden, fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        leading: const UnconstrainedBox(child: CustomGoldenBackButton()),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h), 
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    LocationInputCard(
                      title: locale.locationName,
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: TextFormField(
                          controller: _nameController,
                          textAlign: TextAlign.right,
                          validator: (v) => (v == null || v.isEmpty) ? locale.enterRequiredData : null,
                          decoration: InputDecoration(
                            hintText: locale.enterLocationName, 
                            hintStyle: TextStyle(color: const Color(0xFF99A1AF), fontSize: 15.sp),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: const BorderSide(color: Color(0xFFE4E7EC)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: const BorderSide(color: Color(0xFFE4E7EC)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: const BorderSide(color: AppColor.golden, width: 1.5),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 20.h),

                    LocationInputCard(
                      title: locale.chooseCoordinates,
                      height: 380.h,
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
                                      width: 50.w,
                                      height: 50.h,
                                      alignment: Alignment.topCenter,
                                      child: Icon(
                                        Icons.location_on,
                                        color: AppColor.golden,
                                        size: 40.sp,
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
                                heroTag: "btn_edit_location",
                                backgroundColor: Colors.white,
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

          // منطقة الأزرار السفلية
          Container(
            padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF100F0B),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    onPressed: () async {
                      // 1. إغلاق لوحة المفاتيح
                      FocusScope.of(context).unfocus();

                      // 2. التحقق من صحة المدخلات
                      if (_formKey.currentState!.validate()) {
                        print("-----------------------------------------");
                        print("DEBUG: Trying to update location..."); 
                        print("Location ID: ${widget.location.locationId}");
                        print("New Name: ${_nameController.text.trim()}");
                        print("Lat: ${_selectedPos.latitude}");
                        print("Lng: ${_selectedPos.longitude}");
                        print("-----------------------------------------");

                        // 3. تنفيذ عملية التحديث مع المسميات الصحيحة للسواجر
                        await ref.read(editLocationControllerProvider.notifier).updateExistingLocation(
                              id: widget.location.locationId, // هذا هو الرقم الحقيقي للموقع
                              name: _nameController.text.trim(),
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
                      side: const BorderSide(color: Color(0xFFD0D5DD)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      locale.cancel,
                      style: TextStyle(color: const Color(0xFF344054), fontWeight: FontWeight.bold, fontSize: 16.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}