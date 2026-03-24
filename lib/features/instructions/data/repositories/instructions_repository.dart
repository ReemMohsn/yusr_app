import 'dart:convert';
import 'package:yusr/core/config/generated/l10n.dart';
import 'package:yusr/features/instructions/data/models/instruction_model.dart';
import 'package:yusr/features/instructions/data/models/hajj_day_model.dart';

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

  List<HajjDayModel> getHajjDays(String type, AppLocalizations l10n) {
    String jsonString = '';

    // Map type to the correct ARB key
    if (type == 'الإفراد' || type == 'Ifrad') {
      jsonString = l10n.hajjIfradData;
    } else if (type == 'القران' || type == 'Qiran') {
      jsonString = l10n.hajjQiranData;
    } else if (type == 'التمتع' || type == 'Tamattu') {
      jsonString = l10n.hajjTamattuData;
    }

    if (jsonString.isEmpty) return [];

    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded
          .map((e) => HajjDayModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
