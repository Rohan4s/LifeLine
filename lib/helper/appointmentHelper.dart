import '../entities/task.dart';
import 'databaseHelper.dart';

class AppointmentHelper{

  static const String _appointmentTableName = 'appointment';

  static Future<int> insert(Task task)async{
    final db = await DBhelper.getDB();
    if (db == null)
      print('Failed to connect to database');
    else
      print('Connected to database');
    return await db.insert(_appointmentTableName, task.toJson())??1;

  }
  static Future<List<Map<String,dynamic>>>query()async{
    print("query funcation is call");
    final db = await DBhelper.getDB();
    if (db == null)
      print('Failed to connect to database');
    else
      print('Connected to database');

    return await db.query(_appointmentTableName);
  }
  static delete(Task task)async{

    final db = await DBhelper.getDB();
    if (db == null)
      print('Failed to connect to database');
    else
      print('Connected to database');

    return await db.delete(_appointmentTableName,where: 'id=?',whereArgs: [task.id]);
  }
  static update(int id)async{

    final db = await DBhelper.getDB();
    if (db == null)
      print('Failed to connect to database');
    else
      print('Connected to database');

    return db.rawUpdate('''
    UPDATE tasks
    SET isCompleted= ?
    WHERE id=?
    ''',[1,id]);
  }

}