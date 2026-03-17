// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:yusr/core/common/providers/api_service_provider.dart';
// import '../data/repositories/location_repository.dart';

// // part 'location_repository_provider.g.dart';
// part 'location_repository_provider.g.dart';

// @riverpod
// LocationRepository locationRepository(LocationRepositoryRef ref) {
//   final apiService = ref.watch(apiServiceProvider);
//   return LocationRepository(apiService, ref);
// }

// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:yusr/core/common/providers/api_service_provider.dart';
// import '../data/repositories/location_repository.dart';

// part 'location_repository_provider.g.dart';

// @riverpod
// LocationRepository locationRepository(Ref ref) {
//   final apiService = ref.watch(apiServiceProvider);
//   return LocationRepository(apiService, ref);
// }

// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/common/providers/api_service_provider.dart';
import '../data/repositories/location_repository.dart';

part 'location_repository_provider.g.dart';

@riverpod
LocationRepository locationRepository(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return LocationRepository(apiService, ref);
}
