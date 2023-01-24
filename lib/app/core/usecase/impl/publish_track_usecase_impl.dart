import 'package:flutter_modular/flutter_modular.dart';
import 'package:tracker_box/app/core/entities/track_entity.dart';
import 'package:tracker_box/app/core/repository/track_repository.dart';
import 'package:tracker_box/app/core/usecase/publish_track_usecase.dart';

final $PublishTrackUsecaseImpl = BindInject(
  (i) => PublishTrackUsecaseImpl(i()),
  isSingleton: true,
  isLazy: true,
);

class PublishTrackUsecaseImpl implements PublishTrackUsecase {
  final TrackRepository _trackRepository;

  PublishTrackUsecaseImpl(this._trackRepository);

  @override
  Future<TrackEntity> call(TrackEntity track) async {
      return await _trackRepository.publish(track);
  }
}
