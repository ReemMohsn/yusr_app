import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/features/announcements_notifications/data/enums/target_audience_enum.dart';

part 'selected_audience_provider.g.dart';

@riverpod
class SelectedAudience extends _$SelectedAudience {
  @override
  int? build() {
    // القيمة الافتراضية null (سيتم ضبطها عند تحميل الفئات من الـ API)
    return null;
  }

  void setAudienceId(int id) {
    state = id;
  }
}
