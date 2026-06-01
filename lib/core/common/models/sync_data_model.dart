class SyncDataModel {
  final int campaignId;
  final int? groupId;

  SyncDataModel({required this.campaignId, this.groupId});

  factory SyncDataModel.fromJson(Map<String, dynamic> json) {
    return SyncDataModel(
      campaignId: json['campaignId'] ?? json['CampaignId'],
      groupId: json['groupId'] ?? json['GroupId'],
    );
  }
}
