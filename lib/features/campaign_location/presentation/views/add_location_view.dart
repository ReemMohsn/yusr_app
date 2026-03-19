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

// ... (نفس الـ imports)

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
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        centerTitle: true,
        title: Text(
          locale.addLocation,
          style: TextStyle(color: AppColor.golden, fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        leading: const UnconstrainedBox(child: CustomGoldenBackButton()),
      ),
      body: SafeArea( // حماية المنطقة السفلية
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                // إضافة padding سفلي بسيط لمنع الالتصاق بمنطقة الأزرار
                padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // 1. حقل إدخال الاسم
                      LocationInputCard(
                        title: locale.locationName,
                        child: _buildTextField(
                          _nameController, 
                          locale.enterLocationName, 
                          (v) => (v == null || v.isEmpty) ? locale.enterRequiredData : null
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // 2. حقل إدخال الوصف
                      LocationInputCard(
                        title: locale.locationDescription, 
                        child: _buildTextField(
                          _descriptionController, 
                          locale.enterLocationDescription, 
                          null // الوصف اختياري
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // 3. خريطة OSM (ارتفاع متناسق)
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

            // منطقة الأزرار السفلية (ثابتة في الأسفل)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),

              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF100F0B),
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
      ),
    );
  }

  // دالة مساعدة لبناء الحقول لضمان التناسق
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

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_map/flutter_map.dart'; 
// import 'package:latlong2/latlong.dart'; 
// import 'package:yusr/core/common/widgets/custom_golden_back_button.dart';
// import 'package:yusr/core/common/widgets/widget.dart';
// import 'package:yusr/core/constants/app_color.dart';
// import 'package:yusr/core/extensions/context_extension.dart';
// import 'package:yusr/features/campaign_location/presentation/widgets/location_input_card.dart';
// import 'package:yusr/features/campaign_location/providers/add_location_controller_provider.dart';

// class AddLocationView extends ConsumerStatefulWidget {
//   const AddLocationView({super.key});

//   @override
//   ConsumerState<AddLocationView> createState() => _AddLocationViewState();
// }

// class _AddLocationViewState extends ConsumerState<AddLocationView> {
//   final _nameController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
  
//   LatLng _selectedPos = const LatLng(21.4225, 39.8262); 
//   final MapController _mapController = MapController();

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _mapController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final locale = context.locale;

//     ref.listen(addLocationControllerProvider, (prev, next) {
//       if (next.isLoading) {
//         context.showLoadingDialog();
//       } else if (next.hasError) {
//         context.closeLoadingDialog();
//         context.showErrorSnackBar(next.error.toString()); 
//       } else if (next.hasValue && next.value != null) {
//         context.closeLoadingDialog();
//         context.showSuccessSnackBar(next.value!.message);
//         Navigator.pop(context); 
//       }
//             else if (next.hasError) {
//         context.closeLoadingDialog();
//         // اطبعي الخطأ هنا لتعرفي محتوى الـ ServerException
//         debugPrint("SERVER ERROR: ${next.error}"); 
//         context.showErrorSnackBar(next.error.toString()); 
//       }
//     });

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F0),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1A1A1A),
//         centerTitle: true,
//         title: Text(
//           locale.addLocation,
//           style: TextStyle(color: AppColor.golden, fontWeight: FontWeight.bold, fontSize: 18.sp),
//         ),
//         leading: const UnconstrainedBox(child: CustomGoldenBackButton()),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0), 
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     // 1. حقل إدخال الاسم باستخدام locale
//                   LocationInputCard(
//                     title: locale.locationName,
//                     child: Padding(
//                       padding: EdgeInsets.all(16.w), // إضافة البادينج كما في واجهة التعديل
//                       child: TextFormField(
//                         controller: _nameController,
//                         textAlign: TextAlign.right,
//                         validator: (v) => (v == null || v.isEmpty) ? locale.enterRequiredData : null,
//                         decoration: InputDecoration(
//                           hintText: locale.enterLocationName, 
//                           hintStyle: TextStyle(
//                             color: AppColor.lightFontColor, // استخدام المتغير بدلاً من اللون الصريح
//                             fontSize: 15.sp
//                           ),
//                           filled: true,
//                           fillColor: AppColor.withe, // استخدام المتغير الأبيض
                          
