import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildSpeedmeterIndicator(),
          SizedBox(height: 16),
          _buildIndicators(),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSpeedmeterIndicator() => Observer(
        builder: (_) {
          return Card(
            child: Container(
              padding: EdgeInsets.only(top: 16),
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
                  Container(
                    height: 200,
                    width: double.infinity,
                    child: Stack(
                      children: <Widget>[
                        GaugeChart.fromValue(
                            // value: controller.track.speed.toDouble(),
                            max: controller.launch.value.toDouble(),
                            value: 90,
                            color: Theme.of(context).primaryColor),
                        Center(
                          child: Text(
                            "${controller.track.speed} km/h",
                            style: TextStyle(
                                fontSize: 16,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.map,
                    color: Theme.of(context).primaryColor,
                    size: 26,
                  ),
                  Observer(
                    builder: (_) {
                      return Text(
                        "${controller.track.distance.toStringAsFixed(2)} met",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      );
                    },
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.timer,
                    color: Theme.of(context).primaryColor,
                    size: 26,
                  ),
                  Observer(
                    builder: (_) {
                      return Text(
                        "${controller.track.accuracy.toStringAsFixed(2)} seg",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
