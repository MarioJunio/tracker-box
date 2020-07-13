import 'dart:async';

import 'package:location/location.dart';
import 'package:tracker_box/app/core/location/location.dart';

class LocatorService extends ILocation {
  final Location _location = new Location();
  
  StreamSubscription _positionStream;

  LocatorService() {
    _location.changeSettings(accuracy: LocationAccuracy.navigation, interval: 1, distanceFilter: 0);
  }

  Future<bool> canStart() async {
    bool _serviceEnabled = await _location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();

      if (!_serviceEnabled) {
        return false;
      }
}

    PermissionStatus _permissionGranted = await _location.hasPermission();

    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();

      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    return true;
  }

  @override
  listenForPosition(Function onPositionChanged) {
    _positionStream = _location.onLocationChanged.listen(onPositionChanged);
  }

  @override
  cancelListener() {
    _positionStream?.cancel();
  }

}