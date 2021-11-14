import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

mixin DatabaseRepositoryMixin {
  @protected
  Future<void> onDatabaseCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE object (
  local_path text NOT NULL,
  creation_date varchar(30) NOT NULL,
  picture_position text NOT NULL,
  type varchar(12) NOT NULL,
  extension varchar(6) NOT NULL,
  local_id int(11) NOT NULL
)
    ''');
  }

  @protected
  Future<void> onDatabaseUpgrade(
      Database db, int previousVersion, int currentVersion) async {}

  @protected
  Future<void> onDatabaseConfigure(Database db) async {}
}
