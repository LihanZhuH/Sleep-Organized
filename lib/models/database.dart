import 'package:path/path.dart';
import 'package:sleep_organized/models/sleep.dart';
import 'package:sqflite/sqflite.dart';

/*
  Singleton for database access.
 */
class MyDatabase {
  // make this a singleton class
  MyDatabase._privateConstructor();
  static final MyDatabase instance = MyDatabase._privateConstructor();

  // A single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // Opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    return await openDatabase(
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

  /*
    Inserts one sleep object.
   */
  Future<void> insertSleep(Sleep sleep) async {
    await _database.insert(
      'sleeps',
      sleep.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /*
    Gets all sleeps.
   */
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

  /*
    Gets all sleeps within a week.
   */
  Future<List<Sleep>> sleepsThisWeek() async {
    int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
    int weekLength = 1000 * 60 * 60 * 24 * 7;
    final List<Map<String, dynamic>> maps = await _database.rawQuery(
      "SELECT * FROM 'sleeps' WHERE $currentTimestamp - start < $weekLength"
    );

    return List.generate(maps.length, (i) {
      return Sleep(
        id: maps[i]['id'],
        start: maps[i]['start'],
        end: maps[i]['end'],
      );
    });
  }
}