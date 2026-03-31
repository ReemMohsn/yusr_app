class UserDetailsModel {
  final String fullName;
  final String jobTitle;
  final String officialEmail;
  final String gender;
  final String dateOfBirth;
  final String healthStatus;
  final String placeResidence;
  final String healthDescription;
  final String yemeniNumber;
  final String saudiNumber;
  final String whatsappNumber;
  final String relativeName;
  final String relationshipType;
  final String relativePhoneNumber;

  UserDetailsModel({
    required this.fullName,
    required this.jobTitle,
    required this.officialEmail,
    required this.gender,
    required this.dateOfBirth,
    required this.healthStatus,
    required this.placeResidence,
    required this.healthDescription,
    required this.yemeniNumber,
    required this.saudiNumber,
    required this.whatsappNumber,
    required this.relativeName,
    required this.relationshipType,
    required this.relativePhoneNumber,
  });

  String get age {
    if (dateOfBirth.isEmpty) return '';
    try {
      final parts = dateOfBirth.split('/');
      if (parts.length == 3) {
        final birthYear = int.parse(parts[2]);
        final currentYear = DateTime.now().year;
        return '${currentYear - birthYear}';
      }
    } catch (_) {}
    return '';
  }

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) {
    return UserDetailsModel(
      fullName: json['fullName'] ?? '',
      jobTitle: json['jobTitle'] ?? '',
      officialEmail: json['officialEmail'] ?? '',
      gender: json['gender'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      healthStatus: json['healthStatus'] ?? '',
      placeResidence: json['placeResidence'] ?? '',
      healthDescription: json['healthDescription'] ?? '',
      yemeniNumber: json['yemeniNumber'] ?? '',
      saudiNumber: json['saudiNumber'] ?? '',
      whatsappNumber: json['whatsappNumber'] ?? '',
      relativeName: json['relativeName'] ?? '',
      relationshipType: json['relationshipType'] ?? '',
      relativePhoneNumber: json['relativePhoneNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'jobTitle': jobTitle,
      'officialEmail': officialEmail,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'healthStatus': healthStatus,
      'placeResidence': placeResidence,
      'healthDescription': healthDescription,
      'yemeniNumber': yemeniNumber,
      'saudiNumber': saudiNumber,
      'whatsappNumber': whatsappNumber,
      'relativeName': relativeName,
      'relationshipType': relationshipType,
      'relativePhoneNumber': relativePhoneNumber,
    };
  }
}
