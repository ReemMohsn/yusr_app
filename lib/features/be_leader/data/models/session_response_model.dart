class SessionResponseModel {
  final int sessionId;

  SessionResponseModel({required this.sessionId});

  factory SessionResponseModel.fromJson(Map<String, dynamic> json) {
    return SessionResponseModel(sessionId: json['sessionId']);
  }
}
