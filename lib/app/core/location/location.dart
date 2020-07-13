import 'package:geolocator/geolocator.dart';
import 'package:tracker_box/app/core/model/coordinate.dart';

abstract class ILocation {
  listenForPosition(Function onPositionChanged);

  cancelListener();

  static Future<double> distanceBetween(Coordinate c1, Coordinate c2) {
    return new Geolocator()
        .distanceBetween(c1.latitude, c1.longitude, c2.latitude, c2.longitude);
  }
}
