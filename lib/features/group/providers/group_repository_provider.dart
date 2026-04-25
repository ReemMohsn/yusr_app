import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/common/providers/api_service_provider.dart';
import 'package:yusr/features/group/data/repositories/group_repository.dart';

part 'group_repository_provider.g.dart';

@riverpod
GroupRepository groupRepository(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return GroupRepository(apiService, ref);
}
