import 'package:photo_sync/models/object.dart';
import 'package:photo_sync/repository/interfaces/database_repository_interface.dart';
import 'package:sqflite/sqflite.dart';

import 'database_repository_mixin.dart';

class DatabaseRepository
    with DatabaseRepositoryMixin
    implements DatabaseRepositoryInterface {
  static const String _kDatabasePath = "/db/db.db";
  static const int _kDatabaseVersion = 1;
  bool _databaseOpened = false;
  late Database _database;

  @override
  Future<void> startDatabaseRepository() async {
    //Avoids to open the database multiple times
    //Just to be safe
    if (_databaseOpened) return;
    var databasesPath = await getDatabasesPath();
    _database = await openDatabase(
      '$databasesPath$_kDatabasePath',
      onCreate: onDatabaseCreate,
      onUpgrade: onDatabaseUpgrade,
      onConfigure: onDatabaseConfigure,
      version: _kDatabaseVersion,
    );
    _databaseOpened = true;
  }

  @override
  Future addObject(Object object) {
    // TODO: implement addObject
    throw UnimplementedError();
  }

  @override
  Future<List<Object>> getObjects() {
    // TODO: implement getObjects
    throw UnimplementedError();
  }

  @override
  Future<List<Object>> getPhotos() {
    // TODO: implement getPhotos
    throw UnimplementedError();
  }

  @override
  Future<List<Object>> getVideos() {
    // TODO: implement getVideos
    throw UnimplementedError();
  }
}
