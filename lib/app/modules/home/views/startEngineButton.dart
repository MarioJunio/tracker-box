import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tracker_box/app/modules/home/home_controller.dart';
import 'package:tracker_box/app/shared/utils/colors.dart';

class StartEngineButton extends StatefulWidget {
  @override
  _StartEngineButtonState createState() => _StartEngineButtonState();
}

class _StartEngineButtonState
    extends ModularState<StartEngineButton, HomeController> {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return controller.launch.type != null
            ? Container(
                width: 120,
                height: 120,
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "START",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: ColorsUtil.whitePapper),
                    ),
                    Text(
                      "ENGINE",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: ColorsUtil.whitePapper),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                    color: controller.launch.hasValue
                        ? ColorsUtil.lightGreen
                        : ColorsUtil.lightGrey,
                    border: Border.all(
                        color: controller.launch.hasValue
                            ? ColorsUtil.green200
                            : ColorsUtil.grey500,
                        width: 4),
                    borderRadius: BorderRadius.all(Radius.circular(100))),
              )
            : Container();
      },
    );
  }
}
