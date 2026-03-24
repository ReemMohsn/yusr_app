import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_day_index_provider.g.dart';

@riverpod
class CurrentDayIndex extends _$CurrentDayIndex {
  @override
  int build() {
    return 0; // Starts at index 0 (first day)
  }

  void increment(int maxLength) {
    if (state < maxLength - 1) {
      state++;
    }
  }

  void decrement() {
    if (state > 0) {
      state--;
    }
  }

  void reset() {
    state = 0;
  }

  void setIndex(int index) {
    state = index;
  }
}
