import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:tracker_box/app/core/geolocator/trackerLocator.dart';
import 'package:tracker_box/app/core/model/coordinate.dart';
import 'package:tracker_box/app/shared/utils/map_utils.dart';

part 'map_controller.g.dart';

class MapController = _MapStoreBase with _$MapController;

abstract class _MapStoreBase with Store {
  final TrackerLocator trackerLocator = new TrackerLocator();
  GoogleMapController? mapController;

  List<Coordinate> coordinates = [];

  ObservableMap<MarkerId, Marker> markers = ObservableMap();
  ObservableMap<PolylineId, Polyline> polylines = ObservableMap();

  Function? onUpdateCurrentPosition;

  void startCapturePositions() {
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
      color: Colors.red,
      points: MapUtils.toPolylineCoordinates(coordinates),
    );

    polylines[polyline.polylineId] = polyline;
  }

  @action
  void setCurrentMarker(Position position) {
    Marker marker = Marker(
      markerId: MarkerId("ME"),
      icon: BitmapDescriptor.defaultMarkerWithHue(80),
      position: LatLng(position.latitude, position.longitude),
      rotation: position.heading,
    );

    markers[marker.markerId] = marker;
  }

  void setOnUpdateCurrentPosition(Function onUpdateCurrentPosition) {
    this.onUpdateCurrentPosition = onUpdateCurrentPosition;
  }

  @action
  _listenForPosition(Position position) {
    onUpdateCurrentPosition!(position);

    mapController?.animateCamera(CameraUpdate.newLatLngZoom(
      LatLng(position.latitude, position.longitude),
      16.5,
    ));
  }

  List<Coordinate> get getOriginAndDestinateCoordinates {
    return coordinates.isNotEmpty ? [coordinates.first, coordinates.last] : [];
  }

  List<LatLng> get toPolylineCoordinates => coordinates
      .map((coordinate) => LatLng(coordinate.latitude, coordinate.longitude))
      .toList();

  void setCoordinates(List<Coordinate> coordinates) =>
      this.coordinates = coordinates;

  void setGoogleMapController(GoogleMapController googleMapController) =>
      this.mapController = googleMapController;
}
