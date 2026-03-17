import 'package:flutter/material.dart';

class InstructionModel {
  final String title;
  final String subtitle;
  final String description;
  final List<Color> gradientColors;

  const InstructionModel({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.gradientColors,
  });
}
