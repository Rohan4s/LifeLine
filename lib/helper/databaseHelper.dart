import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../entities/Documents.dart';

class DBhelper {
  static const int _version = 4;
  static const String _dbName = "lifeline.db";
  static const String _reportTableName = 'report';
  static const String _weightTableName = 'weight';
  static const String _prescriptionTableName = 'prescription';
  static const String _pressureTableName = 'pressure';
  static const String _medicineTableName = 'medicine';
  static const String _taskTableName = 'appointment';
  static const String _userTableName = 'user';

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
        await db.execute(
          "CREATE TABLE $_prescriptionTableName("
              "id INTEGER PRIMARY KEY AUTOINCREMENT,"
              "title STRING,"
              " date STRING,"
              " time STRING,"
              " image STRING);",
        );
        await db.execute(
          "CREATE TABLE $_pressureTableName("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "systolicPressure INTEGER,"
          " diastolicPressure INTEGER,"
          " pulse INTEGER,"
          " date STRING, "
          "time STRING"
          ");",
        );
        await db.execute('''
    CREATE TABLE $_medicineTableName (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title STRING,
    time1 STRING,
    time2 STRING,
    time3 STRING,
    remind INTEGER,
    isCompleted INTEGER
  );''');
        await db.execute(
          "CREATE TABLE $_taskTableName("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "title STRING ,date STRING,"
          "time STRING,remind INTEGER,"
          "isCompleted INTEGER)",
        );
        await db.execute(
          "CREATE TABLE $_userTableName("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "name STRING ,"
          "height REAL NOT NULL,"
          "email STRING,"
          "age INTEGER)",
        );
      },
      version: _version,
    );
  }

  //prescriptionDB

  //
  // static Future<int> addPrescription(Document document) async {
  //   final db = await getDB();
  //   if (db == null)
  //     print('Failed to connect to database');
  //   else
  //     print('Connected to database');
  //   // return 5;
  //   return await db.insert(_prescriptionTableName, document.toJson(),
  //       conflictAlgorithm: ConflictAlgorithm.replace);
  // }
  //
  // static Future<int> updatePrescription(Document prescription,String newTitle) async {
  //   final db = await getDB();
  //
  //   return await db.rawUpdate('UPDATE $_prescriptionTableName SET title=? WHERE date=? AND time=?',[newTitle,prescription.date,prescription.time]);
  //
  //   // return await db.update(_reportTableName, report.toJson(),
  //   //     where: 'time = ?',
  //   //     whereArgs: [report.time],
  //   //     conflictAlgorithm: ConflictAlgorithm.replace);
  // }
  //
  // static Future<int> deletePrescription(Document prescription) async {
  //   final db = await getDB();
  //   return await db.rawDelete('DELETE FROM $_prescriptionTableName '
  //       'WHERE title=? AND time=?',[prescription.title,prescription.time]);
  // }
  //
  // //
  // static Future<List<Document>?> getAllPrescription() async {
  //   final db = await getDB();
  //   if (db == null) print('fk you');
  //   // else
  //   //   print('asd');
  //   final List<Map<String, dynamic>> maps = await db.rawQuery(
  //       'SELECT * FROM $_prescriptionTableName ORDER BY date DESC,time DESC');
  //   // final List<Map<String, dynamic>> maps = await db.query(_tableName);
  //
  //   if (maps.isEmpty) {
  //     print('no data found in db');
  //     return null;
  //   }
  //
  //   return List.generate(
  //       maps.length, (index) => Document.fromJson(maps[index]));
  // }

// WeightDB
//   static Future<int> addWeight(WeightClass weight) async {
//     final db = await getDB();
//     if (db == null)
//       print('fkyou');
//     else
//       print('asd');
//
//     return await db.insert("weight", weight.toJson(),
//         conflictAlgorithm: ConflictAlgorithm.replace);
//   }
//
//   static Future<int> deleteAllWeights() async {
//     final db = await getDB();
//     return await db.rawDelete('DELETE FROM $_weightTableName ');
//   }
//
//   //
//   static Future<List<WeightClass>?> getAllWeights() async {
//     final db = await getDB();
//     if (db == null) print('fk you');
//     // else
//     //   print('asd');
//     final List<Map<String, dynamic>> maps = await db.rawQuery(
//         'SELECT * FROM $_weightTableName ORDER BY date DESC,time DESC');
//     // final List<Map<String, dynamic>> maps = await db.query(_tableName);
//
//     if (maps.isEmpty) {
//       print('no data found in db');
//       return null;
//     }
//
//     return List.generate(
//         maps.length, (index) => WeightClass.fromJson(maps[index]));
//   }
}
