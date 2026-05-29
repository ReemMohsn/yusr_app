import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/core/extensions/async_value_ui.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import '../../../../core/common/widgets/big_circular_button.dart';
import '../../providers/fetch_camp_location_controller.dart';

class ReturnMeView extends ConsumerWidget {
  const ReturnMeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale;

    ref.listen(fetchCampLocationControllerProvider, (_, state) {
      if (state.isLoading) {
        context.showLoadingDialog();
      } else if (state.hasError) {
        context.closeLoadingDialog();
        context.showErrorSnackBar(state.errorMessage);
      } else if (state.hasValue && state.value != null) {
        context.closeLoadingDialog();

        final data = state.value!.data;
        if (data != null) {
          if (ModalRoute.of(context)?.isCurrent ?? false) {
            Navigator.of(
              context,
            ).pushNamed(AppRoute.returnMeMapView, arguments: data);
          }
        } else {
          context.showErrorSnackBar(locale.loginToViewCampaignLocation);
        }
      }
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSize.paddingOfPage),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigcircularButton(
              title: locale.returnMe,
              onTap: () async {
                await Geolocator.requestPermission();
                ref
                    .read(fetchCampLocationControllerProvider.notifier)
                    .fetchLocation();
              },
            ),
          ],
        ),
      ),
    );
  }
}
