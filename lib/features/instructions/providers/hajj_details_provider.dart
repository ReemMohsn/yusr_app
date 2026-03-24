import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/config/generated/l10n.dart';
import 'package:yusr/features/instructions/data/models/hajj_day_model.dart';
import 'package:yusr/features/instructions/providers/instructions_provider.dart';

part 'hajj_details_provider.g.dart';

@riverpod
List<HajjDayModel> hajjDays(
  Ref ref,
  String hajjType, {
  required AppLocalizations l10n,
}) {
  final repository = ref.watch(instructionsRepositoryProvider);
  return repository.getHajjDays(hajjType, l10n);
}
