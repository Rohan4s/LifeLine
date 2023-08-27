import 'package:flutter/material.dart';
import 'package:lifeline/entities/Documents.dart';
import 'package:lifeline/helper/databaseHelper.dart';
import 'package:sqflite/sqflite.dart';

import '../entities/user.dart';

class UserHelper{

  static const String _userTableName = 'user';

  static Future<int> addUser(User user) async {
    final db = await DBhelper.getDB();
    if (db == null)
      print('Failed to connect to database');
    else
      print('Connected to database');
    // return 5;
    return await db.insert(_userTableName, user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateHeight(String height) async {
    final db = await DBhelper.getDB();
    return await db.rawUpdate('UPDATE $_userTableName SET height=?',[height]);
  }

  // static Future<int> deleteReport(Document report) async {
  //
  //   final db = await DBhelper.getDB();
  //
  //   return await db.rawDelete('DELETE FROM $_userTableName '
  //       'WHERE title=? AND time=?',[report.title,report.time]);
  // }

  //
  static Future<List<User>?> getUser() async {
    final db = await DBhelper.getDB();
    if (db == null) print('fk you');
    // else
    //   print('asd');
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM $_userTableName');
    // final List<Map<String, dynamic>> maps = await db.query(_tableName);

    if (maps.isEmpty) {
      print('no data found in db');
      return null;
    }
    return List.generate(
        maps.length, (index) => User.fromJson(maps[index]));
  }
}