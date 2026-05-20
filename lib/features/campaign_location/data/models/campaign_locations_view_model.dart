import 'campaign_location_item_model.dart'; 


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