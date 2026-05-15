import 'dart:convert';

enum TrackingNotificationType {
  sessionInvite, // دعوة جلسة للحاج
  pilgrimWarning, // 🟡 تحذير ابتعاد (للحاج)
  pilgrimEmergency, // 🚨 إنذار خطر (للحاج)
  leaderWarning, // 🟡 تنبيه تأخر حاج (للمشرف)
  leaderEmergency, // 🚨 خطر: حاج مفقود (للمشرف)
  statusChange, // تغير حالة حاج (للمشرف)
}

class TrackingNotificationModel {
  final String id; // "local_1", "local_1001", "session_123", "status_pilgrimId_ts"
  final String title;
  final String body;
  final String timestamp; // ISO 8601
  final TrackingNotificationType type;
  final int? sessionId;
  final String? pilgrimName;

  TrackingNotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.type,
    this.sessionId,
    this.pilgrimName,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'timestamp': timestamp,
    'type': type.name,
    'sessionId': sessionId,
    'pilgrimName': pilgrimName,
  };

  factory TrackingNotificationModel.fromJson(Map<String, dynamic> json) {
    return TrackingNotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      timestamp: json['timestamp'] as String,
      type: TrackingNotificationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TrackingNotificationType.statusChange,
      ),
      sessionId: json['sessionId'] as int?,
      pilgrimName: json['pilgrimName'] as String?,
    );
  }

  static List<TrackingNotificationModel> listFromJson(String jsonStr) {
    final list = jsonDecode(jsonStr) as List;
    return list
        .map((e) => TrackingNotificationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static String listToJson(List<TrackingNotificationModel> list) {
    return jsonEncode(list.map((e) => e.toJson()).toList());
  }
}
