import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'counter_provider.g.dart';

@riverpod
class CounterTypeController extends _$CounterTypeController {
  @override
  bool build() {
    // true = طواف (Tawaf) false = سعي (Sa'ee)
    return true;
  }

  // دالة للتحويل بين النوعين
  void toggleType() {
    state = !state;
  }

  // دالة لتحديد النوع مباشرة
  void setType(bool isTawaf) {
    state = isTawaf;
  }
}