class CampaignPilgrimDetailsModel {
  final String fullName;
  final String groupName;
  final String supervisorName;
  final String saudiNumber;
  final String yemeniNumber;
  final String whatsappNumber;
  final String familyNumber;

  CampaignPilgrimDetailsModel({
    required this.fullName,
    required this.groupName,
    required this.supervisorName,
    required this.saudiNumber,
    required this.yemeniNumber,
    required this.whatsappNumber,
    required this.familyNumber,
  });

  factory CampaignPilgrimDetailsModel.fromJson(Map<String, dynamic> json) {
    return CampaignPilgrimDetailsModel(
      fullName: json['fullName']?.toString() ?? '—',
      groupName: json['groupName']?.toString() ?? '—',
      supervisorName: json['supervisorName']?.toString() ?? '—',
      saudiNumber: json['saudiNumber']?.toString() ?? '—',
      yemeniNumber: json['yemeniNumber']?.toString() ?? '—',
      whatsappNumber: json['whatsappNumber']?.toString() ?? '—',
      familyNumber: json['familyNumber']?.toString() ?? '—',
    );
  }
}
