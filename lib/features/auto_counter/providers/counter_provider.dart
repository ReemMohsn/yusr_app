import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'counter_provider.g.dart';

@riverpod
class CounterTypeController extends _$CounterTypeController {
  @override
  bool build() {
    // القيمة الابتدائية (true تعني طواف مثلاً)
    return true;
  }

  /// دالة لتغيير النوع (Toggle)
  void toggle() {
    state = !state;
  }

  /// دالة لضبط النوع بشكل مباشر
  void setType(bool isTawaf) {
    state = isTawaf;
  }
}
