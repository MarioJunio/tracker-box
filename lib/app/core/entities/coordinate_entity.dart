import 'package:mobx/mobx.dart';
part '../model/coordinate_entity.g.dart';

class CoordinateEntity = _CoordinatesBase with _$CoordinateEntity;

abstract class _CoordinatesBase with Store {
  late double latitude;
  late double longitude;

  _CoordinatesBase({required this.latitude, required this.longitude});
}
