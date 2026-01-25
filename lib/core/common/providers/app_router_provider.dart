import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/core/constants/app_route.dart';

final appRouterProvider = Provider<AppRouter>((ref) {
  return AppRouter();
});
