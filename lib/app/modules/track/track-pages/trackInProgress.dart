import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tracker_box/app/core/model/launchType.dart';
import 'package:tracker_box/app/modules/track/track_controller.dart';
import 'package:tracker_box/app/shared/widgets/gauge/gauge.dart';

class TrackInProgressPage extends StatefulWidget {
  @override
  _TrackInProgressPageState createState() => _TrackInProgressPageState();
}

class _TrackInProgressPageState extends State<TrackInProgressPage> {
  final TrackController controller = Modular.get<TrackController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildStartSpeedIndicator(),
            _mainGap,
            _mainIndicator,
            _mainGap,
            _buildSecondaryIndicators,
          ],
        ),
      ),
    );
  }

  Widget get _mainGap => SizedBox(height: 16);

  Widget get _mainIndicator {
    return Observer(
      builder: (_) {
        if (controller.launch.type == LaunchType.speed) {
          return _buildMainIndicator(
              "Velocidade atual",
              controller.track.speed.toDouble(),
              controller.launch.value.toDouble(),
              controller.track.speedFormatted);
        } else if (controller.launch.type == LaunchType.distance) {
          return _buildMainIndicator(
              "Distância percorrida",
              controller.track.distance,
              controller.launch.value.toDouble(),
              controller.track.distanceFormatted);
        } else if (controller.launch.type == LaunchType.time) {
          return _buildMainIndicator(
              "Tempo",
              controller.track.timer.toDouble(),
              controller.launch.valueInMilliseconds.toDouble(),
              controller.track.timerFormatted);
        }

        return Container(
          child: Text("Tipo não identificado"),
        );
      },
    );
  }

  Widget _buildMainIndicator(String title, double currentValue, double maxValue,
      String formattedValue) {
    return Card(
      child: Container(
        padding: EdgeInsets.only(top: 16),
        child: Column(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xff00897b),
              ),
            ),
            Container(
              height: 180,
              width: double.infinity,
              child: Stack(
                children: <Widget>[
                  GaugeChart.fromValue(
                    value: currentValue,
                    max: maxValue,
                    animate: false,
                    width: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                  Center(
                    child: Text(
                      formattedValue,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row get _buildSecondaryIndicators {
    var first;
    var second;

    if (controller.launch.type == LaunchType.speed) {
      first = _buildDistanceIndicator();
      second = _builtCountTimerIndicator();
    } else if (controller.launch.type == LaunchType.distance) {
      first = _buildSpeedIndicator();
      second = _builtCountTimerIndicator();
    } else if (controller.launch.type == LaunchType.time) {
      first = _buildSpeedIndicator();
      second = _buildDistanceIndicator();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(child: first),
        Expanded(child: second),
      ],
    );
  }

  Widget _buildStartSpeedIndicator() => Observer(
        builder: (_) {
          return (controller.track.startSpeed ?? 0) != controller.track.speed
              ? Card(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Velocidade de início",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff00897b),
                          ),
                        ),
                        SizedBox(height: 16),
                        Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: FaIcon(
                                FontAwesomeIcons.tachometerAlt,
                                size: 26,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Observer(
                                builder: (_) {
                                  return Text(
                                    "${controller.track.startSpeed ?? 0} km/h",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : Container();
        },
      );

  Widget _buildSpeedIndicator() => Card(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Text(
                "Velocidade",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff00897b),
                ),
              ),
              SizedBox(height: 16),
              Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FaIcon(
                      FontAwesomeIcons.tachometerAlt,
                      size: 26,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Observer(
                      builder: (_) {
                        return Text(
                          "${controller.track.speedFormatted}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _buildDistanceIndicator() => Card(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Text(
                "Distância",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff00897b),
                ),
              ),
              SizedBox(height: 16),
              Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FaIcon(
                      FontAwesomeIcons.road,
                      size: 26,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Observer(
                      builder: (_) {
                        return Text(
                          "${controller.track.distanceFormatted}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _builtCountTimerIndicator() => Card(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Text(
                "Tempo",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff00897b),
                ),
              ),
              SizedBox(height: 16),
              Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FaIcon(
                      FontAwesomeIcons.stopwatch,
                      size: 26,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Observer(
                      builder: (_) {
                        return Text(
                          "${controller.track.timerFormatted}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _builtGPSAccuracyIndicator() => Card(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Precisão",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff00897b),
                ),
              ),
              SizedBox(height: 16),
              Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FaIcon(
                      FontAwesomeIcons.solidDotCircle,
                      size: 26,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Center(
                    child: Observer(
                      builder: (_) {
                        return Text(
                          "${controller.track.accuracy.toStringAsFixed(2)} met",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
