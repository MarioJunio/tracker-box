import 'package:mobx/mobx.dart';
import 'package:tracker_box/app/core/geolocator/trackerLocator.dart';
import 'package:tracker_box/app/core/model/coordinate.dart';

part 'track.g.dart';

class Track = _TrackBase with _$Track;

abstract class _TrackBase with Store {
  int id;

  @observable
  int speed = 0;

  @observable
  double distance = 0;

  @observable
  double distanceIntegral = 0;

  @observable
  double accuracy = 0;

  @observable
  int timer = 0;

  List<Coordinate> coordinates = new List();

  @observable
  bool inProgress = false;

  @action
  setSpeed(int speed) {
    this.speed = speed;
  }

  @action
  setDistance(double distance) {
    this.distance = distance;
  }

  @action
  setTimer(int timer) {
    this.timer = timer;
  }

  @action
  setInProgress(bool inProgress) {
    this.inProgress = inProgress;
  }

  @action
  calculateDistance() async {
    // se possuir ao menos 2 coordenadas registradas
    // a distancia poderia calculada para ser acumulada
    if (coordinates.length > 1) {
      final int length = coordinates.length;
      final double distanceBetween = await TrackerLocator.distanceBetween(
          coordinates[length - 2], coordinates[length - 1]);

      if (_canAcumulateDistance(distanceBetween))
        this.distance += distanceBetween > 0 ? distanceBetween : 0;
    }
  }

  @action
  calculateDistanceIntegral() async {
    this.distanceIntegral = 0;

    if (this.coordinates.length > 1) {
      for (int i = 1; i < this.coordinates.length; i++) {
        final distanceBetween = await TrackerLocator.distanceBetween(
            this.coordinates[i - 1], this.coordinates[i]);

        if (_canAcumulateDistance(distanceBetween))
          this.distanceIntegral += distanceBetween;
      }
    }
  }

  bool _canAcumulateDistance(double distanceBetween) =>
      this.speed > 1 && distanceBetween > 1;
}
