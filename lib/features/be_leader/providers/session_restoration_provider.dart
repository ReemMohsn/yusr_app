import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/features/be_leader/presentation/services/session_restoration_service.dart';

part 'session_restoration_provider.g.dart';

@riverpod
SessionRestorationService sessionRestorationService(Ref ref) {
  return SessionRestorationService(ref);
}