//                           // الحدود العادية (Default)
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12.r),
//                             borderSide: const BorderSide(color: AppColor.inputFieldBoundaries),
//                           ),
                          
//                           // الحدود عند تفعيل الحقل
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12.r),
//                             borderSide: const BorderSide(color: AppColor.inputFieldBoundaries),
//                           ),
                          
//                           // الحدود عند التركيز (Focus)
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12.r),
//                             borderSide: const BorderSide(color: AppColor.golden, width: 1.5),
//                           ),
                          
//                           contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20.h),

//                     // 2. خريطة OSM
//                     LocationInputCard(
//                       title: locale.chooseCoordinates,
//                       height: 380.h,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.only(
//                           bottomLeft: Radius.circular(16.r),
//                           bottomRight: Radius.circular(16.r),
//                         ),
//                         child: Stack(
//                           children: [
//                             FlutterMap(
//                               mapController: _mapController,
//                               options: MapOptions(
//                                 initialCenter: _selectedPos,
//                                 initialZoom: 15.0,
//                                 onTap: (tapPosition, point) {
//                                   HapticFeedback.lightImpact(); 
//                                   setState(() => _selectedPos = point);
//                                 },
//                               ),
//                               children: [
//                                 TileLayer(
//                                   urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                                   userAgentPackageName: 'com.yusr.app',
//                                 ),
//                                 MarkerLayer(
//                                   markers: [
//                                     Marker(
//                                       point: _selectedPos,
//                                       width: 50.w,
//                                       height: 50.h,
//                                       alignment: Alignment.topCenter,
//                                       child: Icon(
//                                         Icons.location_on,
//                                         color: AppColor.golden,
//                                         size: 40.sp,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             Positioned(
//                               bottom: 10.h,
//                               right: 10.w,
//                               child: FloatingActionButton.small(
//                                 backgroundColor: Colors.white,
//                                 elevation: 2,
//                                 child: const Icon(Icons.my_location, color: AppColor.golden),
//                                 onPressed: () => _mapController.move(_selectedPos, 15),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           // 3. أزرار الحفظ والإلغاء السفلي
//           Container(
//             padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
//             decoration: BoxDecoration(
//               boxShadow: [
//                 BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
//               ],
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF100F0B),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
//                       padding: EdgeInsets.symmetric(vertical: 14.h),
//                       elevation: 0,
//                     ),
//                     onPressed: () {
                      
//                       if (_formKey.currentState!.validate()) {
//                         ref.read(addLocationControllerProvider.notifier).addNewLocation(
//                           name: _nameController.text.trim(),
//                           lat: _selectedPos.latitude,
//                           lng: _selectedPos.longitude,
//                         );
//                       }
//                     },
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.save_rounded, color: AppColor.golden, size: 20.sp),
//                         SizedBox(width: 8.w),
//                         Text(
//                           locale.saveLocation,
//                           style: TextStyle(color: AppColor.golden, fontWeight: FontWeight.bold, fontSize: 16.sp),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 12.w),
//                 Expanded(
//                   flex: 1,
//                   child: OutlinedButton(
//                     style: OutlinedButton.styleFrom(
//                       side: const BorderSide(color: Color(0xFFD0D5DD)),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
//                       padding: EdgeInsets.symmetric(vertical: 14.h),
//                     ),
//                     onPressed: () => Navigator.pop(context),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.close_rounded, color: const Color(0xFF344054), size: 18.sp),
//                         SizedBox(width: 4.w),
//                         Text(
//                           locale.cancel,
//                           style: TextStyle(color: const Color(0xFF344054), fontWeight: FontWeight.bold, fontSize: 16.sp),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:yusr/core/common/widgets/custom_golden_back_button.dart';
// // import 'package:yusr/core/common/widgets/widget.dart';
// // import 'package:yusr/core/constants/app_color.dart';
// // import 'package:yusr/core/constants/app_size.dart';
// // import 'package:yusr/core/extensions/context_extension.dart';
// // import 'package:yusr/features/campaign_location/presentation/widgets/location_input_card.dart';
// // import 'package:yusr/features/campaign_location/providers/add_location_controller_provider.dart';

