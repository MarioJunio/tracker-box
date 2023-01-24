import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tracker_box/app/core/location/location.dart';

class TrackerLocator extends ILocation {
  final locationDeniedStatus = [
    LocationPermission.deniedForever,
    LocationPermission.denied
  ];

  final int distanceFilter;
  late LocationSettings _locationSettings;

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
    _locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: this.distanceFilter,
    );

    // listen for changes in gps position
    if (await _isLocationServiceEnabled() && await _hasPermission()) {
      _positionStream =
          Geolocator.getPositionStream(locationSettings: _locationSettings)
              .listen(onPositionChanged);

      return Future.value(true);
    }

    return Future.value(false);
  }

  Future<bool> _isLocationServiceEnabled() async {
    bool locationServiceEnabled =
        await Permission.location.serviceStatus.isEnabled;

    print(
        "M=isLocationServiceEnabled, locationServiceEnabled=$locationServiceEnabled");

    return locationServiceEnabled;
  }

  Future<bool> _hasPermission() async {
    var status = await Permission.location.status;

    print("M=_hasPermission, locationPermission=$status");

    if (await Permission.location.isPermanentlyDenied) {
      openAppSettings();
    }

    if (!status.isGranted) {
      Map<Permission, PermissionStatus> status =
          await [Permission.location].request();
      print("M=_hasPermission, DENIED, locationPermission=$status");
    }

    return await Permission.location.status.isGranted;
  }

  @override
  cancelListener() {
    _positionStream?.cancel();
  }

  bool get isPaused => _positionStream?.isPaused ?? true;
}
