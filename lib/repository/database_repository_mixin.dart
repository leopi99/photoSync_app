import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

mixin DatabaseRepositoryMixin {
  @protected
  Future<void> onDatabaseCreate(Database db, int version) async {}

  @protected
  Future<void> onDatabaseUpgrade(
      Database db, int previousVersion, int currentVersion) async {}

  @protected
  Future<void> onDatabaseConfigure(Database db) async {}
}
