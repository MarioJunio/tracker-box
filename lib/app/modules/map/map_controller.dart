import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:tracker_box/app/core/geolocator/trackerLocator.dart';
import 'package:tracker_box/app/core/model/coordinate.dart';
import 'package:tracker_box/app/core/model/track.dart';
import 'package:tracker_box/app/core/model/trackStatus.dart';
import 'package:tracker_box/app/shared/preferences/appPrefs.dart';
import 'package:tracker_box/app/shared/utils/map_utils.dart';

part 'map_controller.g.dart';

class MapController = _MapStoreBase with _$MapController;

abstract class _MapStoreBase with Store {
  final PolylineId currentPolylineId = PolylineId("P0");
  final TrackerLocator trackerLocator = new TrackerLocator();
  GoogleMapController? mapController;

  ObservableMap<MarkerId, Marker> markers = ObservableMap();
  ObservableMap<PolylineId, Polyline> polylines = ObservableMap();

  List<Coordinate> coordinates = [];

  BitmapDescriptor? customUserMarker;

  Function? onUpdateCurrentPosition;

  Timer? _countTimer;

  @observable
  Track track = new Track();

  @observable
  bool centralize = true;

  @action
  void setCentralize(bool centralize) {
    this.centralize = centralize;
  }

  @action
  void startCapturePositions() {
    /*MapUtils.drawTrackMarkerDot(80, 80, Colors.blueAccent).then((value) {
      addMarker(
        "M0",
        LatLng(-19.75364, -47.9339936),
        BitmapDescriptor.fromBytes(value),
      );
    });*/

    trackerLocator.listenForPosition(_listenForPosition).then((value) {
      print("M=listenForPosition, value=$value");
    });
  }

  void stopCapturePositions() {
    trackerLocator.cancelListener();
  }

  @action
  void addMarker(String id, LatLng position, BitmapDescriptor descriptor) {
    Marker marker = Marker(
      markerId: MarkerId(id),
      icon: descriptor,
      position: position,
    );
    markers[marker.markerId] = marker;
  }

  @action
  void addPolyline(String id, Color color, List<Coordinate> coordinates) {
    Polyline polyline = Polyline(
      polylineId: PolylineId(id),
      color: color,
      points: MapUtils.toPolylineCoordinates(coordinates),
    );

    polylines[polyline.polylineId] = polyline;
  }

  @action
  void setCurrentMarker(Position position) {
    Marker marker = Marker(
      markerId: MarkerId("ME"),
      icon: customUserMarker!,
      position: LatLng(position.latitude, position.longitude),
      rotation: position.heading,
    );

    markers[marker.markerId] = marker;
  }

  void setOnUpdateCurrentPosition(Function onUpdateCurrentPosition) {
    this.onUpdateCurrentPosition = onUpdateCurrentPosition;
  }

  @action
  void startTracking() {
    polylines[currentPolylineId] = Polyline(
      polylineId: currentPolylineId,
      color: Colors.blue.shade400,
      points: [],
    );

    track = Track();
    track.setTrackStatus(TrackStatus.active);
  }

  @action
  void stopTracking() {
    track.setTrackStatus(TrackStatus.complete);

    // para o temporizador
    _stopTimer();

    if (track.coordinates.isNotEmpty) {
      final lastCoordinate = track.coordinates.last;

      // change route color
      final points = polylines[currentPolylineId]!.points;

      polylines[currentPolylineId] = Polyline(
        polylineId: currentPolylineId,
        color: Colors.blue.shade700,
        points: points,
      );

      MapUtils.drawTrackMarkerDot(60, 60, Colors.blueAccent.shade200)
          .then((value) {
        addMarker(
          "M1",
          LatLng(lastCoordinate.latitude, lastCoordinate.longitude),
          BitmapDescriptor.fromBytes(value),
        );
      });
    }
  }

  @action
  void publishTrack() {
    //TODO: chamar serviço para publicar track ou armazenar localmente caso a internet esteja OFF
    track.setTrackStatus(TrackStatus.standby);
  }

  @action
  void discardTrack() {
    track.setTrackStatus(TrackStatus.standby);
  }

  @action
  _listenForPosition(Position position) {
    track.accuracy = position.accuracy;

    onUpdateCurrentPosition!(position);

    if (track.status != TrackStatus.complete && centralize) {
      mapController?.animateCamera(CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude), 18.5));
    } else if (track.status == TrackStatus.complete) {
      MapUtils.fitMapOnTrack(track.coordinates, mapController!);
    }

    _updateTrackActive(position);
  }

  void _updateTrackActive(Position position) async {
    // converte velocidade de m/s -> km/h
    final int tmpSpeed = (position.speed * 3.6).truncate();

    // não aceita velocidade negativa, acontece se inicia o GPS
    track.setSpeed(tmpSpeed < 0 ? 0 : tmpSpeed);

    if (track.isActive) {
      // inicia temporizador da track
      if (track.canStartTimer && tmpSpeed > 0) _startTimer();

      // define velocidade inicial do track
      track.setStartSpeed(tmpSpeed < 0 ? 0 : tmpSpeed);

      final LatLng latLng = LatLng(position.latitude, position.longitude);

      // adiciona polyline para criar a rota
      polylines[currentPolylineId]!.points.add(latLng);

      // adiciona bandeira de inicio do track
      if (track.coordinates.isEmpty) {
        addMarker(
            "M0",
            latLng,
            BitmapDescriptor.fromBytes(
                await MapUtils.drawTrackMarkerDot(60, 60, Colors.blueAccent)));
      }

      // add coordenada a lista
      track.coordinates.add(new Coordinate(
        latitude: position.latitude,
        longitude: position.longitude,
      ));

      // calcula distancia
      track.calculateDistance();
    }
  }

  void _startTimer() {
    track.canStartTimer = false;

    if (!(_countTimer?.isActive ?? false)) {
      _countTimer = Timer.periodic(
        Duration(milliseconds: AppPreferences.TRACK_TIMER_DELAY_MILLI),
        (timer) {
          track.incrementTimer(AppPreferences.TRACK_TIMER_DELAY_MILLI);
        },
      );
    }
  }

  _stopTimer() {
    _countTimer?.cancel();
  }

  List<Coordinate> get getOriginAndDestinateCoordinates {
    return coordinates.isNotEmpty ? [coordinates.first, coordinates.last] : [];
  }

  void setCoordinates(List<Coordinate> coordinates) =>
      this.coordinates = coordinates;

  void setGoogleMapController(GoogleMapController googleMapController) =>
      this.mapController = googleMapController;

  void setCustomUserMarker(BitmapDescriptor marker) =>
      this.customUserMarker = marker;

  bool get showIndicators => track.isActive || track.isComplete;
}
