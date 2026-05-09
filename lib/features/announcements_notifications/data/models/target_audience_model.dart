class TargetAudienceModel {
  final int targetAudienceId;
  final String targetAudienceName;

  TargetAudienceModel({
    required this.targetAudienceId,
    required this.targetAudienceName,
  });

  factory TargetAudienceModel.fromJson(Map<String, dynamic> json) {
    return TargetAudienceModel(
      targetAudienceId: json['targetAudienceId'],
      targetAudienceName: json['targetAudienceName'],
    );
  }
}
