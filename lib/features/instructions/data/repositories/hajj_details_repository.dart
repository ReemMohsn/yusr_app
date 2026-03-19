import 'dart:convert';
import 'package:yusr/core/config/generated/l10n.dart';
import 'package:yusr/features/instructions/data/models/hajj_details_models.dart';

class HajjDetailsRepository {
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
