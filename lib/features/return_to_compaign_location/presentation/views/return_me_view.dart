import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import '../widgets/return_me_button.dart';
import '../../providers/fetch_camp_location_controller.dart';

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
          children: [
            ReturnMeButton(
              title: locale.returnMe,
              onTap: () async {
                final response = await ref.read(fetchCampLocationControllerProvider.future);
                if (response?.data != null && context.mounted) {
                  Navigator.of(context).pushNamed(AppRoute.returnMeMapView, arguments: response!.data);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}