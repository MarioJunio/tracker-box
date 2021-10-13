import 'package:mobx/mobx.dart';
part 'coordinate.g.dart';

class Coordinate = _CoordinatesBase with _$Coordinate;

abstract class _CoordinatesBase with Store {
  late double latitude;
  late double longitude;

  _CoordinatesBase({required this.latitude, required this.longitude});
}
