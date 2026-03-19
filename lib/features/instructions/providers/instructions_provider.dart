import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/core/config/generated/l10n.dart';
import 'package:yusr/features/instructions/data/models/instruction_model.dart';
import 'package:yusr/features/instructions/data/repositories/instructions_repository.dart';

part 'instructions_provider.g.dart';

@riverpod
InstructionsRepository instructionsRepository(Ref ref) {
  return InstructionsRepository();
}

@riverpod
List<InstructionModel> instructions(Ref ref, {required AppLocalizations l10n}) {
  final repository = ref.watch(instructionsRepositoryProvider);
  return repository.getInstructions(l10n);
}
