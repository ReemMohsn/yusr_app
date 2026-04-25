import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/common/providers/api_service_provider.dart';
import 'package:yusr/features/profile/data/repositories/profile_repository.dart';

part 'profile_repository_provider.g.dart';

@riverpod
ProfileRepository profileRepository(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ProfileRepository(apiService, ref);
}
