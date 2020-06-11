import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tracker_box/app/modules/track/track-pages/createLaunch.dart';
import 'package:tracker_box/app/modules/track/track-pages/trackInProgress.dart';
import 'package:tracker_box/app/modules/track/widgets/startEngineButton.dart';

import 'track_controller.dart';

class TrackPage extends StatefulWidget {
  @override
  _TrackPageState createState() => _TrackPageState();
}

class _TrackPageState extends ModularState<TrackPage, TrackController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crie seu Track"),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Center(
        child: _buildFormSetup(),
      ),
    );
  }

  Widget _buildFormSetup() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _buildTrackView()),
        SizedBox(height: 60),
        StartEngineButton(),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildTrackView() => Observer(
        builder: (_) {
          if (!controller.track.inProgress) return CreateLaunchPage();

          if (controller.track.inProgress) return TrackInProgressPage();

          return Container();
        },
      );
}