// // class AddLocationView extends ConsumerStatefulWidget {
// //   const AddLocationView({super.key});

// //   @override
// //   ConsumerState<AddLocationView> createState() => _AddLocationViewState();
// // }

// // class _AddLocationViewState extends ConsumerState<AddLocationView> {
// //   final _nameController = TextEditingController();
// //   final _formKey = GlobalKey<FormState>();
// //   LatLng _selectedPos = const LatLng(21.4225, 39.8262); // مكة المكرمة كبداية افتراضية

// //   @override
// //   void dispose() {
// //     _nameController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final locale = context.locale;

// //     // مراقبة الـ Controller للتعامل مع الرد من الـ API
// //     ref.listen(addLocationControllerProvider, (prev, next) {
// //       if (next.isLoading) {
// //         context.showLoadingDialog();
// //       } else if (next.hasError) {
// //         context.closeLoadingDialog();
// //         context.showErrorSnackBar(next.error.toString()); 
// //       } else if (next.hasValue && next.value != null) {
// //         context.closeLoadingDialog();
// //         context.showSuccessSnackBar(next.value!.message);
// //         Navigator.pop(context); // العودة التلقائية وتحديث القائمة
// //       }
// //     });

// //     return Scaffold(
// //       backgroundColor: const Color(0xFFF5F5F0), 
// //       appBar: AppBar(
// //         elevation: 0,
// //         backgroundColor: AppColor.darkBlack,
// //         centerTitle: true,
// //         title: Text(
// //           locale.addLocation,
// //           style: TextStyle(color: AppColor.golden, fontSize: 18.sp, fontWeight: FontWeight.bold),
// //         ),
// //         leading: const UnconstrainedBox(child: CustomGoldenBackButton()),
// //       ),
// //       body: SingleChildScrollView(
// //         padding: EdgeInsets.all(AppSize.paddingOfPage.w),
// //         child: Form(
// //           key: _formKey,
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.stretch,
// //             children: [
// //               // حقل اسم الموقع
// //               LocationInputCard(
// //                 title: locale.locationName,
// //                 height: 100.h,
// //                 child: Padding(
// //                   padding: EdgeInsets.symmetric(horizontal: 16.w),
// //                   child: TextFormField(
// //                     controller: _nameController,
// //                     validator: (v) => (v == null || v.isEmpty) ? locale.enterRequiredData : null,
// //                     style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
// //                     decoration: InputDecoration(
// //                       hintText: locale.enterRequiredData,
// //                       hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
// //                       border: InputBorder.none,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               SizedBox(height: 20.h),

// //               // حقل اختيار الموقع من الخريطة
// //               LocationInputCard(
// //                 title: locale.chooseCoordinates,
// //                 height: 380.h,
// //                 child: Padding(
// //                   padding: EdgeInsets.all(12.w),
// //                   child: ClipRRect(
// //                     borderRadius: BorderRadius.circular(12.r),
// //                     child: GoogleMap(
// //                       initialCameraPosition: CameraPosition(target: _selectedPos, zoom: 15),
// //                       onTap: (pos) => setState(() => _selectedPos = pos),
// //                       zoomControlsEnabled: false,
// //                       myLocationButtonEnabled: true,
// //                       markers: {
// //                         Marker(
// //                           markerId: const MarkerId('selected_pos'),
// //                           position: _selectedPos,
// //                           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
// //                         ),
// //                       },
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               SizedBox(height: 30.h),

