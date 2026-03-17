// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:yusr/core/constants/app_color.dart';
// import 'package:yusr/core/constants/app_route.dart';
// import 'package:yusr/core/extensions/context_extension.dart';

// class ReturnMeView extends ConsumerWidget {
//   const ReturnMeView({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final locale = context.locale;

//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // في ملف return_me_view.dart

// GestureDetector(
//   onTap: () {
//     // الانتقال باستخدام الاسم المعرف في AppRoute
//     Navigator.pushNamed(context, AppRoute.returnMeMapView);
//   },
//   child: Container(
//     width: 220.w,
//     height: 220.w,
//     decoration: BoxDecoration(
//       shape: BoxShape.circle,
//       color: AppColor.darkBlack, // استخدام ملف الألوان الخاص بك
//       border: Border.all(
//         color: AppColor.golden,
//         width: 1.5,
//       ),
//       boxShadow: [
//         BoxShadow(
//           color: AppColor.golden.withValues(alpha: 0.4),
//           blurRadius: 25,
//           spreadRadius: 2,
//         ),
//       ],
//     ),
//     child: Center(
//       child: Text(
//         locale.returnMe, // "أرجِعني"
//         style: TextStyle(
//           color: AppColor.golden,
//           fontSize: 35.sp,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     ),
//   ),
// ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/return_to_compaign_location/presentation/widgets/return_me_button.dart';
import 'package:yusr/features/return_to_compaign_location/providers/camp_location_provider.dart';

class ReturnMeView extends ConsumerWidget {
  const ReturnMeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale;

    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSize.paddingOfPage),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            ReturnMeButton(
              title: locale.returnMe,
              onTap: () async {
                final campLocation = await ref.read(
                  fetchCampLocationProvider.future,
                );

                if (campLocation != null && context.mounted) {
                  Navigator.of(context).pushNamed(
                    AppRoute.returnMeMapView,
                    arguments: campLocation,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
