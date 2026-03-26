import 'package:yusr/core/common/providers/shared_preferences_service_provider.dart';
import 'package:yusr/core/services/API/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_service_provider.g.dart';

@riverpod
ApiService apiService(Ref ref) {
  final prefsService = ref.watch(sharedPreferencesServiceProvider);
  return ApiService(prefsService);
}
