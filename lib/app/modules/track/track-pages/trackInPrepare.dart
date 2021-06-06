import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tracker_box/app/modules/track/track_controller.dart';

class TrackInPreparePage extends StatefulWidget {
  @override
  _TrackInPreparePageState createState() => _TrackInPreparePageState();
}

class _TrackInPreparePageState extends State<TrackInPreparePage> {
  final TrackController controller = Modular.get<TrackController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Observer(builder: (_) {
        return Center(
          child: Text(
            controller.prepareCountDown.toString(),
            style: TextStyle(
              fontSize: 200,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        );
      }),
    );
  }
}
