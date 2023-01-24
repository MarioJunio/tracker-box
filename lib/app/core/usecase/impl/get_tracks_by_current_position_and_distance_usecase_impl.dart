import 'package:flutter_modular/flutter_modular.dart';
import 'package:tracker_box/app/core/entities/coordinate_entity.dart';
import 'package:tracker_box/app/core/entities/track_entity.dart';
import 'package:tracker_box/app/core/repository/track_repository.dart';
import 'package:tracker_box/app/core/usecase/get_tracks_by_current_position_and_distance.dart';

final $GetTracksByCurrentPositionAndDistanceUsecaseImpl = BindInject(
  (i) => GetTracksByCurrentPositionAndDistanceUsecaseImpl(i()),
  isSingleton: true,
  isLazy: true,
);

class GetTracksByCurrentPositionAndDistanceUsecaseImpl implements GetTracksByCurrentPositionAndDistanceUsecase {

  final TrackRepository _trackRepository;

  GetTracksByCurrentPositionAndDistanceUsecaseImpl(this._trackRepository);

  @override
  Future<List<TrackEntity>> call(CoordinateEntity coordinate, int radiusDistance) async {
    return await _trackRepository.filterByPosition(coordinate, radiusDistance);
  }

}
