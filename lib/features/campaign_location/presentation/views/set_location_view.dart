import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yusr/core/common/widgets/custom_golden_back_button.dart';
import 'package:yusr/core/constants/app_color.dart';
import 'package:yusr/core/constants/app_size.dart'; // ملف الأحجام المعتمد
import 'package:yusr/core/extensions/async_value_ui.dart';
import 'package:yusr/core/extensions/context_extension.dart';
import 'package:yusr/core/services/API/ApiResponse.dart';
import 'package:yusr/features/campaign_location/presentation/widgets/location_action_buttons.dart';
import '../widgets/location_item_card.dart';
import 'package:yusr/features/campaign_location/providers/get_locations_provider.dart';
import 'package:yusr/features/campaign_location/providers/set_active_location_controller.dart';

class SetLocationView extends ConsumerStatefulWidget {
  const SetLocationView({super.key});

  @override
  ConsumerState<SetLocationView> createState() => _SetLocationViewState();
}

class _SetLocationViewState extends ConsumerState<SetLocationView> {
  // استخدام ValueNotifier بدلاً من setState لإدارة اختيار الموقع
  final ValueNotifier<int?> _selectedLocationIdNotifier = ValueNotifier<int?>(
    null,
  );
  int? _initialActiveId;
  bool _isInitialized = false;

  @override
  void dispose() {
    _selectedLocationIdNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    final theme = Theme.of(context).textTheme;
    final locationsAsync = ref.watch(getCampaignLocationsProvider);
// الاستماع لحالة الـ Provider لتفعيل الموقع (نفس طريقة الإعلانات)
    ref.listen(setActiveLocationControllerProvider, (_, state) {
      if (state.isLoading) {
        context.showLoadingDialog();
      } else if (state.hasError) {
        context.closeLoadingDialog();
        context.showErrorSnackBar(state.errorMessage);
      } else if (state.hasValue && state.value != null) {
        context.closeLoadingDialog();
        context.showSuccessSnackBar(locale.updateSuccess);
        
        // إذا كنتِ تحتاجين لتحديث قائمة المواقع أو تفاصيل الحملة لتنعكس حالة النشاط فوراً:
        // ref.invalidate(campaignLocationsProvider); 
        
        Navigator.pop(context);
      }
    });


    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(locale.locationList),
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: const UnconstrainedBox(child: CustomGoldenBackButton()),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.only(top: AppSize.paddingOfPage.h), // بديل SafeArea
        child: Column(
          children: [
            Expanded(
              child: locationsAsync.when(
                data: (data) {
                  if (data == null)
                    return Center(
                      child: Text(locale.notFound, style: theme.bodyMedium),
                    );

                  final allLocations = [
                    if (data.currentLocation != null) data.currentLocation!,
                    ...data.previousLocations,
                  ];

                  
                  // تهيئة البيانات لأول مرة بأمان خارج دورة البناء المباشرة لتجنب تضارب الـ Frame
                  if (!_isInitialized && data.currentLocation != null) {
                    _isInitialized = true;
                    _initialActiveId = data.currentLocation!.locationId;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _selectedLocationIdNotifier.value = data.currentLocation!.locationId;
                    });
                  }

                  return ListView.separated(
                    padding: EdgeInsets.all(AppSize.paddingOfPage.w),
                    itemCount: allLocations.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),

                    itemBuilder: (context, index) {
                      final loc = allLocations[index];

                      return ValueListenableBuilder<int?>(
                        valueListenable: _selectedLocationIdNotifier,
                        builder: (context, selectedId, _) {
                          return LocationItemCard(
                            loc: loc,
                            isSelected: selectedId == loc.locationId,
                            isCurrentlyActive:
                                loc.locationId == _initialActiveId,
                            locale: locale,
                            theme: theme,
                            onTap: () {
                              _selectedLocationIdNotifier.value =
                                  loc.locationId;
                            },
                          );
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColor.golden),
                ),
                error: (e, _) => Center(
                  child: Text(
                    locale.fetchDataError,
                    style: theme.bodyMedium?.copyWith(color: AppColor.danger),
                  ),
                ),
              ),
            ),

            // منطقة الأزرار
            ValueListenableBuilder<int?>(
              valueListenable: _selectedLocationIdNotifier,
              builder: (context, selectedId, _) {
                return LocationActionButtons(
                  theme: theme,
                  canSave: selectedId != null && selectedId != _initialActiveId,
                  saveLabel: locale.saveChanges,
                  cancelLabel: locale.cancel,
                  onCancel: () => Navigator.pop(context),
                  onSave: () {
                    ref
                        .read(setActiveLocationControllerProvider.notifier)
                        .changeActiveLocation(selectedId!);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
