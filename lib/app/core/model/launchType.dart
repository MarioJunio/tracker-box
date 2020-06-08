enum LaunchType { km_h, distance, time }

class LaunchTypeDescription {
  static String getDescription(LaunchType type) {

    switch (type) {
      case LaunchType.km_h:
        return "Km/h";

      case LaunchType.distance:
        return "Distância";

      case LaunchType.time:
        return "Tempo";

      default: 
        return "N/A";
    }
  }
}
