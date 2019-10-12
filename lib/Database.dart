import 'dart:io';
import 'package:ems_oasis_19/eventsList/model/Events.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseProvider {
  // This is used to create a singleton for this class
  // This is a private constructor
  DatabaseProvider._();

  static final DatabaseProvider databaseProvider = DatabaseProvider._();
  Database _database;

  Future<Database> getDatabase() async {
    if(_database != null) {
      return _database;
    }
    _database = await initDatabase();
    return _database;
  }

  initDatabase() async {
     Directory documentsDir = await getApplicationDocumentsDirectory();
     String path = join(documentsDir.path, 'emsApp.db');
     return await openDatabase(path, version: 1, onCreate: (db, version) async {
       await db.execute('''CREATE TABLE events(
         uniqueId INTEGER PRIMARY KEY AUTOINCREMENT,
         id INTEGER ,
         name TEXT,
         maxSize INTEGER,
         minSize INTEGER,
         level INTEGER
       )''');
     });
  }

  addEvent(FinalEvents event) async {
    final db = await getDatabase();
    var map = (event as FinalEvents).toJson();
    print("Adding event = ${map.toString()}");
    var res = await db.insert('events', map, conflictAlgorithm: ConflictAlgorithm.replace);
    print("Result of Adding event = ${res.toString()}");
    return res;
  }

  getAllEvetns() async {
    final db = await getDatabase();
    var res = await db.query('events');
    print("Result of query = ${res.toString()}");
    List<FinalEvents> events = res.isNotEmpty ? res.map((event) => FinalEvents.fromJson(event)).toList() : <Event>[];
    return events;
  }
}