enum SectionType { text, dua, warning }

class ActionSectionModel {
  final String title;
  final List<String> items;
  final SectionType type;

  const ActionSectionModel({
    required this.title,
    required this.items,
    this.type = SectionType.text,
  });

  factory ActionSectionModel.fromJson(Map<String, dynamic> json) {
    return ActionSectionModel(
      title: json['title'] as String,
      items: List<String>.from(json['items'] as List),
      type: SectionType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => SectionType.text,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'items': items,
        'type': type.toString().split('.').last,
      };
}

class HajjActionModel {
  final String name;
  final String emoji;
  final List<ActionSectionModel> sections;

  const HajjActionModel({
    required this.name,
    required this.emoji,
    required this.sections,
  });

  factory HajjActionModel.fromJson(Map<String, dynamic> json) {
    return HajjActionModel(
      name: json['name'] as String,
      emoji: json['emoji'] as String,
      sections: (json['sections'] as List)
          .map((e) => ActionSectionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'emoji': emoji,
        'sections': sections.map((e) => e.toJson()).toList(),
      };
}

class HajjDayModel {
  final String title;
  final String subtitle;
  final List<HajjActionModel> actions;

  const HajjDayModel({
    required this.title,
    required this.subtitle,
    required this.actions,
  });

  factory HajjDayModel.fromJson(Map<String, dynamic> json) {
    return HajjDayModel(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      actions: (json['actions'] as List)
          .map((e) => HajjActionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'subtitle': subtitle,
        'actions': actions.map((e) => e.toJson()).toList(),
      };
}
