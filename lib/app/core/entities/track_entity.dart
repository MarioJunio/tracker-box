import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:tracker_box/app/core/entities/coordinate_entity.dart';
import 'package:tracker_box/app/core/entities/user_entity.dart';

class TrackEntity {
  final String? id;
  final String? checkSum;
  final int? localId;
  final int? startSpeed;
  final int? maxSpeed;
  final double? distance;
  final int? time;
  final List<CoordinateEntity>? coordinates;
  final UserEntity? user;

  final CoordinateEntity? startCoordinate;
  final CoordinateEntity? endCoordinate;

  Uint8List? icon;

  TrackEntity({
    this.id,
    this.checkSum,
    this.localId,
    this.startSpeed,
    this.maxSpeed,
    this.distance,
    this.time,
    this.coordinates,
    this.user,
    this.startCoordinate,
    this.endCoordinate,
  });

  TrackEntity copyWith({
    String? id,
    int? localId,
    String? checkSum,
    int? startSpeed,
    int? maxSpeed,
    double? distance,
    int? time,
    List<CoordinateEntity>? coordinates,
    UserEntity? user,
  }) {
    return TrackEntity(
      id: id ?? this.id,
      localId: localId ?? this.localId,
      checkSum: checkSum ?? this.checkSum,
      startSpeed: startSpeed ?? this.startSpeed,
      maxSpeed: maxSpeed ?? this.maxSpeed,
      distance: distance ?? this.distance,
      time: time ?? this.time,
      coordinates: coordinates ?? this.coordinates,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startSpeed': startSpeed,
      'checkSum': checkSum,
      'maxSpeed': maxSpeed,
      'distance': distance,
      'time': time,
      'coordinates': coordinates?.map((x) => x.toMap()).toList(),
      'user': user?.toMap(),
      'userId': user?.id,
    };
  }

  Map<String, dynamic> toLocalDatabaseMap() {
    return {
      'checkSum': checkSum,
      'localId': localId,
      'startSpeed': startSpeed,
      'maxSpeed': maxSpeed,
      'distance': distance,
      'time': time,
      'userId': user?.id,
    };
  }

  factory TrackEntity.fromLocalDatabaseMap(Map<String, dynamic> map) {
    return TrackEntity(
      localId: map['localId'],
      checkSum: map['checkSum'],
      startSpeed: map['startSpeed'],
      maxSpeed: map['maxSpeed'],
      distance: map['distance'],
      time: map['time'],
      user: map['userId'] != null ? UserEntity(id: map['userId']) : null,
    );
  }

  factory TrackEntity.fromMap(Map<String, dynamic> map) {
    return TrackEntity(
      id: map['id'],
      checkSum: map['checkSum'],
      startCoordinate: CoordinateEntity(
        latitude: map['startCoordinate']['x'],
        longitude: map['startCoordinate']['y'],
      ),
      endCoordinate: CoordinateEntity(
        latitude: map['endCoordinate']['x'],
        longitude: map['endCoordinate']['y'],
      ),
      startSpeed: map['startSpeed']?.toInt(),
      maxSpeed: map['maxSpeed']?.toInt(),
      distance: map['distance']?.toDouble(),
      time: map['time']?.toInt(),
      coordinates: map['coordinates'] != null
          ? List<CoordinateEntity>.from(
              map['coordinates']?.map((x) => CoordinateEntity.fromMap(x)))
          : null,
      user: map['user'] != null ? UserEntity.fromMap(map['user']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TrackEntity.fromJson(String source) =>
      TrackEntity.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TrackEntity(id: $id, checkSum: $checkSum, startSpeed: $startSpeed, maxSpeed: $maxSpeed, distance: $distance, time: $time, coordinates: $coordinates, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TrackEntity &&
        other.id == id &&
        other.checkSum == checkSum &&
        other.startSpeed == startSpeed &&
        other.maxSpeed == maxSpeed &&
        other.distance == distance &&
        other.time == time &&
        listEquals(other.coordinates, coordinates) &&
        other.user == user;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        checkSum.hashCode ^
        startSpeed.hashCode ^
        maxSpeed.hashCode ^
        distance.hashCode ^
        time.hashCode ^
        coordinates.hashCode ^
        user.hashCode;
  }
}
