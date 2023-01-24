import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracker_box/app/core/entities/coordinate_entity.dart';
import 'package:tracker_box/app/core/model/launchType.dart';
import 'package:tracker_box/app/modules/track/track_controller.dart';
import 'package:tracker_box/app/shared/utils/map_utils.dart';
import 'package:tracker_box/app/shared/widgets/gauge/gauge.dart';

class TrackInProgressPage extends StatefulWidget {
  @override
  _TrackInProgressPageState createState() => _TrackInProgressPageState();
}

class _TrackInProgressPageState extends State<TrackInProgressPage> {
  final TrackController controller = Modular.get<TrackController>();

  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};

  double mainIndicatorHeight = 0;
  double mainIndicatorContentVisible = 0;

  double secondaryFirstIndicatorHeight = 0;
  double secondaryFirstIndicatorVisible = 0;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 100)).then((value) {
      setState(() {
        mainIndicatorHeight = 213;
        mainIndicatorContentVisible = 1;
      });
    });

    Future.delayed(Duration(seconds: 1)).then((value) {
      setState(() {
        secondaryFirstIndicatorHeight = 100;
        secondaryFirstIndicatorVisible = 1;
      });
    });

    /*when(
      (_) => controller.track.status == TrackStatus.prepare,
      () {
        print("=> Chamou");
        setState(() {
          mainIndicatorHeight = 213;
        });
      },
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildStartSpeedIndicator,
          _mainIndicator,
          _buildSecondaryIndicators,
          _mainGap,
          _buildMapViewTracker,
        ],
      ),
    );
  }

  Widget get _buildMapViewTracker => Observer(
      builder: (_) => controller.track.isComplete
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Card(
                elevation: 8,
                child: Container(
                  height: 200,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    myLocationButtonEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(-23.714468, -46.9162349),
                      zoom: 5,
                    ),
                    zoomControlsEnabled: false,
                    markers: Set<Marker>.of(markers.values),
                    polylines: Set<Polyline>.of(polylines.values),
                  ),
                ),
              ),
            )
          : Container());

  void _onMapCreated(GoogleMapController mapController) {
    controller.setGoogleMapController(mapController);

    if (controller.track.isComplete) {
      final List<CoordinateEntity> trackMarkers =
          controller.track.getTraceBeginAndEndCoordinates;

      if (trackMarkers.isNotEmpty) {
        final originPosition =
            LatLng(trackMarkers[0].latitude!, trackMarkers[0].longitude!);

        final destinatePosition =
            LatLng(trackMarkers[1].latitude!, trackMarkers[1].longitude!);

        _addMarker(
          "start",
          originPosition,
          BitmapDescriptor.defaultMarker,
        );

        _addMarker(
          "end",
          destinatePosition,
          BitmapDescriptor.defaultMarkerWithHue(50),
        );

        _addPolyLine();

        mapController.animateCamera(CameraUpdate.newLatLngZoom(
          LatLng(trackMarkers[0].latitude!, trackMarkers[0].longitude!),
          16.5,
        ));

        // setState(() {});
      }
    }
  }

  Widget get _mainGap => SizedBox(height: 8);

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
    return AnimatedContainer(
      height: mainIndicatorHeight,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
      child: Card(
        elevation: 1,
        child: Padding(
          padding: EdgeInsets.only(top: 8),
          child: SingleChildScrollView(
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
                AnimatedOpacity(
                  duration: Duration(seconds: 3),
                  curve: Curves.fastOutSlowIn,
                  opacity: mainIndicatorContentVisible,
                  child: SizedBox(
                    height: 180,
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
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get _buildSecondaryIndicators {
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: AnimatedContainer(
                height: secondaryFirstIndicatorHeight,
                duration: Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                child: SingleChildScrollView(
                  child: first,
                )),
          ),
          Expanded(
            child: AnimatedContainer(
                height: secondaryFirstIndicatorHeight,
                duration: Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                child: SingleChildScrollView(
                  child: second,
                )),
          ),
        ],
      ),
    );
  }

  Widget get _buildStartSpeedIndicator => Observer(
        builder: (_) {
          return (controller.track.startSpeed) != controller.track.speed
              ? Container(
                  margin: EdgeInsets.only(top: 16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
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
                                alignment: Alignment.center,
                                child: Observer(
                                  builder: (_) {
                                    return Text(
                                      "${controller.track.startSpeed} km/h",
                                      style: TextStyle(
                                        fontSize: 18,
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
                  ),
                )
              : Container();
        },
      );

  Widget _buildSpeedIndicator() => Card(
        child: Container(
          padding: EdgeInsets.all(16),
          child: AnimatedOpacity(
            duration: Duration(seconds: 3),
            opacity: secondaryFirstIndicatorVisible,
            curve: Curves.fastOutSlowIn,
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
                              fontSize: 18,
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
        ),
      );

  Widget _buildDistanceIndicator() => Card(
        child: Container(
          padding: EdgeInsets.all(16),
          child: AnimatedOpacity(
            duration: Duration(seconds: 3),
            opacity: secondaryFirstIndicatorVisible,
            curve: Curves.fastOutSlowIn,
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
                              fontSize: 18,
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
        ),
      );

  Widget _builtCountTimerIndicator() => Card(
        child: Container(
          padding: EdgeInsets.all(16),
          child: AnimatedOpacity(
            duration: Duration(seconds: 3),
            opacity: secondaryFirstIndicatorVisible,
            curve: Curves.fastOutSlowIn,
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
                              fontSize: 18,
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

  _addMarker(String id, LatLng position, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);

    markers.putIfAbsent(
      markerId,
      () => MapUtils.createMarker(markerId, position, descriptor),
    );
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");

    polylines.putIfAbsent(
      id,
      () => MapUtils.createPolyline(
          id, Colors.blue.shade600, controller.track.coordinates),
    );
  }
}
