import 'package:flutter_modular/flutter_modular.dart';
import 'package:tracker_box/app/app_controller.dart';
import 'package:tracker_box/app/modules/track/track_module.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind((i) => AppController()),
      ];

  @override
  List<ModularRoute> get routes => [
        ModuleRoute(Modular.initialRoute, module: TrackModule()),
      ];
}
