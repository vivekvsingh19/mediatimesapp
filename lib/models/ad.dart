class AdModel {
  final String id;
  final String name;
  final String position;
  final String? desktopImageUrl;
  final String? mobileImageUrl;
  final String? destinationUrl;
  final bool active;

  AdModel({
    required this.id,
    required this.name,
    required this.position,
    this.desktopImageUrl,
    this.mobileImageUrl,
    this.destinationUrl,
    required this.active,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json['id'],
      name: json['name'],
      position: json['position'],
      desktopImageUrl: json['desktopImageUrl'],
      mobileImageUrl: json['mobileImageUrl'],
      destinationUrl: json['destinationUrl'],
      active: json['active'] ?? true,
    );
  }
}
