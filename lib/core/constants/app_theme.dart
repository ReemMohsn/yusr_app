import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    fontFamily: 'Cairo',
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColor.backgroundColor,

    // colorScheme: ColorScheme.fromSeed(
    //   seedColor: primaryColor,
    //   primary: primaryColor,
    //   secondary: primaryColor,
    // ),

    // text
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: AppColor.darkBlack,
      ),
      headlineMedium: TextStyle(fontSize: 10.sp, color: AppColor.midlineColor),
      bodyLarge: TextStyle(
        fontSize: 8.sp,
        fontWeight: FontWeight.bold,
        color: AppColor.baseFontColor,
      ),
      // bodyMedium: TextStyle(fontSize: 7.sp, color: Colors.black87),
      // bodySmall: TextStyle(fontSize: 6.sp, color: Colors.black54),
    ),

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: AppColor.darkBlack,
      elevation: 0,
      centerTitle: false,
      // titleTextStyle: TextStyle(
      //   color: Colors.black,
      //   fontSize: 20.sp,
      //   fontWeight: FontWeight.bold,
      // ),
      iconTheme: IconThemeData(color: Colors.black),
    ),

    // Buttons
    // elevatedButtonTheme: ElevatedButtonThemeData(
    //   style: ElevatedButton.styleFrom(
    //     backgroundColor: primaryColor,
    //     foregroundColor: Colors.white,
    //     padding: EdgeInsets.symmetric(vertical: 14.h),
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(26.r),
    //     ),
    //     textStyle: TextStyle(fontSize: 8.sp, fontWeight: FontWeight.bold),
    //   ),
    // ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(7.w),
        foregroundColor: AppColor.golden,
        backgroundColor: Colors.transparent,
        elevation: 0,
        side: BorderSide(color: AppColor.golden, width: 0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        textStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    // input
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColor.inputFieldColor,
      // المسافات الداخلية للحقل
      contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
      // تنسيق النص التلميحي (Hint)
      hintStyle: TextStyle(
        color: AppColor.lightFontColor,
        fontSize: 8.sp,
        fontWeight: FontWeight.w400,
        fontFamily: 'Cairo',
      ),

      // لون الأيقونات الافتراضي داخل الحقل
      prefixIconColor: AppColor.golden,
      suffixIconColor: AppColor.golden,

      // الحدود الافتراضية
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: const BorderSide(
          width: 1,
          color: AppColor.inputFieldBoundaries,
        ),
      ),

      // الحدود في الوضع العادي (غير مفعل)
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: const BorderSide(color: AppColor.inputFieldBoundaries),
      ),

      // الحدود عند الكتابة (Focus)
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: const BorderSide(color: AppColor.golden),
      ),

      // الحدود عند وجود خطأ
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: const BorderSide(color: AppColor.danger),
      ),

      // الحدود عند الكتابة وفي نفس الوقت يوجد خطأ
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: const BorderSide(color: AppColor.danger, width: 1.5),
      ),
    ),

    // Navigation
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: AppColor.golden,
          );
        }
        return const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: AppColor.lightFontColor,
        );
      }),

      // إعدادات ألوان الأيقونات
      iconTheme: WidgetStateProperty.resolveWith((states) {
        // حالة العنصر المختار (Active)
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(
            color: AppColor.golden, // اللون الذهبي
            size: 24, // حجم الأيقونة المختارة (اختياري)
          );
        }
        // حالة العنصر غير المختار (Inactive)
        return const IconThemeData(
          color: Colors.grey, // اللون الرمادي
          size: 22, // حجم الأيقونة غير المختارة (اختياري)
        );
      }),
    ),
  );
}
