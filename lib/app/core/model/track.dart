import 'package:mobx/mobx.dart';
import 'package:tracker_box/app/core/location/location.dart';
import 'package:tracker_box/app/core/model/coordinate.dart';
import 'package:tracker_box/app/core/model/trackStatus.dart';
import 'package:tracker_box/app/shared/preferences/appPrefs.dart';
import 'package:tracker_box/app/shared/utils/trackFormatter.dart';

part 'track.g.dart';

class Track = _TrackBase with _$Track;

abstract class _TrackBase with Store {
  late int id;

  @observable
  int startSpeed = 0;

  @observable
  int speed = 0;

  @observable
  double distance = 0;

  @observable
  double accuracy = 0;

  @observable
  int timer = 0;

  List<Coordinate> coordinates = [];

  // transient
  @observable
  double distanceIntegral = 0;

  @observable
  TrackStatus status = TrackStatus.standby;

  bool canStartTimer = true;

  _TrackBase() {
    this.reset();
  }

  @action
  reset() {
    startSpeed = 0;
    speed = 0;
    distance = 0;
    distanceIntegral = 0;
    timer = 0;
    canStartTimer = true;
    coordinates = [];
  }

  @action
  setStartSpeed(int speed) {
    if (this.startSpeed == 0) {
      this.startSpeed = speed;
    }
  }

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
  setTrackStatus(TrackStatus status) {
    this.status = status;
  }

  @action
  calculateDistance() async {
    // se possuir ao menos 2 coordenadas registradas
    // a distancia poderia calculada para ser acumulada
    if (coordinates.length > 1) {
      final int length = coordinates.length;
      final double distanceBetween = ILocation.distanceBetween(
          coordinates[length - 2], coordinates[length - 1]);

      if (_canAcumulateDistance(distanceBetween)) {
        this.distance += distanceBetween;
      }
    }
  }

  /*@action
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
  }*/

  @action
  incrementTimer(int value) => this.timer += value;

  @computed
  String get speedFormatted => TrackFormatter.formatSpeed(speed);

  @computed
  String get timerFormatted => TrackFormatter.formatTimer(timer);

  @computed
  String get timerFormattedWithoutUnit =>
      TrackFormatter.formatTimer(timer, showLabel: false);

  @computed
  String get timerUnit => TrackFormatter.timerUnit(timer);

  @computed
  String get distanceFormatted => TrackFormatter.formatDistance(distance);

  @computed
  String get distanceFormattedWithoutUnit =>
      TrackFormatter.formatDistance(distance, showLabel: false);

  @computed
  String get distanceUnit => TrackFormatter.distanceUnit(distance);

  @computed
  bool get calibrated =>
      this.accuracy < AppPreferences.TRACK_CALIBRATED_ACCURACY_IN_METTERS;

  @computed
  bool get isStandby => status == TrackStatus.standby;

  @computed
  bool get isPrepare => status == TrackStatus.prepare;

  @computed
  bool get isActive => status == TrackStatus.active;

  @computed
  bool get isComplete => status == TrackStatus.complete;

  List<Coordinate> get getTraceBeginAndEndCoordinates =>
      coordinates.isNotEmpty ? [coordinates.first, coordinates.last] : [];

  bool _canAcumulateDistance(double distanceBetween) =>
      this.speed > 1 && distanceBetween > 1;
}
