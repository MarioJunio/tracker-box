import 'package:flutter_modular/flutter_modular.dart';
import 'package:tracker_box/app/app_controller.dart';
import 'package:tracker_box/app/core/usecase/impl/get_tracks_by_current_position_and_distance_usecase_impl.dart';
import 'package:tracker_box/app/core/usecase/impl/publish_track_usecase_impl.dart';
import 'package:tracker_box/app/modules/track/track_module.dart';
import 'package:tracker_box/app/shared/configs/http_client.dart';
import 'package:tracker_box/app/shared/database/database.dart';

import 'shared/database/repository/track_local_database_repository.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind((i) => AppController()),
        $HttpClient,
        $DatabaseProvider,
        $TrackDatabaseRepository,
        $PublishTrackUsecaseImpl,
        $GetTracksByCurrentPositionAndDistanceUsecaseImpl,
      ];

  @override
  List<ModularRoute> get routes => [
        ModuleRoute(Modular.initialRoute, module: TrackModule()),
      ];
}
