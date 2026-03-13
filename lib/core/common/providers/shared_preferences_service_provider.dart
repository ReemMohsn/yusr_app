import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/services/shared_preferences_service.dart';

// final sharedPreferencesServiceProvider = Provider<SharedPreferencesService>((
//   ref,
// ) {
//   return SharedPreferencesService();
// });

part 'shared_preferences_service_provider.g.dart';

@riverpod
SharedPreferencesService sharedPreferencesService(Ref ref) {
  return SharedPreferencesService();
}
