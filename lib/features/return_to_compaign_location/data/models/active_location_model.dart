class ActiveLocationModel {
  final double latitude;
  final double longitude;

  ActiveLocationModel({required this.latitude, required this.longitude});

  factory ActiveLocationModel.fromJson(Map<String, dynamic> json) {
    return ActiveLocationModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'latitude': latitude, 'longitude': longitude};
  }
}
