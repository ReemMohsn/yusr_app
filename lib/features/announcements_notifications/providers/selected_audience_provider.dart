import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/features/announcements_notifications/data/enums/target_audience_enum.dart';

part 'selected_audience_provider.g.dart';

@riverpod
class SelectedAudience extends _$SelectedAudience {
  @override
  TargetAudience build() {
    // القيمة الافتراضية
    return TargetAudience.all;
  }

  // دالة لتحديث القيمة
  void setAudience(TargetAudience newAudience) {
    state = newAudience;
  }
}
