import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/constants/app_route.dart';

// final appRouterProvider = Provider<AppRouter>((ref) {
//   return AppRouter();
// });

part 'app_router_provider.g.dart';

@riverpod
AppRouter appRouter(Ref ref) {
  return AppRouter();
}
