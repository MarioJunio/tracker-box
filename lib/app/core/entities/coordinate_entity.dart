import 'dart:convert';

class CoordinateEntity {
  double? latitude;
  double? longitude;
  
  CoordinateEntity({
    this.latitude,
    this.longitude,
  });

  CoordinateEntity copyWith({
    double? latitude,
    double? longitude,
  }) {
    return CoordinateEntity(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  Map<String, dynamic> toLocalDatabaseMap(int id, int trackId) {
    return {
      'id': id,
      'trackId': trackId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory CoordinateEntity.fromMap(Map<String, dynamic> map) {
    return CoordinateEntity(
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory CoordinateEntity.fromJson(String source) =>
      CoordinateEntity.fromMap(json.decode(source));

  @override
  String toString() =>
      'CoordinateEntity(latitude: $latitude, longitude: $longitude)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CoordinateEntity &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}
