import 'package:tracker_box/app/core/entities/coordinate_entity.dart';
import 'package:tracker_box/app/core/entities/track_entity.dart';

abstract class TrackRepository {
  Future<TrackEntity> publish(TrackEntity track);

  Future<List<TrackEntity>> filterByPosition(CoordinateEntity coordinate, int radiusDistance);
}