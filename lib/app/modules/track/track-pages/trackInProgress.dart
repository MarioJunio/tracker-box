import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tracker_box/app/core/model/launchType.dart';
import 'package:tracker_box/app/modules/track/track_controller.dart';
import 'package:tracker_box/app/modules/track/track_module.dart';
import 'package:tracker_box/app/shared/widgets/gauge/gauge.dart';

class TrackInProgressPage extends StatefulWidget {
  @override
  _TrackInProgressPageState createState() => _TrackInProgressPageState();
}

class _TrackInProgressPageState extends State<TrackInProgressPage> {
  final TrackController controller = TrackModule.to.get<TrackController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildStartSpeedIndicator(),
            SizedBox(height: 16),
            _mainIndicator,
            // _buildCurrentSpeedIndicator(),
            SizedBox(height: 16),
            _buildIndicators(),
            // SizedBox(height: 16),
            // _builtGPSAccuracyIndicator()
          ],
        ),
      ),
    );
  }

  Widget get _mainIndicator {
    return Observer(
      builder: (_) {
        if (controller.launch.type == LaunchType.speed) {
          return _buildMainIndicator(
              "Velocidade atual",
              controller.track.speed.toDouble(),
              controller.launch.value.toDouble(),
              "${controller.track.speed} km/h");
        } else if (controller.launch.type == LaunchType.distance) {
        } else if (controller.launch.type == LaunchType.time) {}

        return Container();
      },
    );
  }

  Widget _buildMainIndicator(String title, double currentSpeed, double maxSpeed,
      String formattedValue) {
    return Observer(
      builder: (_) {
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
                        value: currentSpeed,
                        max: maxSpeed,
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
      },
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

  Widget _buildCurrentSpeedIndicator() => Observer(
        builder: (_) {
          return Card(
            child: Container(
              padding: EdgeInsets.only(top: 16),
              child: Column(
                children: <Widget>[
                  Text(
                    "Velocidade atual",
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
                          animate: false,
                          value: controller.track.speed.toDouble(),
                          // value: 90,
                          max: controller.launch.value.toDouble(),
                          width: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                        Center(
                          child: Text(
                            "${controller.track.speed} km/h",
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
        },
      );

  Row _buildIndicators() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(child: _buildDistanceIndicator()),
          Expanded(child: _builtCountTimerIndicator()),
        ],
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
