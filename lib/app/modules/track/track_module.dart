import 'package:flutter_modular/flutter_modular.dart';
import 'package:tracker_box/app/app_module.dart';
import 'package:tracker_box/app/core/repository/impl/track_repository_impl.dart';
import 'package:tracker_box/app/modules/map/map_module.dart';
import 'package:tracker_box/app/modules/track/track_controller.dart';
import 'package:tracker_box/app/modules/track/track_page.dart';

class TrackModule extends Module {
  static const String MAP_MODULE_ROUTE = "/map/";

  @override
  List<Module> imports = [
    AppModule(),
  ];

  @override
  List<Bind> get binds => [
        $TrackRepositoryImpl,
        $TrackController,
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          Modular.initialRoute,
          child: (_, args) => TrackPage(),
        ),
        ModuleRoute(
          MAP_MODULE_ROUTE,
          module: MapModule(),
        )
      ];
}
