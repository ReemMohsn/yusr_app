class CampaignGroupDetailsModel {
  final int groupId;
  final String groupName;
  final String supervisorName;
  final String supervisorSaudiNumber;
  final String supervisorYemeniNumber;
  final String supervisorWhatsappNumber;
  final String supervisorFamilyNumber;
  final List<CampaignGroupPilgrimModel> pilgrims;

  CampaignGroupDetailsModel({
    required this.groupId,
    required this.groupName,
    required this.supervisorName,
    required this.supervisorSaudiNumber,
    required this.supervisorYemeniNumber,
    required this.supervisorWhatsappNumber,
    required this.supervisorFamilyNumber,
    required this.pilgrims,
  });

  factory CampaignGroupDetailsModel.fromJson(Map<String, dynamic> json) {
    return CampaignGroupDetailsModel(
      groupId: json['groupId'] as int? ?? 0,
      groupName: json['groupName']?.toString() ?? '—',
      supervisorName: json['supervisorName']?.toString() ?? '—',
      supervisorSaudiNumber: json['supervisorSaudiNumber']?.toString() ?? '—',
      supervisorYemeniNumber: json['supervisorYemeniNumber']?.toString() ?? '—',
      supervisorWhatsappNumber: json['supervisorWhatsappNumber']?.toString() ?? '—',
      supervisorFamilyNumber: json['supervisorFamilyNumber']?.toString() ?? '—',
      pilgrims: (json['pilgrims'] as List<dynamic>?)
              ?.map((e) => CampaignGroupPilgrimModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class CampaignGroupPilgrimModel {
  final int userId;
  final String fullName;
  final bool isHealthStable;

  CampaignGroupPilgrimModel({
    required this.userId,
    required this.fullName,
    required this.isHealthStable,
  });

  factory CampaignGroupPilgrimModel.fromJson(Map<String, dynamic> json) {
    return CampaignGroupPilgrimModel(
      userId: json['userId'] as int? ?? 0,
      fullName: json['fullName']?.toString() ?? '—',
      isHealthStable: json['isHealthStable'] as bool? ?? true,
    );
  }
}
