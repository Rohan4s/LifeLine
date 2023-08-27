import 'package:flutter/material.dart';
import 'package:lifeline/entities/Documents.dart';
import 'package:lifeline/helper/databaseHelper.dart';
import 'package:sqflite/sqflite.dart';

class ReportHelper{

  static const String _reportTableName = 'report';

  static Future<int> addReport(Document report) async {
    final db = await DBhelper.getDB();
    if (db == null)
      print('Failed to connect to database');
    else
      print('Connected to database');
    // return 5;
    return await db.insert(_reportTableName, report.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateReport(Document report,String newTitle) async {
    final db = await DBhelper.getDB();

    return await db.rawUpdate('UPDATE $_reportTableName SET title=? WHERE date=? AND time=?',[newTitle,report.date,report.time]);

    return await db.update(_reportTableName, report.toJson(),
        where: 'time = ?',
        whereArgs: [report.time],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteReport(Document report) async {
    final db = await DBhelper.getDB();
    return await db.rawDelete('DELETE FROM $_reportTableName '
        'WHERE title=? AND time=?',[report.title,report.time]);
  }

  //
  static Future<List<Document>?> getAllReports() async {
    final db = await DBhelper.getDB();
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
        maps.length, (index) => Document.fromJson(maps[index]));
  }
}