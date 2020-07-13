import 'package:intl/intl.dart';

class TrackFormatter {
  static String formatTrackDistance(double distance) {
    String distanceWithTwoDecimals = distance.toStringAsFixed(2);
    return distance >= 1000
        ? "$distanceWithTwoDecimals km"
        : "$distanceWithTwoDecimals met";
  }

  static String formatTrackTimer(int millis) {
    final NumberFormat nf = NumberFormat("00");

    int hours = millis ~/ 3600000;
    int minutes = (millis ~/ 60000) - (hours * 60);
    int seconds = (millis ~/ 1000) - (hours * 60 * 60) - (minutes * 60);
    // int restMillis = (millis - (hours * 3600000) - (minutes * 60000) - (seconds * 1000)) ~/ 100;
    int restMillis = (millis % 1000) ~/ 100;

    if (hours == 0 && minutes == 0)
      return "${_formatTime(seconds)}.$restMillis seg";

    if (hours == 0)
      return "${_formatTime(minutes)}:${_formatTime(seconds)} min";

    return "${nf.format(hours)}:${nf.format(minutes)}:${nf.format(seconds)}";
  }

  static String _formatTime(int value) => NumberFormat("00").format(value);
}
