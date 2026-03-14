import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/return_me/presentation/widgets/return_me_button.dart';

class ReturnMeView extends ConsumerStatefulWidget {
  const ReturnMeView({super.key});

  @override
  ConsumerState<ReturnMeView> createState() => _ReturnMeViewState();
}

class _ReturnMeViewState extends ConsumerState<ReturnMeView> {
  @override
  Widget build(BuildContext context) {
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
              onTap: () {
                // سيتم إضافة منطق الـ GPS هنا لاحقاً
                debugPrint("Return Me Pressed");
              },
            ),
          ],
        ),
      ),
    );
  }
}
