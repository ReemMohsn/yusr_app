// class CampaignLocationItemModel {
//   final int locationId;
//   final String locationName;
//   final String? description; // الحقل الجديد (اختياري لتجنب أخطاء null)
//   final double latitude;
//   final double longitude;
//   final bool isUsed;

//   CampaignLocationItemModel({
//     required this.locationId,
//     required this.locationName,
//     this.description, // أضفناه هنا
//     required this.latitude,
//     required this.longitude,
//     required this.isUsed,
//   });

//   factory CampaignLocationItemModel.fromJson(Map<String, dynamic> json) {
//     return CampaignLocationItemModel(
//       locationId: json['locationId'] ?? json['id'] ?? 0,
//       locationName: json['locationName'] ?? json['name'] ?? '',
//       description: json['description'] ?? '', // قراءة الوصف من السيرفر
//       latitude: (json['latitude'] ?? 0).toDouble(),
//       longitude: (json['longitude'] ?? 0).toDouble(),
//       isUsed: json['isUsed'] ?? false,
//     );
//   }
// }
class CampaignLocationItemModel {
  final int locationId;
  final String locationName;
  final String? description; 
  final double latitude;
  final double longitude;
  final bool isUsed;

  CampaignLocationItemModel({
    required this.locationId,
    required this.locationName,
    this.description,
    required this.latitude,
    required this.longitude,
    required this.isUsed,
  });

  factory CampaignLocationItemModel.fromJson(Map<String, dynamic> json) {
    return CampaignLocationItemModel(
      // استخدام ?? لضمان عدم حدوث كراش في حال كان الحقل null من السيرفر
      locationId: json['locationId'] ?? json['id'] ?? 0,
      locationName: json['locationName'] ?? json['name'] ?? '',
      description: json['description'], // تركه كـ String? ليقبل null أو قيمة
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      isUsed: json['isUsed'] ?? false,
    );
  }
}