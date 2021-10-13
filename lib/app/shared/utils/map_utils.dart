import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracker_box/app/core/model/coordinate.dart';

class MapUtils {
  static List<LatLng> toPolylineCoordinates(List<Coordinate> coordinates) =>
      coordinates
          .map(
              (coordinate) => LatLng(coordinate.latitude, coordinate.longitude))
          .toList();

  static Marker createMarker(
          MarkerId id, LatLng position, BitmapDescriptor bitmapDescriptor) =>
      Marker(markerId: id, icon: bitmapDescriptor, position: position);

  static Polyline createPolyline(
          PolylineId id, Color color, List<Coordinate> coordinates) =>
      Polyline(
        polylineId: id,
        color: Colors.red,
        points: MapUtils.toPolylineCoordinates(coordinates),
      );
}
