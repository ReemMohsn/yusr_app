class CampaignGroupModel {
  final int groupId;
  final String groupName;
  final String supervisorName;
  final int pilgrimsCount;

  CampaignGroupModel({
    required this.groupId,
    required this.groupName,
    required this.supervisorName,
    required this.pilgrimsCount,
  });

  factory CampaignGroupModel.fromJson(Map<String, dynamic> json) {
    return CampaignGroupModel(
      groupId: json['groupId'] as int? ?? 0,
      groupName: json['groupName']?.toString() ?? '—',
      supervisorName: json['supervisorName']?.toString() ?? '—',
      pilgrimsCount: json['pilgrimsCount'] as int? ?? 0,
    );
  }
}
