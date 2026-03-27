class UserDetailsModel {
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

  UserDetailsModel({
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

  String get fullName => '$firstName $fatherName $grandfatherName $lastName'.trim();

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) {
    return UserDetailsModel(
      firstName: json['firstName'] ?? '',
      fatherName: json['fatherName'] ?? '',
      grandfatherName: json['grandfatherName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      yemeniContactNumber: json['yemeniContactNumber'] ?? '',
      saudiContactNumber: json['saudiContactNumber'] ?? '',
      whatsAppContactNumber: json['whatsAppContactNumber'] ?? '',
      familyContactNumber: json['familyContactNumber'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'fatherName': fatherName,
      'grandfatherName': grandfatherName,
      'lastName': lastName,
      'email': email,
      'yemeniContactNumber': yemeniContactNumber,
      'saudiContactNumber': saudiContactNumber,
      'whatsAppContactNumber': whatsAppContactNumber,
      'familyContactNumber': familyContactNumber,
      'isActive': isActive,
    };
  }
}
