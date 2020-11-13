
import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

final userTable = 'userTable';

class SQLiteProvider {
  static final SQLiteProvider sqLiteProvider = SQLiteProvider();

  Database _database;

  Future<Database> get database async {
    if(_database != null) {
      return _database;
    }
    _database = await createDatabase();
    return _database;
  }

  createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "User.db");

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: initDB,
      onUpgrade: onUpgrade,
    );
    return database;
  }

  void onUpgrade(
    Database database,
    int oldVersion,
    int newVersion,
  ){
    if (newVersion > oldVersion){}
  }

  void initDB(Database database, int version) async {
    await database.execute(
      "CREATE TABLE $userTable ("
      "id INTEGER PRIMARY KEY, "
      "username TEXT, "
      "email TEXT, "
      "accessToken TEXT "
      ")"
    );
  }
}