import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:photo_sync/models/object.dart';
import 'package:photo_sync/repository/interfaces/database_repository_interface.dart';
import 'package:photo_sync/util/enums/object_type.dart';
import 'package:sqflite/sqflite.dart';

import 'database_repository_mixin.dart';

class DatabaseRepository
    with DatabaseRepositoryMixin
    implements DatabaseRepositoryInterface {
  static const String _kDatabasePath = "/main_db.db";
  static const int _kDatabaseVersion = 1;
  bool _databaseOpened = false;
  late Database _database;

  @override
  Future<void> startDatabaseRepository() async {
    //Avoids to open the database multiple times
    //Just to be safe
    if (_databaseOpened) return;
    var databasesPath = await getDatabasesPath();
    debugPrint('DbPath: $databasesPath$_kDatabasePath');
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
  Future addObject(Object object) async {
    debugPrint('Adding an object to the database');
    await _database.execute('INSERT INTO object ${object.toSql()};');
  }

  @override
  Future<List<Object>> getObjects() async {
    List<Object> objects = [];
    final objs = await _database.rawQuery('SELECT * FROM object;');
    for (var obj in objs) {
      objects.add(Object.fromDb(obj));
    }
    return objects;
  }

  @override
  Future<List<Object>> getPhotos() async {
    List<Object> objects = [];
    final objs = await _database.query('objects',
        where: 'type = ${ObjectType.picture.toValue}');
    for (var obj in objs) {
      Object.fromJson(obj);
    }
    return objects;
  }

  @override
  Future<List<Object>> getVideos() async {
    List<Object> objects = [];
    final objs = await _database.query('objects',
        where: 'type = ${ObjectType.video.toValue}');
    for (var obj in objs) {
      Object.fromJson(obj);
    }
    return objects;
  }
}
