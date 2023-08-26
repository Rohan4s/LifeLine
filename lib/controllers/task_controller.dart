import 'package:appointment/db/bd_helper.dart';
import 'package:appointment/models/task.dart';
import 'package:get/get.dart';

class TaskController extends GetxController{

  @override
  void onReady(){
    super.onReady();
  }
  var taskList=<Task>[].obs;

  Future<int>addTask({Task? task})async{
     return await DBHelper.insert(task!);
  }

  void getTasks()async{
    List<Map<String,dynamic>>tasks=await DBHelper.query();

    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
  }
  Future<List<Task?>> getTasksList()async{
    List<Map<String,dynamic>>tasks=await DBHelper.query();
    return List.generate(tasks.length, (index) => Task.fromJson(tasks[index]));
  }

  void delete(Task task){
     DBHelper.delete(task);
     getTasks();

  }
 void markTaskCompleted(int id)async{
    await DBHelper.update(id);
    getTasks();
 }
}