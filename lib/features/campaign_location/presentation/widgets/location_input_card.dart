import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';

class LocationInputCard extends StatelessWidget {
  final String title;
  final Widget child;
  final double? height;

  const LocationInputCard({
    super.key,
    required this.title,
    required this.child,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        // التصميم الذهبي الجانبي
        border: const Border(
          right: BorderSide(color: AppColor.golden, width: 4.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // رأس الكرت (العنوان)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColor.golden.withOpacity(0.05), Colors.transparent],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                                
                Container(
                  width: 4.w,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: AppColor.golden,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  
                ),
                SizedBox(width: 8.w),
                Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFF6A7282),
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),

              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF5F5F0)),
          // محتوى الكرت (Input أو Map)
          height != null ? Expanded(child: child) : child,
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:yusr/core/constants/app_color.dart';

// class LocationInputCard extends StatelessWidget {
//   final String title;
//   final Widget child;
//   final double? height;

//   const LocationInputCard({
//     super.key,
//     required this.title,
//     required this.child,
//     this.height,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: height,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16.r),
//         // الحافة الذهبية الجانبية تعطي لمسة التصميم
//         border: const Border(
//           right: BorderSide(color: AppColor.golden, width: 4),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//             child: Row(
//               children: [
//                 // العنوان
//                 Text(
//                   title,
//                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                         color: const Color(0xFF6A7282),
//                         fontWeight: FontWeight.bold,
//                         fontSize: 14.sp,
//                       ),
//                 ),
//                 const Spacer(),
//                 // العلامة الذهبية الصغيرة (كما في الصورة)
//                 Container(
//                   width: 4.w,
//                   height: 16.h,
//                   decoration: BoxDecoration(
//                     color: AppColor.golden,
//                     borderRadius: BorderRadius.circular(2.r),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // فاصل بلون هادئ جداً
//           const Divider(height: 1, color: Color(0xFFF5F5F0)),
//           Expanded(child: child),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:yusr/core/constants/app_color.dart';

// class LocationInputCard extends StatelessWidget {
//   final String title;
//   final Widget child;
//   final double? height;

//   const LocationInputCard({
//     super.key,
//     required this.title,
//     required this.child,
//     this.height,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: height,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16.r),
//         border: const Border(
//           right: BorderSide(color: AppColor.golden, width: 4),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//             child: Row(
//               children: [
//                 Text(
//                   title,
//                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                         color: const Color(0xFF6A7282),
//                       ),
//                 ),
//                 const Spacer(),
//                 Container(
//                   width: 4.w,
//                   height: 16.h,
//                   decoration: BoxDecoration(
//                     color: AppColor.golden,
//                     borderRadius: BorderRadius.circular(2.r),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const Divider(height: 1, color: Color(0xFFF5F5F0)),
//           Expanded(child: child),
//         ],
//       ),
//     );
//   }
// }