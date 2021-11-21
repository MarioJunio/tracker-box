import 'package:geolocator/geolocator.dart';
import 'package:tracker_box/app/core/entities/coordinate_entity.dart';

abstract class ILocation {
  cancelListener();

  static double distanceBetween(CoordinateEntity c1, CoordinateEntity c2) {
    return Geolocator.distanceBetween(
        c1.latitude, c1.longitude, c2.latitude, c2.longitude);
  }
}
