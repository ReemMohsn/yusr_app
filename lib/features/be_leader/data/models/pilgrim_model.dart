enum PilgrimStatus { accepted, pending, rejected }

class PilgrimModel {
  final int hajjRegistrationId;
  final String pilgrimName;
  final String statusName;
  final int statusId;
  PilgrimModel({
    required this.hajjRegistrationId,
    required this.pilgrimName,
    required this.statusName,
    required this.statusId,
  });

  factory PilgrimModel.fromJson(Map<String, dynamic> json) {
    return PilgrimModel(
      hajjRegistrationId: json['hajjRegistrationId'] ?? 0,
      pilgrimName: json['pilgrimName'] ?? 'بدون اسم',
      statusId: json['statusId'] ?? 0,
      statusName: json['statusName'] ?? '',
    );
  }
}
