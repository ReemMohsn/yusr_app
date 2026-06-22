import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/constants/app_route.dart';

part 'app_router_provider.g.dart';

@riverpod
AppRouter appRouter(Ref ref) {
  return AppRouter();
}
