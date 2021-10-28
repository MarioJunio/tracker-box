import 'dart:typed_data';
import 'dart:ui';

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

  static Future<Uint8List> drawTrackMarkerDot(
      int width, int height, Color color) async {
    return _drawMarkerDot(width, height, color, true);
  }

  static Future<Uint8List> drawUserMarkerDot(
      int width, int height, Color color) async {
    return _drawMarkerDot(width, height, color, false);
  }

  static Future<Uint8List> _drawMarkerDot(
      int width, int height, Color color, bool hasAlpha) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Radius radius = Radius.circular(50.0);
    final double borderSize = width * 0.36;

    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
            0.0,
            0.0,
            width.toDouble(),
            height.toDouble(),
          ),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        Paint()..color = hasAlpha ? color.withOpacity(0.5) : color);

    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
            borderSize / 2,
            borderSize / 2,
            width.toDouble() - borderSize,
            height.toDouble() - borderSize,
          ),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        Paint()..color = color);

    /*TextPainter painter = TextPainter(textDirection: TextDirection.ltr);

    painter.text = TextSpan(
      text: 'Mario',
      style: TextStyle(fontSize: 25.0, color: Colors.white),
    );

    painter.layout();
    painter.paint(
        canvas,
        Offset((width * 0.5) - painter.width * 0.5,
            (height * 0.5) - painter.height * 0.5));*/

    final img = await pictureRecorder.endRecording().toImage(width, height);

    final data = await img.toByteData(format: ImageByteFormat.png);

    return data!.buffer.asUint8List();
  }
}
