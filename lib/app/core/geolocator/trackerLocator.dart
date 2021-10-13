import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:tracker_box/app/core/location/location.dart';

class TrackerLocator extends ILocation {
  final locationDeniedStatus = [
    LocationPermission.deniedForever,
    LocationPermission.denied
  ];

  final int distanceFilter;

  // late LocationOptions _locationOptions;
  // LocationService? _locationService;
  StreamSubscription? _positionStream;

  TrackerLocator({this.distanceFilter = 0}) {
    // _locationService = LocationService();

    /*_locationOptions = LocationOptions(
      accuracy: LocationAccuracy.bestForNavigation,
      timeInterval: 1,
      distanceFilter: this.distanceFilter,
      forceAndroidLocationManager: true,
    );*/
  }

  listenForPosition(Function(Position) onPositionChanged) async {
    /*bool locationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    print(
        "M=listenForPosition, locationServiceEnabled=$locationServiceEnabled");

    // check whether location service is not enabled
    if (!locationServiceEnabled) {
      return Future.value(false);
    }

    LocationPermission locationPermission = await Geolocator.checkPermission();
    print("M=listenForPosition, locationPermission=$locationPermission");

    // check whether location permission is denied
    if (LOCATION_DENIED_STATUS.contains(locationPermission)) {
      locationPermission = await Geolocator.requestPermission();
      print(
          "M=listenForPosition, after request permission, locationPermission=$locationPermission");

      if (LOCATION_DENIED_STATUS.contains(locationPermission)) {
        return Future.value(false);
      }
    }*/

    // if (await _locationService?.canStart() ?? false) {
    if (await _isLocationServiceEnabled() && await _hasPermission()) {
      // listen for changes in gps position
      _positionStream = Geolocator.getPositionStream(
              intervalDuration: Duration(milliseconds: 1),
              forceAndroidLocationManager: true,
              desiredAccuracy: LocationAccuracy.bestForNavigation,
              distanceFilter: this.distanceFilter)
          .listen(onPositionChanged);

      return Future.value(true);
    }

    return Future.value(false);
  }

  Future<bool> _isLocationServiceEnabled() async {
    bool locationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    print(
        "M=isLocationServiceEnabled, locationServiceEnabled=$locationServiceEnabled");

    return locationServiceEnabled;
  }

  Future<bool> _hasPermission() async {
    LocationPermission locationPermission = await Geolocator.checkPermission();

    print("M=_hasPermission, locationPermission=$locationPermission");

    if (locationDeniedStatus.contains(locationPermission)) {
      locationPermission = await Geolocator.requestPermission();
      print("M=_hasPermission, DENIED, locationPermission=$locationPermission");
    }

    return !locationDeniedStatus.contains(locationPermission);
  }

  @override
  cancelListener() {
    _positionStream?.cancel();
  }

  bool get isPaused => _positionStream?.isPaused ?? true;
}
