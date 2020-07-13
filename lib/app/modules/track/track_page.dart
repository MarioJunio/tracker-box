import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tracker_box/app/modules/track/track-pages/createLaunch.dart';
import 'package:tracker_box/app/modules/track/track-pages/trackInPrepare.dart';
import 'package:tracker_box/app/modules/track/track-pages/trackInProgress.dart';
import 'package:tracker_box/app/modules/track/widgets/startEngineButton.dart';
import 'package:tracker_box/app/shared/preferences/appPrefs.dart';

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
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Center(
        child: _buildFormSetupStacked(),
      ),
    );
  }

  Widget _buildFormSetup() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _buildTrackView()),
        SizedBox(height: 60),
        StartEngineButton(
          width: MediaQuery.of(context).size.height * 0.20,
          height: MediaQuery.of(context).size.height * 0.20,
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildFormSetupStacked() {
    return Stack(
      children: [
        Positioned(
          child: Align(
            alignment: FractionalOffset.topCenter,
            child: Container(
              child: _buildTrackView(),
            ),
          ),
        ),
        Positioned(
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: StartEngineButton(
              width: MediaQuery.of(context).size.height * AppPreferences.TRACK_TOGGLE_BUTTON_HEIGHT,
              height: MediaQuery.of(context).size.height * AppPreferences.TRACK_TOGGLE_BUTTON_HEIGHT,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrackView() => Observer(
        builder: (_) {
          if (controller.track.isStandby) return CreateLaunchPage();

          if (controller.track.isPrepare) return TrackInPreparePage();

          return TrackInProgressPage();
        },
      );
}
