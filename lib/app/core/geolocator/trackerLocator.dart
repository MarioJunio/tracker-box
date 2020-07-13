import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:tracker_box/app/core/location/location.dart';

class TrackerLocator extends ILocation {
  final Geolocator geolocator = new Geolocator();
  final int distanceFilter;

  LocationOptions locatorOptions;

  StreamSubscription _positionStream;

  TrackerLocator({this.distanceFilter = 0}) {
    locatorOptions = LocationOptions(
      accuracy: LocationAccuracy.bestForNavigation,
      timeInterval: 1,
      distanceFilter: this.distanceFilter,
      forceAndroidLocationManager: true,
    );
  }

  @override
  listenForPosition(Function onPositionChanged) async {
    GeolocationStatus status =
        await geolocator.checkGeolocationPermissionStatus();

    // check the gps status is disabled
    if (status == GeolocationStatus.disabled) {
      return Future.value(false);
    }

    // listen for changes in gps position
    _positionStream = this
        .geolocator
        .getPositionStream(this.locatorOptions)
        .listen(onPositionChanged);

    return Future.value(true);
  }

  @override
  cancelListener() {
    _positionStream?.cancel();
  }

  bool get isPaused => _positionStream == null || _positionStream.isPaused;
}
