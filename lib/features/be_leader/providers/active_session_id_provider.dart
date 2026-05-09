import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_session_id_provider.g.dart';

@Riverpod(keepAlive: true)
class ActiveSessionId extends _$ActiveSessionId {
  @override
  int build() {
    return 0;
  }

  void updateSessionId(int id) {
    state = id;
  }
}
