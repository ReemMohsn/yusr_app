import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_size.dart'; 
import 'package:flutter_markdown/flutter_markdown.dart';

class ShariaAnswerCardWidget extends StatelessWidget {
  final String title;
  final String content;
  final bool isLoading;

  const ShariaAnswerCardWidget({
    super.key,
    required this.title,
    required this.content,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const _ShariaAnswerShimmer();
    }
    // التعديل الجوهري: تمرير المتغيرات للـ ActiveAnswerCard
    return _ActiveAnswerCard(
      title: title, 
      content: content,
    );
  }
}

class _ActiveAnswerCard extends StatelessWidget {
  final String title;
  final String content;
  const _ActiveAnswerCard({
    required this.title, 
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSize.paddingOfPage.w),
      decoration: _SharedCardDecoration.decoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _CardHeader(title: title),
          SizedBox(height: 12.h),
          
          // ويدجت المارك داون لعرض النقاط (*) بشكل منسق
          MarkdownBody(
            data: content,
            selectable: true,
            shrinkWrap: true,
            styleSheet: MarkdownStyleSheet(
              p: theme.bodySmall?.copyWith(
                color: AppColor.baseFontColor,
                height: 1.8,
                fontSize: 14.sp,
              ),
              listBullet: theme.bodySmall?.copyWith(
                color: AppColor.golden,
                fontWeight: FontWeight.bold,
              ),
              blockSpacing: 10.h,
            ),
          ),
        ],
      ),
    );
  }
}
// 2. ودجت الشيمر (منفصل ومعرف كـ const لتحسين الأداء)
class _ShariaAnswerShimmer extends StatelessWidget {
  const _ShariaAnswerShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.inputFieldBoundaries,
      highlightColor: AppColor.inputFieldColor,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppSize.paddingOfPage.w),
        decoration: _SharedCardDecoration.decoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 24.sp, height: 24.sp, color: AppColor.withe,),
                Container(width: 80.w, height: 18.sp, color: AppColor.withe,),
              ],
            ),
            SizedBox(height: 12.h),
            Container(width: double.infinity, height: 12.h, color: AppColor.withe,),
            SizedBox(height: 8.h),
            Container(width: double.infinity, height: 12.h, color: AppColor.withe,),
            SizedBox(height: 8.h),
            Container(width: 150.w, height: 12.h, color: AppColor.withe,),
          ],
        ),
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  final String title;
  const _CardHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title, 
          style: theme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColor.baseFontColor,
          ),
        ),
        Icon(Icons.verified_user_outlined, color: AppColor.golden, size: 24.sp)
      ],
    );
  }
}

class _SharedCardDecoration {
  static BoxDecoration decoration = BoxDecoration(
    color: AppColor.withe, 
    borderRadius: BorderRadius.circular(20.r),
    border: Border(
      right: BorderSide(color: AppColor.golden, width: 4.w),
    ),
    boxShadow: [
      BoxShadow(
        color: AppColor.baseFontColor.withOpacity(0.05),
        blurRadius: 5,
        offset: const Offset(0, 2),
      ),
    ],
  );
}
