import 'package:lifeline/entities/weightClass.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../entities/reportClass.dart';

class DBhelper {
  static const int _version = 1;
  static const String _dbName = "lifeline.db";
  static const String _reportTableName = 'report';
  static const String _weightTableName = 'weight';


  static Future<Database> getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE $_weightTableName(id INTEGER PRIMARY KEY AUTOINCREMENT, weight REAL NOT NULL, bmi REAL NOT NULL, date STRING, time STRING);",
        );

        await db.execute(
          "CREATE TABLE $_reportTableName(id INTEGER PRIMARY KEY AUTOINCREMENT,title STRING, date STRING, time STRING, image STRING);",
        );

      },
      version: _version,
    );
  }


  //reportDB
  //
  static Future<int> addReport(ReportClass report) async {
    final db = await getDB();
    if (db == null)
      print('Failed to connect to database');
    else
      print('Connected to database');
    // return 5;
    return await db.insert(_reportTableName, report.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateReport(ReportClass report,String newTitle) async {
    final db = await getDB();

    return await db.rawUpdate('UPDATE $_reportTableName SET title=? WHERE date=? AND time=?',[newTitle,report.date,report.time]);

    return await db.update(_reportTableName, report.toJson(),
        where: 'time = ?',
        whereArgs: [report.time],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteReport(ReportClass report) async {
    final db = await getDB();
    return await db.rawDelete('DELETE FROM $_reportTableName '
        'WHERE title=? AND time=?',[report.title,report.time]);
  }

  //
  static Future<List<ReportClass>?> getAllReports() async {
    final db = await getDB();
    if (db == null) print('fk you');
    // else
    //   print('asd');
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM $_reportTableName ORDER BY date DESC,time DESC');
    // final List<Map<String, dynamic>> maps = await db.query(_tableName);

    if (maps.isEmpty) {
      print('no data found in db');
      return null;
    }

    return List.generate(
        maps.length, (index) => ReportClass.fromJson(maps[index]));
  }

// WeightDB
  static Future<int> addWeight(WeightClass weight) async {
    final db = await getDB();
    if (db == null)
      print('fkyou');
    else
      print('asd');

    return await db.insert("weight", weight.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteAllWeights() async {
    final db = await getDB();
    return await db.rawDelete('DELETE FROM $_weightTableName ');
  }

  //
  static Future<List<WeightClass>?> getAllWeights() async {
    final db = await getDB();
    if (db == null) print('fk you');
    // else
    //   print('asd');
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM $_weightTableName ORDER BY date DESC,time DESC');
    // final List<Map<String, dynamic>> maps = await db.query(_tableName);

    if (maps.isEmpty) {
      print('no data found in db');
      return null;
    }

    return List.generate(
        maps.length, (index) => WeightClass.fromJson(maps[index]));
  }
}
