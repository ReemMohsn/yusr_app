import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/services/shared_preferences_service.dart';
part 'shared_preferences_service_provider.g.dart';

@riverpod
SharedPreferencesService sharedPreferencesService(Ref ref) {
  return SharedPreferencesService();
}
