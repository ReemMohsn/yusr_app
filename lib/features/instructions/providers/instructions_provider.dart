import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yusr/features/instructions/data/models/instruction_model.dart';
import 'package:yusr/features/instructions/data/repositories/instructions_repository.dart';

part 'instructions_provider.g.dart';

@riverpod
List<InstructionModel> instructions(Ref ref) {
  return InstructionsRepository().getInstructions();
}
