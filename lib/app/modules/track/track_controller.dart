import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:mobx/mobx.dart';
import 'package:tracker_box/app/core/geolocator/trackerLocator.dart';
import 'package:tracker_box/app/core/location/location.dart';
import 'package:tracker_box/app/core/model/coordinate.dart';
import 'package:tracker_box/app/core/model/launch.dart';
import 'package:tracker_box/app/core/model/launchType.dart';
import 'package:tracker_box/app/core/model/track.dart';
import 'package:tracker_box/app/core/model/trackStatus.dart';
import 'package:tracker_box/app/shared/preferences/appPrefs.dart';

part 'track_controller.g.dart';

class TrackController = _TrackControllerBase with _$TrackController;

abstract class _TrackControllerBase with Store {
  final ILocation trackerLocator = new TrackerLocator();

  final TrackerLocator trackerCalibrate = new TrackerLocator();

  Timer _countTimer, _countDownTimer;

  @observable
  Launch launch;

  @observable
  Track track = new Track();

  @observable
  bool active = false;

  @observable
  int prepareCountDown = AppPreferences.TRACK_START_COUNT_DOWN;

  _TrackControllerBase() {
    resetLaunch(LaunchType.speed);

    trackerCalibrate.listenForPosition(_listenForCalibrate);
  }

  resetLaunch(LaunchType type) {
    launch = new Launch();
    launch.selectLaunchType(type);
  }

  @action
  publishTrack() {
    //TODO: salva track no device local ou sincroniza com a nuvem

    resetLaunch(LaunchType.speed);

    track.reset();
    track.setTrackStatus(TrackStatus.standby);
  }

  @action
  discartTrack() {
    resetLaunch(LaunchType.speed);

    track.reset();
    track.setTrackStatus(TrackStatus.standby);
  }

  @action
  toggleTracker() {
    if (track.isStandby)
      _prepareTracking();
    else if (track.isPrepare)
      _cancelTracking();
    else if (track.isActive) _stopTracking();
  }

  @action
  setActive(bool active) {
    this.active = active;
  }

  @action
  _prepareTracking() {
    track.setTrackStatus(TrackStatus.prepare);

    prepareCountDown = AppPreferences.TRACK_START_COUNT_DOWN;

    // inicia contador regressivo
    _countDownTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      prepareCountDown -= 1;

      // quando atingir a contagem 0, inicie o tracking
      if (prepareCountDown <= 1) {
        timer.cancel();

        await Future.delayed(Duration(milliseconds: 1000));

        _startTracking();
      }
    });
  }

  @action
  _startTracking() {
    // reinicia a track
    track.reset();

    // inicia listener para obter a posição mais atual
    trackerLocator.listenForPosition(_listenForPosition).then((value) {
      if (value) {
        track.setTrackStatus(TrackStatus.active);
      } else {
        //TODO: Exibir mensagem indicando que não poderá iniciar o tracking
        print("=> Track não inciado!");
      }
    });
  }

  @action
  _stopTracking() {
    // pausa o listener de posições
    trackerLocator.cancelListener();

    // para o temporizador
    _stopTimer();

    track.setTrackStatus(TrackStatus.complete);
  }

  @action
  _cancelTracking() {
    _countDownTimer?.cancel();

    track.setTrackStatus(TrackStatus.standby);
  }

  @action
  _listenForPosition(Position position) {
    // precisão em metros para calibragem
    track.accuracy = position.accuracy;

    // converte velocidade de m/s -> km/h
    final int tmpSpeed = (position.speed * 3.6).truncate();

    // inicia temporizador da track
    if (track.canStartTimer && tmpSpeed > 0) _startTimer();

    // define velocidade inicial
    track.setStartSpeed(tmpSpeed < 0 ? 0 : tmpSpeed);

    // não aceita velocidade negativa, acontece se inicia o GPS
    track.setSpeed(tmpSpeed < 0 ? 0 : tmpSpeed);

    // calcula distancia
    track.coordinates.add(new Coordinate(
      latitude: position.latitude,
      longitude: position.longitude,
    ));

    track.calculateDistance();

    // checa se atingiu algum limite definido
    _checkStopCondition();
  }

  @action
  _listenForCalibrate(Position position) {
    track.accuracy = position.accuracy;

    // print("Calibrando: ${track.accuracy}");
  }

  _startTimer() {
    track.canStartTimer = false;

    if (!(_countTimer?.isActive ?? false))
      _countTimer = Timer.periodic(
          Duration(milliseconds: AppPreferences.TRACK_TIMER_DELAY_MILLI),
          (timer) {
        track.incrementTimer(AppPreferences.TRACK_TIMER_DELAY_MILLI);

        if (launch.type == LaunchType.time) {
          _timeStopCondition();
        }
      });
  }

  _stopTimer() {
    _countTimer?.cancel();
  }

  _checkStopCondition() async {
    if (launch.type == LaunchType.speed) {
      _speedStopCondition();
    } else if (launch.type == LaunchType.distance) {
      _distanceStopCondition();
    }
  }

  _speedStopCondition() {
    // verifica se alcançou a velocidade defina em km/h
    if (track.speed >= launch.value) {
      track.setSpeed(launch.value);

      _stopTracking();
    }
  }

  _distanceStopCondition() {
    // verifica se alcançou a distancia defina em metros
    if (track.distance >= launch.valueInMeters) {
      track.setDistance(launch.value.toDouble());

      _stopTracking();
    }
  }

  _timeStopCondition() {
    // verifica se alcançou o tempo definido em segundos
    if (track.timer >= launch.valueInMilliseconds) {
      track.setTimer(launch.valueInMilliseconds);

      _stopTracking();
    }
  }
}
