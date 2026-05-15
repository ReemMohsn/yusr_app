import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yusr/core/constants/shared_preferences_keys.dart';

part 'active_session_id_provider.g.dart';

@Riverpod(keepAlive: true)
class ActiveSessionId extends _$ActiveSessionId {
  @override
  int build() {
    _loadSavedSession();
    return 0;
  }

  Future<void> _loadSavedSession() async {
    try {
      final prefs = SharedPreferencesAsync();
      final savedId = await prefs.getInt(SharedPreferencesKeys.sessionId);
      if (savedId != null && savedId > 0) {
        state = savedId;
      }
    } catch (e) {
      // تجاهل الأخطاء
    }
  }

  void updateSessionId(int id) {
    state = id;
  }
}
