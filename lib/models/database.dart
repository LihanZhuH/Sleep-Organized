import 'package:path/path.dart';
import 'package:sleep_organized/models/sleep.dart';
import 'package:sqflite/sqflite.dart';

/*
  Singleton for database access.
 */
class MyDatabase {
  static final MyDatabase _instance = MyDatabase._internal();

  Database _database;

  factory MyDatabase() {
    return _instance;
  }

  MyDatabase._internal();

  Future<void> setup() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'sleeps_database.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          "CREATE TABLE sleeps(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, start INTEGER, end INTEGER)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertSleep(Sleep sleep) async {
    await _database.insert(
      'sleeps',
      sleep.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Sleep>> sleeps() async {
    final List<Map<String, dynamic>> maps = await _database.query('sleeps');

    return List.generate(maps.length, (i) {
      return Sleep(
        id: maps[i]['id'],
        start: maps[i]['start'],
        end: maps[i]['end'],
      );
    });
  }
}