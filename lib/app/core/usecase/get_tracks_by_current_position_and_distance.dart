import 'package:tracker_box/app/core/entities/coordinate_entity.dart';
import 'package:tracker_box/app/core/entities/track_entity.dart';

abstract class GetTracksByCurrentPositionAndDistanceUsecase {
  Future<List<TrackEntity>> call(CoordinateEntity coordinateEntity, int radiusDistance);
}
