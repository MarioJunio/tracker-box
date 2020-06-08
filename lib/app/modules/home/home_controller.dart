import 'package:geolocator/geolocator.dart';
import 'package:mobx/mobx.dart';
import 'package:tracker_box/app/core/geolocator/trackerLocator.dart';
import 'package:tracker_box/app/core/model/launch.dart';
import 'package:tracker_box/app/core/model/launchType.dart';

part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  final TrackerLocator trackerLocator = new TrackerLocator();

  @observable
  int speed = 0;

  @observable
  bool isPaused = true;

  @observable
  Launch launch;

  @observable
  bool active = false;

  _HomeControllerBase() {
    resetLaunch(LaunchType.km_h);
  }

  resetLaunch(LaunchType type) {
    launch = new Launch();
    launch.type = type;
  }

  @action
  toggleTracker() {
    _refresh();

    // inicia launch caso esteja parado
    // caso contrario pare o launch atual
    if (isPaused)
      this._startLaunch();
    else
      this._stopLaunch();
  }

  @action
  setActive(bool active) {
    this.active = active;
  }

  @action
  _startLaunch() {
    // reinicia a velocidade
    this.speed = 0;

    // inicia listener para obter a posição mais atual
    trackerLocator
        .listenForPosition(_listenForPosition)
        .then((value) => _refresh());
  }

  @action
  void _stopLaunch() {
    // pausa o listener de posições
    print("=> Parou captura de posicao");
    trackerLocator.pauseListenForPosition();

    _refresh();
  }

  _listenForPosition(Position position) {
    final int tmpSpeed = (position.speed * 3.6).truncate();
    this.speed = tmpSpeed < 0 ? 0 : tmpSpeed;
  }

  _refresh() {
    this.isPaused = trackerLocator.isPaused;
  }
}
