import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tracker_box/app/modules/track/track_controller.dart';
import 'package:tracker_box/app/modules/track/track_module.dart';
import 'package:tracker_box/app/shared/utils/colors.dart';

class StartEngineButton extends StatefulWidget {
  @override
  _StartEngineButtonState createState() => _StartEngineButtonState();
}

class _StartEngineButtonState extends State<StartEngineButton> {
  final TrackController controller = TrackModule.to.get<TrackController>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _toggleEngine,
      child: _buildToggleButton(),
    );
  }

  Widget _buildToggleButton() => Observer(
      builder: (_) => controller.track.inProgress
          ? _buildStopButton()
          : _buildStartButton());

  Widget _buildStartButton() => Observer(
        builder: (_) {
          return Container(
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
          );
        },
      );

  Widget _buildStopButton() => Container(
        width: 120,
        height: 120,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "STOP",
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
          color: Color(0xffaf4448),
          border: Border.all(
            color: ColorsUtil.grey500,
            width: 4,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(100),
          ),
        ),
      );

  _toggleEngine() {
    if (controller.launch.hasValue) controller.toggleTracker();
  }
}
