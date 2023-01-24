import 'package:flutter_modular/flutter_modular.dart';
import 'package:tracker_box/app/core/entities/coordinate_entity.dart';
import 'package:tracker_box/app/core/entities/track_entity.dart';
import 'package:tracker_box/app/core/exception/publish_track_exception.dart';
import 'package:tracker_box/app/core/repository/track_repository.dart';
import 'package:tracker_box/app/shared/configs/http_client.dart';

final $TrackRepositoryImpl = BindInject(
  (i) => TrackRepositoryImpl(i.get()),
  isSingleton: true,
  isLazy: true,
);

class TrackRepositoryImpl implements TrackRepository {
  final HttpClient httpClient;

  TrackRepositoryImpl(this.httpClient);

  @override
  Future<TrackEntity> publish(TrackEntity track) async {
    final response = await httpClient.post('/tracks', data: track.toJson());

    if (response.statusCode == 201) {
      return TrackEntity.fromMap(response.data);
    }

    throw PublishTrackException(response.data);
  }

  @override
  Future<List<TrackEntity>> filterByPosition(
      CoordinateEntity coordinate, int radiusDistance) async {
    final response =
        await httpClient.get('/tracks/by-distance', queryParameters: {
      'currentCoordinate.latitude': coordinate.latitude,
      'currentCoordinate.longitude': coordinate.longitude,
      'maxDistance': radiusDistance,
    });

    if (response.statusCode == 200) {
      return (response.data as List)
          .map((track) => TrackEntity.fromMap(track))
          .toList();
    }

    return Future.value([]);
  }
}
