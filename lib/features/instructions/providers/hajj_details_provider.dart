import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/config/generated/l10n.dart';
import 'package:yusr/features/instructions/data/models/hajj_details_models.dart';
import 'package:yusr/features/instructions/data/repositories/hajj_details_repository.dart';

part 'hajj_details_provider.g.dart';

@riverpod
HajjDetailsRepository hajjDetailsRepository(Ref ref) {
  return HajjDetailsRepository();
}

@riverpod
List<HajjDayModel> hajjDays(Ref ref, String hajjType, {required AppLocalizations l10n}) {
  final repository = ref.watch(hajjDetailsRepositoryProvider);
  return repository.getHajjDays(hajjType, l10n);
}
