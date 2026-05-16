class CampaignInfoModel {
  final String campaignName;
  final int hajjYear;
  final DateTime departureDate;
  final DateTime returnDate;
  final int totalGroups;
  final int totalPilgrims;
  final int totalSupervisors;

  CampaignInfoModel({
    required this.campaignName,
    required this.hajjYear,
    required this.departureDate,
    required this.returnDate,
    required this.totalGroups,
    required this.totalPilgrims,
    required this.totalSupervisors,
  });

  factory CampaignInfoModel.fromJson(Map<String, dynamic> json) {
    return CampaignInfoModel(
      campaignName: json['campaignName']?.toString() ?? '—',
      hajjYear: json['hajjYear'] as int? ?? 0,
      departureDate: DateTime.parse(json['departureDate'].toString()),
      returnDate: DateTime.parse(json['returnDate'].toString()),
      totalGroups: json['totalGroups'] as int? ?? 0,
      totalPilgrims: json['totalPilgrims'] as int? ?? 0,
      totalSupervisors: json['totalSupervisors'] as int? ?? 0,
    );
  }
}
