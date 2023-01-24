import 'dart:io';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tracker_box/app/shared/utils/tables.dart';

final $DatabaseProvider = BindInject(
  (i) => DatabaseProvider(),
  isSingleton: true,
  isLazy: true,
);

class DatabaseProvider {
  late final Future<Database> _database;

  DatabaseProvider() {
    _database = _createDatabase();
  }

  Future<Database> get database => _database;

  Future<Database> _createDatabase() async {
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();

    final String path = join(documentsDirectory.path, "tb.db");

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE ${Tables.tableCoordinates} ("
          "id INTEGER PRIMARY KEY,"
          "trackId INTEGER,"
          "latitude REAL,"
          "longitude REAL"
          ")");

      await db.execute("CREATE TABLE ${Tables.tableTracks} ("
          "localId INTEGER PRIMARY KEY,"
          "startSpeed INTEGER,"
          "maxSpeed INTEGER,"
          "distance REAL,"
          "time INTEGER,"
          "userId TEXT,"
          "checkSum TEXT"
          ")");
    });
  }
}
