import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tracker_box/app/core/model/launchType.dart';
import 'package:tracker_box/app/core/model/launchUnitType.dart';
import 'package:tracker_box/app/modules/track/track_controller.dart';
import 'package:tracker_box/app/shared/preferences/appPrefs.dart';

class SpeedPage extends StatefulWidget {
  @override
  _SpeedPageState createState() => _SpeedPageState();
}

class _SpeedPageState extends State<SpeedPage> {
  TrackController controller = Modular.get<TrackController>();

  @override
  void initState() {
    super.initState();

    controller.launch.selectLaunchType(LaunchType.speed);
    controller.launch.setLaunchUnitType(LaunchUnitType.km_h);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        Widget labelDescription = controller.launch.value > 0
            ? Container()
            : Text("Deslize para configurar a velocidade em ",
                style: Theme.of(context).textTheme.subtitle2);

        String labelValue = controller.launch.value > 0
            ? "Velocidade ${controller.launch.value} ${controller.launch.launchTypeDescription}"
            : "${controller.launch.launchTypeDescription}";

        return Container(
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height *
                  AppPreferences.TRACK_TOGGLE_BUTTON_HEIGHT),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  labelDescription,
                  Text(
                    labelValue,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              Slider(
                  value: controller.launch.value.toDouble(),
                  min: 0,
                  max: 320,
                  divisions: 320,
                  activeColor: Theme.of(context).primaryColor,
                  inactiveColor: Colors.black26,
                  label: "${controller.launch.valueFormatted}",
                  onChanged: (double speed) {
                    controller.launch.setValue(speed.toInt());
                  }),
            ],
          ),
        );
      },
    );
  }
}
