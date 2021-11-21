import 'package:tracker_box/app/core/entities/user_entity.dart';
import 'package:tracker_box/app/core/entities/coordinate_entity.dart';

class TrackEntity {
  final int? id;
  final int? startSpeed;
  final int? maxSpeed;
  final double? distance;
  final int? time;
  final List<CoordinateEntity>? coordinates;
  final UserEntity? user;

  TrackEntity(
      {this.id,
      this.startSpeed,
      this.maxSpeed,
      this.distance,
      this.time,
      this.coordinates,
      this.user});
}
