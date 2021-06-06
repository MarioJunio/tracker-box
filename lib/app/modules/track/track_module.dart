import 'package:flutter_modular/flutter_modular.dart';
import 'package:tracker_box/app/modules/track/track_controller.dart';
import 'package:tracker_box/app/modules/track/track_page.dart';

class TrackModule extends Module {
  @override
  List<Bind> get binds => [
        Bind((i) => TrackController()),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(Modular.initialRoute, child: (_, args) => TrackPage()),
      ];
}
