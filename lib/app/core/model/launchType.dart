enum LaunchType { speed, distance, time }

class LaunchTypeDescription {
  static String getDescription(LaunchType type) {

    switch (type) {
      case LaunchType.speed:
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
