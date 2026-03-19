class CampaignLocationItemModel {
  final int locationId;
  final String locationName;
  final String? description; // الحقل الجديد (اختياري لتجنب أخطاء null)
  final double latitude;
  final double longitude;
  final bool isUsed;

  CampaignLocationItemModel({
    required this.locationId,
    required this.locationName,
    this.description, // أضفناه هنا
    required this.latitude,
    required this.longitude,
    required this.isUsed,
  });

  factory CampaignLocationItemModel.fromJson(Map<String, dynamic> json) {
    return CampaignLocationItemModel(
      locationId: json['locationId'] ?? json['id'] ?? 0,
      locationName: json['locationName'] ?? json['name'] ?? '',
      description: json['description'] ?? '', // قراءة الوصف من السيرفر
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      isUsed: json['isUsed'] ?? false,
    );
  }
}
// أضيفي هذا الكلاس هنا (ضروري جداً لحل خطأ الـ Repository)
class CampaignLocationsViewModel {
  final CampaignLocationItemModel? currentLocation;
  final List<CampaignLocationItemModel> previousLocations;

  CampaignLocationsViewModel({
    required this.currentLocation,
    required this.previousLocations,
  });

  factory CampaignLocationsViewModel.fromJson(Map<String, dynamic> json) {
    return CampaignLocationsViewModel(
      currentLocation: json['currentLocation'] != null 
          ? CampaignLocationItemModel.fromJson(json['currentLocation']) 
          : null,
      previousLocations: (json['previousLocations'] as List?)
              ?.map((e) => CampaignLocationItemModel.fromJson(e))
              .toList() ?? [],
    );
  }
}