import 'package:flutter_modular/flutter_modular.dart';
import 'package:tracker_box/app/modules/map/map_Page.dart';
import 'package:tracker_box/app/modules/map/map_controller.dart';

class MapModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => MapController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) {
      return MapPage();
    }),
  ];
}
