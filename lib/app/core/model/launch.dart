import 'package:mobx/mobx.dart';
import 'package:tracker_box/app/core/model/launchType.dart';
import 'package:tracker_box/app/core/model/launchUnitType.dart';

part 'launch.g.dart';

class Launch = _LaunchBase with _$Launch;

abstract class _LaunchBase with Store {
  int id = 0;

  @observable
  LaunchType type = LaunchType.speed;

  @observable
  LaunchUnitType unitType = LaunchUnitType.km_h;

  @observable
  int value = 0;

  @action
  selectLaunchType(LaunchType type) {
    this.type = type;
  }

  @action
  setLaunchUnitType(LaunchUnitType unitType) {
    this.unitType = unitType;
  }

  @action
  setValue(int value) {
    this.value = value;
  }

  @computed
  bool get hasValue => this.value > 0;

  @computed
  String get launchTypeDescription =>
      LaunchTypeDescription.getDescription(type);

  @computed
  String get valueFormatted => "$value $launchTypeDescription";

  @computed
  int get valueInMeters => unitType == LaunchUnitType.km ? value * 1000 : value;

  @computed
  int get valueInMilliseconds =>
      (unitType == LaunchUnitType.minute ? value * 60 : value) * 1000;
}
