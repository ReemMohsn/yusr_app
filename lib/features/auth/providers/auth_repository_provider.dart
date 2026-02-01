import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/common/providers/api_service_provider.dart';

import '../data/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return AuthRepository(apiService, ref);
});