// //               // منطقة الأزرار المعدلة لحل مشكلة الـ text والـ child
// //               Row(
// //                 children: [
// //                   // زر حفظ الموقع (استخدام CustomBigButton بالشكل الصحيح لمشروعكم)
// //                   Expanded(
// //                     flex: 2,
// //                     child: CustomBigButton(
// //                       text: locale.saveLocation, // تم توفير النص المطلوب إجبارياً
// //                       backgroundColor: AppColor.darkBlack,
// //                       textColor: AppColor.golden,
// //                       onPressed: () {
// //                         if (_formKey.currentState!.validate()) {
// //                           ref.read(addLocationControllerProvider.notifier).addNewLocation(
// //                                 name: _nameController.text.trim(),
// //                                 lat: _selectedPos.latitude,
// //                                 lng: _selectedPos.longitude,
// //                               );
// //                         }
// //                       },
// //                     ),
// //                   ),
// //                   SizedBox(width: 12.w),
// //                   // زر إلغاء (تصميم يدوي ليطابق الصورة تماماً مع الأيقونة X)
// //                   Expanded(
// //                     child: GestureDetector(
// //                       onTap: () => Navigator.pop(context),
// //                       child: Container(
// //                         height: 50.h, // نفس ارتفاع الـ CustomBigButton تقريباً
// //                         decoration: BoxDecoration(
// //                           color: Colors.white,
// //                           borderRadius: BorderRadius.circular(14.r),
// //                           border: Border.all(color: const Color(0xFFE0E0E0)),
// //                           boxShadow: [
// //                             BoxShadow(
// //                               color: Colors.black.withOpacity(0.08), 
// //                               blurRadius: 6, 
// //                               offset: const Offset(0, 3)
// //                             ),
// //                           ],
// //                         ),
// //                         child: Row(
// //                           mainAxisAlignment: MainAxisAlignment.center,
// //                           children: [
// //                             Icon(Icons.close, color: const Color(0xFF6A7282), size: 18.sp),
// //                             SizedBox(width: 4.w),
// //                             Text(
// //                               locale.cancel,
// //                               style: TextStyle(
// //                                 color: const Color(0xFF6A7282),
// //                                 fontWeight: FontWeight.bold,
// //                                 fontSize: 16.sp,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:yusr/core/common/widgets/custom_golden_back_button.dart';
// // import 'package:yusr/core/common/widgets/widget.dart';
// // import 'package:yusr/core/constants/app_color.dart';
// // import 'package:yusr/core/constants/app_size.dart';
// // import 'package:yusr/core/extensions/context_extension.dart';
// // import 'package:yusr/features/campaign_location/presentation/widgets/location_input_card.dart';
// // import 'package:yusr/features/campaign_location/providers/add_location_controller_provider.dart';

// // class AddLocationView extends ConsumerStatefulWidget {
// //   const AddLocationView({super.key});

// //   @override
// //   ConsumerState<AddLocationView> createState() => _AddLocationViewState();
// // }

// // class _AddLocationViewState extends ConsumerState<AddLocationView> {
// //   final _nameController = TextEditingController();
// //   final _formKey = GlobalKey<FormState>();
// //   LatLng _selectedPos = const LatLng(21.4225, 39.8262); // مكة المكرمة كبداية افتراضية

// //   @override
// //   void dispose() {
// //     _nameController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final locale = context.locale;

// //     // مراقبة الـ Controller للتعامل مع الرد من الـ API
// //     ref.listen(addLocationControllerProvider, (prev, next) {
// //       if (next.isLoading) {
// //         context.showLoadingDialog();
// //       } else if (next.hasError) {
// //         context.closeLoadingDialog();
// //         // تأكدي أن "errorMessage" امتداد معرف عندك، أو استخدمي next.error.toString()
// //         context.showErrorSnackBar(next.error.toString()); 
// //       } else if (next.hasValue && next.value != null) {
// //         context.closeLoadingDialog();
// //         context.showSuccessSnackBar(next.value!.message);
// //         Navigator.pop(context); // العودة التلقائية وتحديث القائمة بسبب الـ invalidate
// //       }
// //     });

