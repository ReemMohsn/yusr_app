import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/common/providers/api_service_provider.dart';
import 'package:yusr/features/announcements_notifications/data/repositories/announcements_repository.dart';

part 'announcements_repository_provider.g.dart';

@riverpod
AnnouncementsRepository announcementsRepository(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AnnouncementsRepository(apiService, ref);
}
