import 'package:flutter_modular/flutter_modular.dart';
import 'package:tracker_box/app/app_module.dart';
import 'package:tracker_box/app/modules/map/map_Page.dart';
import 'package:tracker_box/app/modules/map/map_controller.dart';

class MapModule extends Module {

  @override
  List<Module> imports = [
    AppModule(),
  ];

  @override
  final List<Bind> binds = [
    $MapController,
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) {
      return MapPage();
    }),
  ];
}
