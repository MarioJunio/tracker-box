import 'package:geolocator/geolocator.dart';
import 'package:mobx/mobx.dart';
import 'package:tracker_box/app/core/geolocator/trackerLocator.dart';
import 'package:tracker_box/app/core/model/coordinate.dart';
import 'package:tracker_box/app/core/model/launch.dart';
import 'package:tracker_box/app/core/model/launchType.dart';
import 'package:tracker_box/app/core/model/track.dart';

part 'track_controller.g.dart';

class TrackController = _TrackControllerBase with _$TrackController;

abstract class _TrackControllerBase with Store {
  final TrackerLocator trackerLocator = new TrackerLocator();

  @observable
  Launch launch;

  @observable
  Track track = new Track();

  @observable
  bool active = false;

  _TrackControllerBase() {
    resetLaunch(LaunchType.km_h);
  }

  resetLaunch(LaunchType type) {
    launch = new Launch();
    launch.type = type;
  }

  @action
  toggleTracker() {
    _refresh();

    // inicia a track caso esteja parada
    // caso contrario pare o launch atual
    if (!track.inProgress)
      this._startTracking();
    else
      this._stopTracking();
  }

  @action
  setActive(bool active) {
    this.active = active;
  }

  @action
  _startTracking() {
    // reinicia o track
    track = new Track();

    // inicia listener para obter a posição mais atual
    trackerLocator
        .listenForPosition(_listenForPosition)
        .then((value) => _refresh());
  }

  @action
  void _stopTracking() {
    // pausa o listener de posições
    trackerLocator.pauseListenForPosition();

    _refresh();
  }

  @action
  _listenForPosition(Position position) {

    track.accuracy = position.accuracy;

    if (position.accuracy <= 15) {

      // converte velocidade de m/s -> km/h
      final int tmpSpeed = (position.speed * 3.6).truncate();

      // calcula distancia
      track.coordinates.add(new Coordinate(
        latitude: position.latitude,
        longitude: position.longitude,
      ));

      track.calculateDistance();
      track.calculateDistanceIntegral();

      // não aceita velocidade negativa, acontece se inicia o GPS
      track.setSpeed(tmpSpeed < 0 ? 0 : tmpSpeed);
    }
  }

  _refresh() {
    track.setInProgress(!trackerLocator.isPaused);
  }
}
