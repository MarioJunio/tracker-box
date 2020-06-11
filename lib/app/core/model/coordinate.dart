import 'package:mobx/mobx.dart';
part 'coordinate.g.dart';

class Coordinate = _CoordinatesBase with _$Coordinate;

abstract class _CoordinatesBase with Store {
  double latitude;
  double longitude;

  _CoordinatesBase({this.latitude, this.longitude});
}
