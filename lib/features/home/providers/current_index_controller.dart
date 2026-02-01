import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'current_index_controller.g.dart';

@riverpod
class CurrentIndexController extends _$CurrentIndexController {
  @override
  int build() => 0;

  void setIndex(int newIndex) {
    state = newIndex;
  }
}
