import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/active_location_model.dart';
import 'location_repository_provider.dart';

part 'camp_location_provider.g.dart';

@riverpod
Future<ActiveLocationModel?> fetchCampLocation(Ref ref) async {
  final repository = ref.watch(locationRepositoryProvider);
  final response = await repository.getCampLocation();
  return response.data;
}

// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import '../data/models/active_location_model.dart';
// import 'location_repository_provider.dart';

// part 'camp_location_provider.g.dart';

// @riverpod
// Future<ActiveLocationModel?> fetchCampLocation(Ref ref) async {
//   final repository = ref.watch(locationRepositoryProvider);
//   final response = await repository.getCampLocation();

//   return response.data;
// }
