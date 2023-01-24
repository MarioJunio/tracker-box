import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:tracker_box/app/modules/track/track-pages/createLaunch.dart';
import 'package:tracker_box/app/modules/track/track-pages/trackInPrepare.dart';
import 'package:tracker_box/app/modules/track/track-pages/trackInProgress.dart';
import 'package:tracker_box/app/modules/track/track_module.dart';
import 'package:tracker_box/app/modules/track/widgets/startEngineButton.dart';
import 'package:tracker_box/app/shared/preferences/appPrefs.dart';
import 'package:tracker_box/app/shared/utils/internet_utils.dart';
import 'package:tracker_box/app/shared/widgets/alert/dialogBox.dart';
import 'package:tracker_box/app/shared/widgets/alert/dialogTypes.dart';

import 'track_controller.dart';

class TrackPage extends StatefulWidget {
  @override
  _TrackPageState createState() => _TrackPageState();
}

class _TrackPageState extends ModularState<TrackPage, TrackController> {
  bool _processingInternetEvent = false;

  @override
  void initState() {
    super.initState();

    _listenInternetConectivity();

    autorun((_) {
      if (controller.errorOnTrackingStart) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialogBox(
              type: DialogType.ERROR,
              title: "Tracking não iniciado",
              message:
                  "Não foi possível iniciar o tracking devido a problemas no GPS",
              textPositiveButton: "Voltar",
              onPressPositiveButton: () {
                controller.setErrorOnTrackingStart(false);
                Navigator.pop(context);
              },
            );
          },
        );
      }
    });
  }

  void _listenInternetConectivity() {
    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (_processingInternetEvent) return;

      _processingInternetEvent = true;

      try {
        if (InternetUtils.checkInternetConnection(result)) {
          await controller.publishLocalTracks(context);
        }
      } finally {
        _processingInternetEvent = false;
      }
    });
  }

  @override
  void dispose() {
    controller.stopTracking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Observer(
          builder: (_) => Text(controller.getPageTitle),
        ),
        actions: _buildAppBarActions(),
      ),
      body: _buildBody(),
      resizeToAvoidBottomInset: false,
    );
  }

  List<Widget> _buildAppBarActions() {
    return [
      _buildBarButtonMap(),
    ];
  }

  Widget _buildBarButtonMap() => Observer(
      builder: (_) => !controller.trackInProgress
          ? IconButton(
              onPressed: () {
                Modular.to.pushNamed(TrackModule.MAP_MODULE_ROUTE);
              },
              icon: FaIcon(FontAwesomeIcons.mapMarkedAlt),
            )
          : Container());

  Widget _buildBody() {
    return Center(
      child: _buildFormSetupStacked(),
    );
  }

  Widget _buildFormSetupStacked() {
    return Stack(
      children: [
        Positioned(
          child: Align(
            alignment: FractionalOffset.topCenter,
            child: _buildTrackView(),
          ),
        ),
        Positioned(
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: StartEngineButton(
                width: MediaQuery.of(context).size.height *
                    AppPreferences.TRACK_TOGGLE_BUTTON_HEIGHT,
                height: MediaQuery.of(context).size.height *
                    AppPreferences.TRACK_TOGGLE_BUTTON_HEIGHT,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrackView() => Observer(
        builder: (_) {
          if (controller.track.isStandby)
            return Padding(
              padding: const EdgeInsets.all(16),
              child: CreateTrackPage(),
            );

          /*if (controller.track.isPrepare)
            return Padding(
              padding: const EdgeInsets.all(16),
              child: TrackInPreparePage(),
            );*/

          return TrackInProgressPage();
        },
      );
}
