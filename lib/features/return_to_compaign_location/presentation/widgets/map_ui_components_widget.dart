// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:yusr/core/constants/app_color.dart';

// // كبسولة العنوان العلوية
// class MapHeaderCapsule extends StatelessWidget {
//   const MapHeaderCapsule({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 12.h),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(30.r),
//         boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(Icons.location_on, color: AppColor.golden, size: 20.sp),
//           SizedBox(width: 8.w),
//           Text("موقع الحملة", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
//         ],
//       ),
//     );
//   }
// }

// // الزر السفلي لعرض المسافة
// class MapBottomActionBtn extends StatelessWidget {
//   final String distance;
//   final double bearing;
//   const MapBottomActionBtn({super.key, required this.distance,required this.bearing,});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 65.h,
//       decoration: BoxDecoration(
//         color: AppColor.golden,
//         borderRadius: BorderRadius.circular(30.r),
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 25.w),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(distance, style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold)),
//           Transform.rotate(
//             angle: (bearing * (3.141592653589793 / 180)), // تحويل الدرجات لراديان
//             child: Icon(
//               Icons.navigation, // أو أيقونة السهم التي تستخدمها
//               color: Colors.white,
//               size: 24.sp,
//           )),
//         ],
//       ),
//     );
//   }
// }