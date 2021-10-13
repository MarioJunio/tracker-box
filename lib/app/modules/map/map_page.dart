import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracker_box/app/core/model/coordinate.dart';
import 'package:tracker_box/app/modules/map/map_controller.dart';
import 'package:tracker_box/app/modules/track/track_module.dart';

import 'map_controller.dart';

class MapPage extends StatefulWidget {
  final String? title;
  final List<Coordinate> coordinates;

  const MapPage(
    this.coordinates, {
    Key? key,
    this.title = 'Tracks',
  }) : super(key: key);
  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends ModularState<MapPage, MapController> {
  // PolylinePoints polylinePoints = PolylinePoints();

  @override
  void initState() {
    super.initState();
    controller.setCoordinates(widget.coordinates);
    controller.setOnUpdateCurrentPosition(_onUpdateCurrentPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? ""),
          actions: _buildBarActions(),
        ),
        body: Observer(builder: (_) {
          return Stack(
            children: [
              GoogleMap(
                onMapCreated: _onMapCreated,
                myLocationButtonEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: LatLng(-23.714468, -46.9162349),
                  zoom: 6,
                ),
                zoomControlsEnabled: false,
                markers: Set<Marker>.of(controller.markers.values),
                polylines: Set<Polyline>.of(controller.polylines.values),
              ),
              Container(
                margin: EdgeInsets.only(top: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      child: _buildIndicator("123", "km/h"),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 8, top: 16),
                      child: _buildIndicator("3.5", "seg"),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 8, top: 16),
                      child: _buildIndicator("657", "metros"),
                    ),
                  ],
                ),
              )
            ],
          );
        }));
  }

  List<Widget> _buildBarActions() {
    return [
      IconButton(
        onPressed: () {},
        icon: FaIcon(
          FontAwesomeIcons.play,
        ),
      )
    ];
  }

  Widget _buildIndicator(String value, String label) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(150),
        border: Border.all(
          width: 4,
          color: Theme.of(context).primaryColor.withOpacity(0.6),
        ),
        shape: BoxShape.circle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _onUpdateCurrentPosition(Position position) {
    controller.setCurrentMarker(position);
  }

  @override
  void dispose() {
    controller.stopCapturePositions();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController mapController) {
    controller.setGoogleMapController(mapController);

    controller.startCapturePositions();

    _addTrackTrace();
  }

  void _addTrackTrace() {
    if (widget.coordinates.isEmpty) {
      return;
    }

    var originAndDestinateCoordinate =
        controller.getOriginAndDestinateCoordinates;

    var originCoordinate = originAndDestinateCoordinate[0];
    var destinateCoordinate = originAndDestinateCoordinate[1];

    final originPosition =
        LatLng(originCoordinate.latitude, originCoordinate.longitude);

    final destinatePosition =
        LatLng(destinateCoordinate.latitude, destinateCoordinate.longitude);

    controller.addMarker("1_1", originPosition, BitmapDescriptor.defaultMarker);
    controller.addMarker(
        "1_2", destinatePosition, BitmapDescriptor.defaultMarkerWithHue(90));

    controller.addPolyline("1", Colors.blue.shade600, widget.coordinates);

    setState(() {});
  }

  /*_getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        Constants.GOOGLE_API_KEY,
        PointLatLng(_originLatitude, _originLongitude),
        PointLatLng(_destLatitude, _destLongitude),
        travelMode: TravelMode.driving,
        wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")]);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }*/
}
