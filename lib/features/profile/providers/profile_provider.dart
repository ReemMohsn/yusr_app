import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/features/profile/data/models/user_details_model.dart';
import 'package:yusr/features/profile/providers/profile_repository_provider.dart';

part 'profile_provider.g.dart';

@riverpod
Future<UserDetailsModel> userDetails(Ref ref) async {
  final repository = ref.watch(profileRepositoryProvider);
  final response = await repository.getUserDetails();
  
  if (response.data != null) {
    return response.data!;
  } else {
    throw Exception(response.message);
  }
}
