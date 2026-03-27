import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/common/widgets/custom_golden_back_button.dart';
import 'package:yusr/core/constants/app_route.dart';
import 'package:yusr/core/constants/app_size.dart';
import 'package:yusr/core/extensions/async_value_ui.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/features/be_leader/providers/start_session_controller.dart';
import 'package:yusr/core/common/widgets/big_circular_button.dart';

class LeaderStartSessionView extends ConsumerWidget {
  const LeaderStartSessionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale;

    ref.listen(startSessionControllerProvider, (_, state) {
      if (state.isLoading) {
        context.showLoadingDialog();
      } else if (state.hasError) {
        context.closeLoadingDialog();
        context.showErrorSnackBar(state.errorMessage);
        print(state.errorMessage);
      } else if (state.hasValue && state.value != null) {
        context.closeLoadingDialog();
        final sessionId = state.value!.data!.sessionId;
        context.showSuccessSnackBar(state.value!.message);

        Navigator.of(
          context,
        ).pushNamed(AppRoute.leaderPilgrimsListView, arguments: sessionId);
      }
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(locale.becomeALeader),
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: const UnconstrainedBox(child: CustomGoldenBackButton()),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSize.paddingOfPage),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigcircularButton(
              title: locale.startSession,
              onTap: () {
                ref
                    .read(startSessionControllerProvider.notifier)
                    .startTrackingSession();
              },
            ),
          ],
        ),
      ),
    );
  }
}
