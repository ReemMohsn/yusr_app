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
      fullName: json['fullName'] as String? ?? 'غير متوفر',
      jobTitle: json['jobTitle'] ?? 'غير متوفر',
      officialEmail: json['officialEmail'] as String? ?? 'غير متوفر',
      gender: json['gender'] as String? ?? 'غير متوفر',
      dateOfBirth: json['dateOfBirth'] as String? ?? 'غير متوفر',
      healthStatus: json['healthStatus'] as String? ?? 'غير متوفر',
      placeResidence: json['placeResidence'] as String? ?? 'غير متوفر',
      healthDescription: json['healthDescription'] ?? 'غير متوفر',
      yemeniNumber: (json['yemeniNumber'] as String?)?.isNotEmpty == true
          ? json['yemeniNumber'] as String
          : 'غير متوفر',
      saudiNumber: (json['saudiNumber'] as String?)?.isNotEmpty == true
          ? json['saudiNumber'] as String
          : 'غير متوفر',
      whatsappNumber: json['whatsappNumber'] as String? ?? 'غير متوفر',
      relativeName: json['relativeName'] ?? 'غير متوفر',
      relationshipType: json['relationshipType'] ?? 'غير متوفر',
      relativePhoneNumber: json['relativePhoneNumber'] as String? ?? 'غير متوفر',
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

class UpdateProfileDto {
  final String firstName;
  final String fatherName;
  final String grandfatherName;
  final String lastName;
  final String email;
  final String yemeniContactNumber;
  final String saudiContactNumber;
  final String whatsAppContactNumber;
  final String familyContactNumber;
  final bool isActive;

  UpdateProfileDto({
    required this.firstName,
    required this.fatherName,
    required this.grandfatherName,
    required this.lastName,
    required this.email,
    required this.yemeniContactNumber,
    required this.saudiContactNumber,
    required this.whatsAppContactNumber,
    required this.familyContactNumber,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'FirstName': firstName,
      'FatherName': fatherName,
      'GrandfatherName': grandfatherName,
      'LastName': lastName,
      'Email': email,
      'YemeniContactNumber': yemeniContactNumber,
      'SaudiContactNumber': saudiContactNumber,
      'WhatsAppContactNumber': whatsAppContactNumber,
      'FamilyContactNumber': familyContactNumber,
      'IsActive': isActive,
    };
  }
}
