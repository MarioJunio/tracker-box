import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tracker_box/app/modules/track/track_controller.dart';

class TrackComplete extends StatefulWidget {
  TrackComplete({Key? key}) : super(key: key);

  @override
  _TrackCompleteState createState() => _TrackCompleteState();
}

class _TrackCompleteState extends State<TrackComplete> {
  final TrackController controller = Modular.get<TrackController>();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
