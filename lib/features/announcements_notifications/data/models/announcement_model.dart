class AnnouncementModel {
  late int announcementId;
  late String title;
  late String body;
  late String sentAtTime;
  late String sentAtDate;
  late String targetAudienceName;

  AnnouncementModel({
    required this.announcementId,
    required this.title,
    required this.body,
    required this.sentAtTime,
    required this.sentAtDate,
    required this.targetAudienceName,
  });

  AnnouncementModel.fromJson(Map<String, dynamic> json) {
    announcementId = json['announcementId'];
    title = json['title'];
    body = json['body'];
    sentAtTime = json['sentAtTime'];
    sentAtDate = json['sentAtDate'];
    targetAudienceName = json['targetAudienceName'];
  }

  Map<String, dynamic> toJson() {
    return {
      'announcementId': announcementId,
      'title': title,
      'body': body,
      'sentAtTime': sentAtTime,
      'sentAtDate': sentAtDate,
      'targetAudienceName': targetAudienceName,
    };
  }
}
