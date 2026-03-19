import 'dart:convert';
import 'package:yusr/core/config/generated/l10n.dart';
import 'package:yusr/features/instructions/data/models/instruction_model.dart';

class InstructionsRepository {
  List<InstructionModel> getInstructions(AppLocalizations l10n) {
    final String jsonString = l10n.instructionsListData;

    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded
          .map((e) => InstructionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
