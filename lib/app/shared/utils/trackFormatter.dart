import 'package:intl/intl.dart';

class TrackFormatter {
  static String formatSpeed(int speed) {
    return "$speed km/h";
  }

  static String formatDistance(double distance, {bool showLabel = true}) {
    String unit = "metros";
    int decimalPlaces = 0;

    if (distance >= 1000) {
      distance = distance / 1000;
      unit = "km";
      decimalPlaces = 2;
    }

    return "${distance.toStringAsFixed(decimalPlaces)} ${showLabel ? unit : ''}";
  }

  static String distanceUnit(double distance) {
    return distance >= 1000 ? 'km' : 'metros';
  }

  static String formatTimer(int millis, {bool showLabel = true}) {
    int hours = millis ~/ 3600000;
    int minutes = (millis ~/ 60000) - (hours * 60);
    int seconds = (millis ~/ 1000) - (hours * 60 * 60) - (minutes * 60);
    int restMillis = (millis % 1000) ~/ 100;
    // int restMillis = (millis - (hours * 3600000) - (minutes * 60000) - (seconds * 1000)) ~/ 100;

    if (hours == 0 && minutes == 0)
      return "${_formatTime(seconds, "0")}.$restMillis${showLabel ? ' seg' : ''}";

    if (hours == 0)
      return "${_formatTime(minutes, "00")}:${_formatTime(seconds, "00")}${showLabel ? ' min' : ''}";

    return "${_formatTime(hours, "00")}:${_formatTime(minutes, "00")}:${_formatTime(seconds, "00")}";
  }

  static String timerUnit(int millis) {
    int hours = millis ~/ 3600000;
    int minutes = (millis ~/ 60000) - (hours * 60);

    if (hours == 0 && minutes == 0) return 'seg';

    if (hours == 0) return 'min';

    return 'hor';
  }

  static String _formatTime(int value, String pattern) =>
      NumberFormat(pattern).format(value);
}
