import 'package:appointment/models/task.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{
  static Database?_db;
  static final int _version=1;
  static final String _tableName="tasks";
  static Future<void>initDb()async{
    if(_db !=null){
      return;
    }
    try{
      String _path=await getDatabasesPath()+'tasks.bd';
      _db=await openDatabase(
        _path,
        version: _version,
        onCreate: (db,version){
          print("creating a new one");
          return db.execute(
            "CREATE TABLE $_tableName("
                "id INTEGER PRIMARY KEY AUTOINCREMENT,"
                "title STRING ,date STRING,"
                "time STRING,remind INTEGER,"
                "isCompleted INTEGER)",
          );
        },
      );
    }catch(e){
      print(e);
    }
  }
  static Future<int> insert(Task task)async{
    print("insert funcation is call");
    return await _db?.insert(_tableName, task.toJson())??1;

  }
  static Future<List<Map<String,dynamic>>>query()async{
    print("query funcation is call");
    return await _db!.query(_tableName);
  }
  static delete(Task task)async{
    return await _db!.delete(_tableName,where: 'id=?',whereArgs: [task.id]);
  }
  static update(int id)async{
    return _db!.rawUpdate('''
    UPDATE tasks
    SET isCompleted= ?
    WHERE id=?
    ''',[1,id]);
  }

}