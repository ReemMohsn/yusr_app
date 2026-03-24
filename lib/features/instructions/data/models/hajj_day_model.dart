import 'hajj_action_model.dart';

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
