import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color backgroundLight = Color(0xFFF7F7F7);
  static const Color white = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Tajawal-Regular',
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.white,

    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: primaryColor,
    ),

    // textTheme: TextTheme(
    //   headlineLarge: TextStyle(
    //     fontSize: 16.sp,
    //     fontWeight: FontWeight.bold,
    //     color: Colors.black,
    //   ),
    //   headlineMedium: TextStyle(
    //     fontSize: 10.sp,
    //     fontWeight: FontWeight.bold,
    //     color: Colors.black,
    //   ),
    //   bodyLarge: TextStyle(fontSize: 8.sp, color: Colors.black87),
    //   bodyMedium: TextStyle(fontSize: 7.sp, color: Colors.black87),
    //   bodySmall: TextStyle(fontSize: 6.sp, color: Colors.black54),
    // ),

    // // AppBar
    // appBarTheme: AppBarTheme(
    //   backgroundColor: Colors.white,
    //   elevation: 0,
    //   centerTitle: true,
    //   titleTextStyle: TextStyle(
    //     color: Colors.black,
    //     fontSize: 20.sp,
    //     fontWeight: FontWeight.bold,
    //   ),
    //   iconTheme: IconThemeData(color: Colors.black),
    // ),

    // // Input fields
    // inputDecorationTheme: InputDecorationTheme(
    //   filled: true,
    //   fillColor: backgroundLight,
    //   contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 18.w),
    //   hintStyle: TextStyle(color: Colors.grey, fontSize: 6.sp),
    //   border: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(16.r),
    //     borderSide: BorderSide(color: Color(0xFFE4E4E4), width: 1.5.w),
    //   ),
    //   focusedBorder: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(16.r),
    //     borderSide: BorderSide(color: primaryColor, width: 1.5.w),
    //   ),
    //   errorBorder: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(16.r),
    //     borderSide: BorderSide(color: Colors.red, width: 1.5.w),
    //   ),
    // ),

    // // Buttons
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
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Tajawal-Regular',
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundDark,

    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
      primary: primaryColor,
      secondary: primaryColor,
      surface: surfaceDark,
    ),

    // textTheme: TextTheme(
    //   headlineLarge: TextStyle(
    //     fontSize: 16.sp,
    //     fontWeight: FontWeight.bold,
    //     color: Colors.white,
    //   ),
    //   headlineMedium: TextStyle(
    //     fontSize: 10.sp,
    //     fontWeight: FontWeight.bold,
    //     color: Colors.white,
    //   ),
    //   bodyLarge: TextStyle(fontSize: 8.sp, color: Colors.white70),
    //   bodyMedium: TextStyle(fontSize: 7.sp, color: Colors.white70),
    //   bodySmall: TextStyle(fontSize: 6.sp, color: Colors.white60),
    // ),

    // // AppBar
    // appBarTheme: AppBarTheme(
    //   backgroundColor: backgroundDark,
    //   elevation: 0,
    //   centerTitle: true,
    //   titleTextStyle: TextStyle(
    //     color: Colors.white,
    //     fontSize: 20.sp,
    //     fontWeight: FontWeight.bold,
    //   ),
    //   iconTheme: const IconThemeData(color: Colors.white),
    // ),

    // // Input fields
    // inputDecorationTheme: InputDecorationTheme(
    //   filled: true,
    //   fillColor: surfaceDark,
    //   contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 18.w),
    //   hintStyle: TextStyle(color: Colors.grey, fontSize: 6.sp),
    //   border: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(16.r),
    //     borderSide: BorderSide(color: Color(0xFFE4E4E4), width: 1.5.w),
    //   ),
    //   focusedBorder: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(16.r),
    //     borderSide: BorderSide(color: primaryColor, width: 1.5.w),
    //   ),
    //   errorBorder: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(16.r),
    //     borderSide: BorderSide(color: Colors.red, width: 1.5.w),
    //   ),
    // ),
    // // Buttons
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
  );
}
