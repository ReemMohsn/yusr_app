/// Data model for a single Hajj type card shown on the Instructions screen.
/// Intentionally kept free of any Flutter/UI dependencies.
class InstructionModel {
  final String title;
  final String subtitle;
  final String description;

  const InstructionModel({
    required this.title,
    required this.subtitle,
    required this.description,
  });

  factory InstructionModel.fromJson(Map<String, dynamic> json) {
    return InstructionModel(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'subtitle': subtitle,
    'description': description,
  };
}
