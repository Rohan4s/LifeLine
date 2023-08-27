import 'package:lifeline/entities/Documents.dart';
import 'package:lifeline/helper/databaseHelper.dart';
import 'package:sqflite/sqflite.dart';

class PrescriptionHelper {
  static const String _prescriptionTableName = 'prescription';

  static Future<int> addPrescriptions(Document prescription) async {
    final db = await DBhelper.getDB();
    if (db == null)
      print('Failed to connect to database');
    else
      print('Connected to database');
    // return 5;
    return await db.insert(_prescriptionTableName, prescription.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updatePrescriptions(
      Document prescription, String newTitle) async {
    final db = await DBhelper.getDB();

    return await db.rawUpdate(
        'UPDATE $_prescriptionTableName SET title=? WHERE date=? AND time=?',
        [newTitle, prescription.date, prescription.time]);

    return await db.update(_prescriptionTableName, prescription.toJson(),
        where: 'time = ?',
        whereArgs: [prescription.time],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deletePrescription(Document prescription) async {
    final db = await DBhelper.getDB();
    return await db.rawDelete(
        'DELETE FROM $_prescriptionTableName '
        'WHERE title=? AND time=?',
        [prescription.title, prescription.time]);
  }

  //
  static Future<List<Document>?> getAllPrescriptions() async {
    final db = await DBhelper.getDB();
    if (db == null) print('fk you');
    // else
    //   print('asd');
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM $_prescriptionTableName ORDER BY date DESC,time DESC');
    // final List<Map<String, dynamic>> maps = await db.query(_tableName);

    if (maps.isEmpty) {
      print('no data found in db');
      return null;
    }

    return List.generate(
        maps.length, (index) => Document.fromJson(maps[index]));
  }
}
