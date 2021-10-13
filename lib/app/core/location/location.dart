import 'package:geolocator/geolocator.dart';
import 'package:tracker_box/app/core/model/coordinate.dart';

abstract class ILocation {
  cancelListener();

  static double distanceBetween(Coordinate c1, Coordinate c2) {
    return Geolocator.distanceBetween(
        c1.latitude, c1.longitude, c2.latitude, c2.longitude);
  }
}
