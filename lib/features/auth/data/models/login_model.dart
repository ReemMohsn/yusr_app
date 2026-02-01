class ProfileModel {
  late int userId;
  late String fullName;
  late String token;
  late String userRole;
  late String identifier;

  ProfileModel({
    required this.userId,
    required this.fullName,
    required this.token,
    required this.userRole,
    required this.identifier,
  });

  ProfileModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    fullName = json['fullName'];
    userRole = json['role'];
    token = json['token'];
    identifier = json['identifier'];
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'role': userRole,
      'token': token,
      'identifier': identifier,
    };
  }
}
