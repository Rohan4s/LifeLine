import 'package:appointment/models/medicine.dart';
import 'package:sqflite/sqflite.dart';

class DBHelperMedicine{
  static Database?_db;
  static final int _version=1;
  static final String _tableName="medicines";
  static Future<void>initDb()async{
    if(_db !=null){
      return;
    }
    try{
      String _path=await getDatabasesPath()+'medicines.db';
      _db=await openDatabase(
        _path,
        version: _version,
        onCreate: (db,version){
          print("creating a new one");
          return db.execute('''
    CREATE TABLE $_tableName (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title STRING,
    time1 STRING,
    time2 STRING,
    time3 STRING,
    remind INTEGER,
    isCompleted INTEGER
  )
''');
        },
      );
    }catch(e){
      print(e);
    }
  }
  static Future<int> insert(Medicine medicine)async{
    print("insert function is call");
    return await _db?.insert(_tableName, medicine.toJson()) ?? - 1;

  }
  // static Future<List<Map<String,dynamic>>>query()async{
  //   print("query funcation is call");
  //   return await _db1!.query(_tableName);
  // }
  static Future<List<Map<String, dynamic>>> query() async {
    try {
      print("query function is called");
      if (_db == null) {
        await initDb();
      }
      return await _db!.query(_tableName);
    } catch (e) {
      print("Error querying database: $e");
      return [];
    }
  }


  static delete(Medicine medicine)async{
    return await _db!.delete(_tableName,where: 'id=?',whereArgs: [medicine.id]);
  }
  static update(int id)async{
    return _db!.rawUpdate('''
    UPDATE tasks
    SET isCompleted= ?
    WHERE id=?
    ''',[1,id]);
  }

}