// //     return Scaffold(
// //       backgroundColor: const Color(0xFFF5F5F0), // لون الخلفية المتناسق مع التصميم
// //       appBar: AppBar(
// //         elevation: 0,
// //         backgroundColor: AppColor.darkBlack,
// //         centerTitle: true,
// //         title: Text(
// //           locale.addLocation,
// //           style: TextStyle(color: AppColor.golden, fontSize: 18.sp, fontWeight: FontWeight.bold),
// //         ),
// //         leading: const UnconstrainedBox(child: CustomGoldenBackButton()),
// //       ),
// //       body: SingleChildScrollView(
// //         padding: EdgeInsets.all(AppSize.paddingOfPage.w),
// //         child: Form(
// //           key: _formKey,
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.stretch,
// //             children: [
// //               // حقل اسم الموقع باستخدام الـ Card الذهبي الاحترافي
// //               LocationInputCard(
// //                 title: locale.locationName,
// //                 height: 100.h,
// //                 child: Padding(
// //                   padding: EdgeInsets.symmetric(horizontal: 16.w),
// //                   child: TextFormField(
// //                     controller: _nameController,
// //                     validator: (v) => (v == null || v.isEmpty) ? locale.enterRequiredData : null,
// //                     style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
// //                     decoration: InputDecoration(
// //                       hintText: locale.enterRequiredData,
// //                       hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
// //                       border: InputBorder.none,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               SizedBox(height: 20.h),

// //               // حقل اختيار الموقع من الخريطة
// //               LocationInputCard(
// //                 title: locale.chooseCoordinates,
// //                 height: 380.h,
// //                 child: Padding(
// //                   padding: EdgeInsets.all(8.w),
// //                   child: ClipRRect(
// //                     borderRadius: BorderRadius.circular(12.r),
// //                     child: GoogleMap(
// //                       initialCameraPosition: CameraPosition(target: _selectedPos, zoom: 15),
// //                       onTap: (pos) => setState(() => _selectedPos = pos),
// //                       zoomControlsEnabled: false,
// //                       myLocationButtonEnabled: true,
// //                       markers: {
// //                         Marker(
// //                           markerId: const MarkerId('selected_pos'),
// //                           position: _selectedPos,
// //                           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
// //                         ),
// //                       },
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               SizedBox(height: 30.h),

// //               // الأزرار: حفظ وإلغاء
// //               Row(
// //                 children: [
// //                   Expanded(
// //                     flex: 2,
// //                     child: CustomBigButton(
// //                       text: locale.saveLocation,
// //                       backgroundColor: AppColor.darkBlack,
// //                       textColor: AppColor.golden,
// //                       onPressed: () {
// //                         if (_formKey.currentState!.validate()) {
// //                           ref.read(addLocationControllerProvider.notifier).addNewLocation(
// //                                 name: _nameController.text.trim(),
// //                                 lat: _selectedPos.latitude,
// //                                 lng: _selectedPos.longitude,
// //                               );
// //                         }
// //                       },
// //                     ),
// //                   ),
// //                   SizedBox(width: 12.w),
// //                   Expanded(
// //                     child: GestureDetector(
// //                       onTap: () => Navigator.pop(context),
// //                       child: Container(
// //                         height: 50.h,
// //                         decoration: BoxDecoration(
// //                           color: Colors.white,
// //                           borderRadius: BorderRadius.circular(14.r),
// //                           border: Border.all(color: const Offset(0, 0).direction == 0 ? const Color(0xFFE0E0E0) : const Color(0xFFE0E0E0)),
// //                           boxShadow: [
// //                             BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
// //                           ],
// //                         ),
// //                         child: Center(
// //                           child: Text(
// //                             locale.cancel,
// //                             style: TextStyle(
// //                               color: const Color(0xFF6A7282),
// //                               fontWeight: FontWeight.bold,
// //                               fontSize: 16.sp,
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }




// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:yusr/core/common/widgets/custom_golden_back_button.dart';
// // import 'package:yusr/core/common/widgets/widget.dart';
// // import 'package:yusr/core/constants/app_color.dart';
// // import 'package:yusr/core/constants/app_size.dart';
// // import 'package:yusr/core/extensions/async_value_ui.dart';
// // import 'package:yusr/core/extensions/context_extension.dart';
// // import 'package:yusr/features/campaign_location/presentation/widgets/location_input_card.dart';
// // import 'package:yusr/features/campaign_location/providers/add_location_controller_provider.dart';

// // class AddLocationView extends ConsumerStatefulWidget {
// //   const AddLocationView({super.key});

// //   @override
// //   ConsumerState<AddLocationView> createState() => _AddLocationViewState();
// // }

// // class _AddLocationViewState extends ConsumerState<AddLocationView> {
// //   final _nameController = TextEditingController();
// //   final _formKey = GlobalKey<FormState>();
// //   LatLng _selectedPos = const LatLng(21.4225, 39.8262); // مكة المكرمة

