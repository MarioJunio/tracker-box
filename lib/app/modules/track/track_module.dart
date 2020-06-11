import 'package:flutter_modular/flutter_modular.dart';
import 'package:tracker_box/app/modules/track/track_controller.dart';
import 'package:tracker_box/app/modules/track/track_page.dart';

class TrackModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => TrackController()),
      ];

  @override
  List<Router> get routers => [
        Router(Modular.initialRoute, child: (_, args) => TrackPage()),
      ];

  static Inject get to => Inject<TrackModule>.of();
}
