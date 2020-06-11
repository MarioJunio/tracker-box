import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:tracker_box/app/core/model/coordinate.dart';

class TrackerLocator {
  final Geolocator geolocator = new Geolocator();
  final int distanceFilter;

  LocationOptions locatorOptions;

  StreamSubscription _positionStream;

  TrackerLocator({this.distanceFilter = 0}) {
    locatorOptions = LocationOptions(
        accuracy: LocationAccuracy.high,
        distanceFilter: this.distanceFilter,
        forceAndroidLocationManager: true);
  }

  Future<bool> listenForPosition(Function onPositionChanged) async {
    GeolocationStatus status =
        await geolocator.checkGeolocationPermissionStatus();

    // check the gps status is disabled
    if (status == GeolocationStatus.disabled) {
      return Future.value(false);
    }

    // listen for changes in gps position
    if (_positionStream != null) {
      _positionStream.resume();
    } else {
      _positionStream = this
          .geolocator
          .getPositionStream(this.locatorOptions)
          .listen(onPositionChanged);
    }

    return Future.value(true);
  }

  void pauseListenForPosition() {
    if (_positionStream != null) _positionStream.pause();
  }

  static Future<double> distanceBetween(Coordinate c1, Coordinate c2) {
    return new Geolocator()
        .distanceBetween(c1.latitude, c1.longitude, c2.latitude, c2.longitude);
  }

  bool get isPaused => _positionStream == null || _positionStream.isPaused;
}