// //   @override
// //   void dispose() {
// //     _nameController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final locale = context.locale;

// //     // الاستماع لحالات الـ Controller (تحميل، خطأ، نجاح)
// //     ref.listen(addLocationControllerProvider, (prev, next) {
// //       if (next.isLoading) {
// //         context.showLoadingDialog();
// //       } else if (next.hasError) {
// //         context.closeLoadingDialog();
// //         context.showErrorSnackBar(next.errorMessage); // استخدام الامتداد الموحد للخطأ
// //       } else if (next.hasValue && next.value != null) {
// //         context.closeLoadingDialog();
// //         context.showSuccessSnackBar(next.value!.message); // رسالة النجاح من السيرفر
// //         Navigator.pop(context); // العودة التلقائية بعد النجاح
// //       }
// //     });

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(locale.addLocation),
// //         leading: Padding(
// //           padding: EdgeInsets.symmetric(horizontal: 10.w),
// //           child: const UnconstrainedBox(child: CustomGoldenBackButton()),
// //         ),
// //       ),
// //       body: SingleChildScrollView(
// //         padding: EdgeInsets.all(AppSize.paddingOfPage.w),
// //         child: Form(
// //           key: _formKey,
// //           child: Column(
// //             children: [
// //               // حقل اسم الموقع
// //               LocationInputCard(
// //                 title: locale.locationName,
// //                 height: 100.h,
// //                 child: Padding(
// //                   padding: EdgeInsets.symmetric(horizontal: 16.w),
// //                   child: TextFormField(
// //                     controller: _nameController,
// //                     validator: (v) => v!.isEmpty ? locale.enterRequiredData : null,
// //                     decoration: InputDecoration(
// //                       hintText: locale.enterRequiredData,
// //                       border: InputBorder.none,
// //                       enabledBorder: InputBorder.none,
// //                       focusedBorder: InputBorder.none,
// //                       filled: false,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               SizedBox(height: 20.h),

// //               // حقل الخريطة
// //               LocationInputCard(
// //                 title: locale.chooseCoordinates, // تم الاستخراج للترجمة
// //                 height: 380.h,
// //                 child: Padding(
// //                   padding: EdgeInsets.all(8.w),
// //                   child: ClipRRect(
// //                     borderRadius: BorderRadius.circular(12.r),
// //                     child: GoogleMap(
// //                       initialCameraPosition: CameraPosition(target: _selectedPos, zoom: 15),
// //                       onTap: (pos) => setState(() => _selectedPos = pos),
// //                       markers: {
// //                         Marker(markerId: const MarkerId('selected_pos'), position: _selectedPos),
// //                       },
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               SizedBox(height: 30.h),

// //               // أزرار الحفظ والإلغاء
// //               Row(
// //                 children: [
// //                   Expanded(
// //                     flex: 2,
// //                     child: CustomBigButton(
// //                       text: locale.saveLocation, // تم الاستخراج للترجمة
// //                       onPressed: () {
// //                         if (_formKey.currentState!.validate()) {
// //                           ref.read(addLocationControllerProvider.notifier).addNewLocation(
// //                                 name: _nameController.text.trim(),
// //                                 lat: _selectedPos.latitude,
// //                                 lng: _selectedPos.longitude,
// //                               );
// //                         }
// //                       },
// //                     ),
// //                   ),
// //                   SizedBox(width: 12.w),
// //                   Expanded(
// //                     child: GestureDetector(
// //                       onTap: () => Navigator.pop(context),
// //                       child: Container(
// //                         height: 50.h,
// //                         decoration: BoxDecoration(
// //                           color: AppColor.withe,
// //                           borderRadius: BorderRadius.circular(14.r),
// //                           border: Border.all(color: const Color(0xFFE0E0E0)),
// //                         ),
// //                         child: Center(
// //                           child: Text(
// //                             locale.cancel, // تم الاستخراج للترجمة
// //                             style: TextStyle(
// //                               color: const Color(0xFF6A7282),
// //                               fontWeight: FontWeight.bold,
// //                               fontSize: 16.sp,
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }