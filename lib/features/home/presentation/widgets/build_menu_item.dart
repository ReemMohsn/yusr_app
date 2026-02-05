import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/constants/app_color.dart';

class BuildMenuItem extends StatelessWidget {
  const BuildMenuItem({
    super.key,
    required this.context,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final BuildContext context;
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Container(
        padding: const EdgeInsets.all(8), // مسافة داخلية للأيقونة
        decoration: BoxDecoration(
          color: AppColor.golden, // خلفية ذهبية
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Icon(
          icon,
          color: const Color(
            0xFF1A1A1A,
          ), // لون الأيقونة أسود (أو لون الخلفية الداكن)
          size: 25, // حجم الأيقونة
        ),
      ),
      title: Text(
        title,
        textAlign: TextAlign.right,
        style: const TextStyle(
          color: Colors.white, // لون النص أبيض
          fontSize: 14,
          fontWeight: FontWeight.w500, // جعل الخط أسمك قليلاً
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
    );
  }
}
