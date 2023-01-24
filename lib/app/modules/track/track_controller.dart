import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:tracker_box/app/core/entities/coordinate_entity.dart';
import 'package:tracker_box/app/core/entities/track_entity.dart';
import 'package:tracker_box/app/core/entities/user_entity.dart';
import 'package:tracker_box/app/core/geolocator/trackerLocator.dart';
import 'package:tracker_box/app/core/model/launch.dart';
import 'package:tracker_box/app/core/model/launchType.dart';
import 'package:tracker_box/app/core/model/track.dart';
import 'package:tracker_box/app/core/model/trackStatus.dart';
import 'package:tracker_box/app/core/usecase/publish_track_usecase.dart';
import 'package:tracker_box/app/modules/track/track_module.dart';
import 'package:tracker_box/app/shared/database/repository/track_local_database_repository.dart';
import 'package:tracker_box/app/shared/preferences/appPrefs.dart';
import 'package:tracker_box/app/shared/utils/internet_utils.dart';

part 'track_controller.g.dart';

final $TrackController = BindInject(
  (i) => TrackController(
    i(),
    i(),
  ),
  isSingleton: true,
  isLazy: true,
);
class TrackController = _TrackControllerBase with _$TrackController;

abstract class _TrackControllerBase with Store {
  final PublishTrackUsecase _publishTrackUsecase;
  final TrackLocalDatabaseRepository _trackLocalDatabaseRepository;
  final TrackerLocator trackerLocator = new TrackerLocator();
  final TrackerLocator trackerCalibrate = new TrackerLocator();
  GoogleMapController? mapController;

  Timer? _countTimer, _countDownTimer;

  @observable
  Launch launch = new Launch();

  @observable
  Track track = new Track();

  @observable
  bool active = false;

  @observable
  int prepareCountDown = AppPreferences.TRACK_START_COUNT_DOWN;

  @observable
  bool errorOnTrackingStart = false;

  bool uploadingTracks = false;

  @action
  setErrorOnTrackingStart(bool errorOnTrackingStart) {
    this.errorOnTrackingStart = errorOnTrackingStart;
  }

  _TrackControllerBase(
      this._publishTrackUsecase, this._trackLocalDatabaseRepository) {
    resetLaunch(LaunchType.speed);

    trackerCalibrate.listenForPosition(_listenForCalibrate);
  }

  resetLaunch(LaunchType type) {
    launch = new Launch();
    launch.selectLaunchType(type);
  }

  // ignore: slash_for_doc_comments
  /**
   * Load saved local tracks and publish
   */
  publishLocalTracks(BuildContext context) async {
    if (uploadingTracks) {
      return;
    }

    try {
      uploadingTracks = true;

      final List<TrackEntity> tracksEntities =
          await _trackLocalDatabaseRepository.getAll(
              userId: '6236840c8195911e1ac2cbb8');

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Offline Tracks: ${tracksEntities.length}"),
      ));

      for (final trackEntity in tracksEntities) {
        try {
          await _publishTrackUsecase(trackEntity);
        } catch (ex) {
          print("Erro ao publicar offline track: $ex");
        } finally {
          await _trackLocalDatabaseRepository.delete(trackEntity.localId!);
        }
      }
    } finally {
      uploadingTracks = false;
    }
  }

  @action
  publishTrack() async {
    TrackEntity trackEntity =
        track.toEntity(UserEntity(id: "6236840c8195911e1ac2cbb8"));

    if (await InternetUtils.hasInternetConnection()) {
      try {
        trackEntity = await _publishTrackUsecase(trackEntity);
      } catch (exception) {
        print('Erro ao publicar track: $exception');
      }
    } else {
      await _trackLocalDatabaseRepository.save(trackEntity);
    }

    resetLaunch(LaunchType.speed);

    track.reset();
    track.setTrackStatus(TrackStatus.standby);

    //TODO: remover campos: arguments
    Modular.to.pushNamed(
      TrackModule.MAP_MODULE_ROUTE,
      arguments: trackEntity.coordinates,
    );
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
    else if (track.isActive) stopTracking();
  }

  @action
  setActive(bool active) {
    this.active = active;
  }

  @computed
  String get getPageTitle {
    switch (track.status) {
      case TrackStatus.complete:
        return "Track finalizado";
      case TrackStatus.prepare:
        return "Preparando seu track...";
      case TrackStatus.active:
        return "Track em progresso...";
      default:
        return "Monte sua track";
    }
  }

  @computed
  bool get trackInProgress => [
        TrackStatus.prepare,
        TrackStatus.active,
        TrackStatus.complete,
      ].contains(track.status);

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
        setErrorOnTrackingStart(true);
        _cancelTracking();
      }
    });
  }

  @action
  stopTracking() {
    track.setTrackStatus(TrackStatus.complete);

    // pausa o listener de posições
    trackerLocator.cancelListener();

    // para o temporizador
    _stopTimer();
  }

  void setGoogleMapController(GoogleMapController googleMapController) {
    this.mapController = googleMapController;
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

    // define velocidade inicial e máxima
    track.refreshSpeedDefinitions();

    // não aceita velocidade negativa, acontece se inicia o GPS
    track.setSpeed(tmpSpeed < 0 ? 0 : tmpSpeed);

    // add coordenada a lista
    track.coordinates.add(new CoordinateEntity(
      latitude: position.latitude,
      longitude: position.longitude,
    ));

    // calcula distancia
    track.calculateDistance();

    // checa se atingiu algum limite definido
    _checkStopCondition();
  }

  @action
  _listenForCalibrate(Position position) {
    // print(position.accuracy);
    track.accuracy = position.accuracy;
  }

  _startTimer() {
    track.canStartTimer = false;

    if (!(_countTimer?.isActive ?? false)) {
      _countTimer = Timer.periodic(
          Duration(milliseconds: AppPreferences.TRACK_TIMER_DELAY_MILLI),
          (timer) {
        track.incrementTimer(AppPreferences.TRACK_TIMER_DELAY_MILLI);

        if (launch.type == LaunchType.time) {
          _timeStopCondition();
        }
      });
    }
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

      stopTracking();
    }
  }

  _distanceStopCondition() {
    // verifica se alcançou a distancia defina em metros
    if (track.distance >= launch.valueInMeters) {
      track.setDistance(launch.value.toDouble());

      stopTracking();
    }
  }

  _timeStopCondition() {
    // verifica se alcançou o tempo definido em segundos
    if (track.timer >= launch.valueInMilliseconds) {
      track.setTimer(launch.valueInMilliseconds);

      stopTracking();
    }
  }
}
