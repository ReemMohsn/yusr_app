class NotificationModel {
  late int notificationId;
  late String title;
  late String body;
  late String sentAtTime;
  late String sentAtDate;
  late String senderName;

  NotificationModel({
    required this.notificationId,
    required this.title,
    required this.body,
    required this.sentAtTime,
    required this.sentAtDate,
    required this.senderName,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    notificationId = json['notificationId'];
    title = json['title'];
    body = json['body'];
    sentAtTime = json['sentAtTime'];
    sentAtDate = json['sentAtDate'];
    senderName = json['sender'];
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'title': title,
      'body': body,
      'sentAtTime': sentAtTime,
      'sentAtDate': sentAtDate,
      'senderName': senderName,
    };
  }
}
