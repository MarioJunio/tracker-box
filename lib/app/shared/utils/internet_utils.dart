import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class InternetUtils {
  static Future<bool> hasConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> hasInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return checkInternetConnection(connectivityResult);
  }

  static bool checkInternetConnection(ConnectivityResult result) {
    return [ConnectivityResult.mobile, ConnectivityResult.wifi]
        .contains(result);
  }
}
