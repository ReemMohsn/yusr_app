import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/features/announcements_notifications/data/models/target_audience_model.dart';
import 'package:yusr/features/announcements_notifications/providers/announcements_repository_provider.dart';

part 'target_audiences_provider.g.dart';

@riverpod
Future<List<TargetAudienceModel>> targetAudiences(Ref ref) async {
  final response = await ref
      .watch(announcementsRepositoryProvider)
      .getTargetAudiences();
  return response.data ?? [];
}
