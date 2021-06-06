import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tracker_box/app/modules/track/track_controller.dart';
import 'package:tracker_box/app/shared/utils/colors.dart';

class StartEngineButton extends StatefulWidget {
  final double width, height;

  StartEngineButton({
    this.width = 150,
    this.height = 150,
  });

  @override
  _StartEngineButtonState createState() => _StartEngineButtonState();
}

class _StartEngineButtonState extends State<StartEngineButton> {
  final TrackController controller = Modular.get<TrackController>();

  @override
  Widget build(BuildContext context) {
    return _buildToggleButton();
  }

  Widget _buildToggleButton() => Observer(
        builder: (_) {
          if (!controller.track.calibrated && controller.track.isStandby)
            return _buildCalibratingButton();

          if (controller.track.isStandby) return _buildStartButton();

          if (controller.track.isPrepare) return _buildCancelButton();

          if (controller.track.isActive) return _buildStopButton();

          return _buildCompleteButtons();
        },
      );

  Widget _buildCalibratingButton() => Container(
        width: widget.width,
        height: widget.height,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "CALIBRATING",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: ColorUtils.whitePapper),
            ),
            Text(
              "ENGINE",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: ColorUtils.whitePapper),
            ),
          ],
        ),
        decoration: BoxDecoration(
            color: ColorUtils.lightGrey,
            border: Border.all(color: ColorUtils.grey500, width: 4),
            borderRadius: BorderRadius.all(Radius.circular(100))),
      );

  Widget _buildCancelButton() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Color(0xffaf4448),
        border: Border.all(
          color: ColorUtils.grey500,
          width: 4,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(100),
        ),
      ),
      child: IconButton(
        icon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "CANCEL",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: ColorUtils.whitePapper),
            ),
            Text(
              "TRACK",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: ColorUtils.whitePapper),
            ),
          ],
        ),
        onPressed: _toggleEngine,
      ),
    );
  }

  Widget _buildStartButton() => Container(
        width: widget.width,
        height: widget.height,
        child: IconButton(
          onPressed: _toggleEngine,
          icon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "START",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: ColorUtils.whitePapper),
              ),
              Text(
                "ENGINE",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ColorUtils.whitePapper),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
            color: controller.launch.hasValue
                ? ColorUtils.lightGreen
                : ColorUtils.lightGrey,
            border: Border.all(
                color: controller.launch.hasValue
                    ? ColorUtils.green200
                    : ColorUtils.grey500,
                width: 4),
            borderRadius: BorderRadius.all(Radius.circular(100))),
      );

  Widget _buildStopButton() => Container(
        width: widget.width,
        height: widget.height,
        padding: EdgeInsets.all(16),
        child: IconButton(
          onPressed: _toggleEngine,
          icon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "STOP",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: ColorUtils.whitePapper),
              ),
              Text(
                "ENGINE",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ColorUtils.whitePapper),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          color: ColorUtils.lightRed,
          border: Border.all(
            color: ColorUtils.red200,
            width: 4,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(100),
          ),
        ),
      );

  Widget _buildCompleteButtons() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildPublishButton(),
          _buildDiscartButton(),
        ],
      ),
    );
  }

  Widget _buildPublishButton() => Container(
        width: widget.width / 2,
        height: widget.height / 2,
        decoration: BoxDecoration(
          color: ColorUtils.lightGreen,
          border: Border.all(
            color: ColorUtils.green200,
            width: 2,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(100),
          ),
        ),
        child: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.check,
            size: 30,
            color: Colors.white,
          ),
          onPressed: _publishTrack,
        ),
      );

  Widget _buildDiscartButton() => Container(
        width: widget.width / 2,
        height: widget.height / 2,
        decoration: BoxDecoration(
          color: ColorUtils.lightRed,
          border: Border.all(
            color: ColorUtils.red200,
            width: 2,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(100),
          ),
        ),
        child: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.times,
            size: 30,
            color: Colors.white,
          ),
          onPressed: _discartTrack,
        ),
      );

  _toggleEngine() {
    if ((controller.track.calibrated || !controller.track.isStandby) &&
        controller.launch.hasValue) controller.toggleTracker();
  }

  void _publishTrack() {
    controller.publishTrack();
  }

  void _discartTrack() {
    controller.discartTrack();
  }
}
