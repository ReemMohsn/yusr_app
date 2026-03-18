class CampaignLocationItemModel {
  final int locationId;
  final String locationName;
  final double latitude;
  final double longitude;
  final bool isUsed; // تأكدي من إضافة هذا السطر

  CampaignLocationItemModel({
    required this.locationId,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.isUsed, // وتأكدي من إضافته هنا أيضاً
  });

  factory CampaignLocationItemModel.fromJson(Map<String, dynamic> json) {
    return CampaignLocationItemModel(
      // استخدمي id أو locationId لضمان عدم وصول القيمة 0
      locationId: json['locationId'] ?? json['id'] ?? 0, 
      locationName: json['locationName'] ?? json['name'] ?? '',
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