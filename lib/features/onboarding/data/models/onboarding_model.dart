import 'package:flutter/material.dart';
import 'package:yusr/core/config/generated/l10n.dart';

class OnboardingModel {
  final IconData icon;
  final String Function(AppLocalizations) titleBuilder;
  final String Function(AppLocalizations) descriptionBuilder;

  const OnboardingModel({
    required this.icon,
    required this.titleBuilder,
    required this.descriptionBuilder,
  });
}