class ActivityModel {
  final int? id;
  final double latitude;
  final double longitude;
  final String? imageUrl;
  final DateTime timestamp;

  ActivityModel({
    this.id,
    required this.latitude,
    required this.longitude,
    this.imageUrl,
    required this.timestamp,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) => ActivityModel(
    id: json['id'],
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
    imageUrl: json['image_url'],
    timestamp: DateTime.parse(json['timestamp']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'latitude': latitude,
    'longitude': longitude,
    'image_url': imageUrl,
    'timestamp': timestamp.toIso8601String(),
  };
}
