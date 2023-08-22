import 'package:lifeline/entities/weightClass.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class WeightDBhelper {
  static const int _version = 1;
  static const String _dbName = "lifeline.db";
  static const String _tableName = 'weight';

  static Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) async => await db.execute(
            "CREATE TABLE $_tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, weight REAL NOT NULL, bmi REAL NOT NULL, date STRING,time STRING);"),
        version: _version);
  }

  //
  static Future<int> addNote(WeightClass weight) async {
    final db = await _getDB();
    if (db == null)
      print('fkyou');
    else
      print('asd');

    return await db.insert("weight", weight.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // static Future<int> updateNote(Note note) async {
  //   final db = await _getDB();
  //   return await db.update("Note", note.toJson(),
  //       where: 'id = ?',
  //       whereArgs: [note.id],
  //       conflictAlgorithm: ConflictAlgorithm.replace);
  // }

  static Future<int> deleteNote() async {
    final db = await _getDB();
    return await db.rawDelete('DELETE FROM $_tableName ');
  }
  //
  static Future<List<WeightClass>?> getAllNotes() async {
    final db = await _getDB();
    if(db==null)print('fk you');
    // else
    //   print('asd');
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM $_tableName ORDER BY date DESC,time DESC');
    // final List<Map<String, dynamic>> maps = await db.query(_tableName);

    if (maps.isEmpty) {
      print('no data found in db');
      return null;
    }

    return List.generate(maps.length, (index) => WeightClass.fromJson(maps[index]));
  }
}
