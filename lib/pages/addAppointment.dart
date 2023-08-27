import 'package:lifeline/controllers/task_controller.dart';
import 'package:lifeline/entities/task.dart';
import 'package:lifeline/widgets/button.dart';
import 'package:lifeline/widgets/button.dart';

// import 'package:appointment/ui/widgets/button.dart';

import 'package:lifeline/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController =Get.put(TaskController());
  final TextEditingController _titleController =TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _Time=DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind =5;
  List<int> remindList=[
    5,
    10,
    15,
    20,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(),
      body: Container(
        padding: const EdgeInsets.only(left: 20,right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Add Appointment",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              MyInputField(title:"Dr Name", hint: "Enter your Dr name",controller: _titleController,),
              MyInputField(title: "Date", hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  icon:Icon(Icons.calendar_today_outlined),
                  onPressed: () {
                    _getDateFromUser();
                  },
                ),
              ),
              MyInputField(
                title: "Time",
                hint:_Time,
                widget: IconButton(
                  onPressed: (){
                    _getTimeFromUser(isTime:true);
                  },
                  icon: Icon(
                    Icons.access_time_rounded,
                  ),
                ),
              ),
              // MyInputField(
              //   title: "Remind Me",
              //   hint: "$_selectedRemind hours early",
              //   widget:DropdownButton(
              //     icon: Icon(Icons.keyboard_arrow_down,
              //     ),
              //     iconSize: 32,
              //     elevation: 4,
              //     style: TextStyle(
              //       fontSize: 14,
              //       fontWeight: FontWeight.w500,
              //     ),
              //     underline: Container(height: 0,),
              //     onChanged: (String? newValue){
              //       setState(() {
              //         _selectedRemind=int.parse(newValue!);
              //       });
              //     },
              //     items: remindList.map<DropdownMenuItem<String>>((int value) {
              //       return DropdownMenuItem<String>(
              //         value: value.toString(),
              //         child: Text(value.toString()),
              //       );
              //     }).toList(),
              //   ),
              // ),
              SizedBox(height: 30,),
              MyButton(label: "Create", onTap: ()=>_validateDate()),
            ],
          ),
        ),
      ),

    );
  }
  _getDateFromUser()async{
    DateTime? _pickerDate =await showDatePicker(
        context: context,
        initialDate: DateTime.now() ,
        firstDate: DateTime(2015),
        lastDate: DateTime(2025)
    );
    if(_pickerDate !=null){
      setState(() {
        _selectedDate = _pickerDate;
        print(_selectedDate);
      });
    }
    else{
      print("its null");
    }
  }

  _getTimeFromUser({required bool isTime}) async {
    var pickedTime= await _showTimePicker();
    String _formatedTime=pickedTime.format(context);
    if(pickedTime==null){
      print("time cancle");
    }
    else if(isTime){
      setState(() {
        _Time=_formatedTime;
      });
    }

  }
  _showTimePicker(){
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(

        hour: int.parse(_Time.split(":")[0]),
        minute: int.parse(_Time.split(":")[1].split(" ")[0]),

      ),
    );
  }
  _validateDate(){
    if(_titleController.text.isNotEmpty){
      //add to database
      _addTaskToBd();
      Get.back();
    }
    else if(_titleController.text.isEmpty){
      Get.snackbar("Require", "all fields are need to ffill",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        icon: Icon(Icons.warning_amber_rounded),
      );
    }
  }
  _addTaskToBd()async{
    int value= await _taskController.addTask(
        task:Task(
          title :_titleController.text,
          date : DateFormat.yMd().format(_selectedDate),
          time : _Time,
          remind :_selectedRemind,
          isCompleted :0,
        )
    );
    print("my id is"+"$value");
  }
}
