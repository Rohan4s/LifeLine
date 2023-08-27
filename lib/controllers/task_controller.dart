import 'package:lifeline/helper/appointmentHelper.dart';
import 'package:lifeline/entities/task.dart';
import 'package:get/get.dart';

class TaskController extends GetxController{

  @override
  void onReady(){
    super.onReady();
  }
  var taskList=<Task>[].obs;

  Future<int>addTask({Task? task})async{
     return await AppointmentHelper.insert(task!);
  }

  void getTasks()async{
    List<Map<String,dynamic>>tasks=await AppointmentHelper.query();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
  }

  Future<List<Task?>> getTasksList()async{
    List<Map<String,dynamic>>tasks=await AppointmentHelper.query();
    return List.generate(tasks.length, (index) => Task.fromJson(tasks[index]));
  }

  void delete(Task task){
    AppointmentHelper.delete(task);
     getTasks();

  }
 void markTaskCompleted(int id)async{
    await AppointmentHelper.update(id);
    getTasks();
 }
}