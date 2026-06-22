import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusr/features/be_leader/presentation/services/session_restoration_service.dart';

// استخدام مزود تقليدي للحفاظ على بقائه في الذاكرة (keepAlive) بشكل آمن
final sessionRestorationServiceProvider = Provider<SessionRestorationService>((ref) {
  return SessionRestorationService(ref);
});
