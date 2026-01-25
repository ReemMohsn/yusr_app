import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/services/shared_preferences_service.dart';

final sharedPreferencesServiceProvider = Provider<SharedPreferencesService>((
  ref,
) {
  return SharedPreferencesService();
});
