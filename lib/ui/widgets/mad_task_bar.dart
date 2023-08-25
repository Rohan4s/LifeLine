import 'package:appointment/controllers/med_controller.dart';
import 'package:appointment/models/medicine.dart';
import 'package:appointment/ui/widgets/button.dart';
import 'package:appointment/ui/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddMedPage extends StatefulWidget {
  const AddMedPage({Key? key}) : super(key: key);

  @override
  _AddMedPageState createState() => _AddMedPageState();
}

class _AddMedPageState extends State<AddMedPage> {
  final MedicineController _taskController = Get.put(MedicineController());
  final TextEditingController _titleController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _Time1 = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _Time2 = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _Time3 = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindList = [
    5,
    10,
    15,
    20,
  ];
  bool? isChecked1 = false;
  bool? isChecked2 = false;
  bool? isChecked3 = false;
  var count = 0;

  @override
  Widget build(BuildContext context) {
    // List<Widget> timeList = [];
    // for (int i = 0; i < count; i++) {
    //   timeList.add(
    //     MyInputField(
    //         title: "Time",
    //         hint: _Time,
    //         widget: IconButton(
    //             onPressed: () {
    //               _getTimeFromUser(isTime: true);
    //             },
    //             icon: Icon(
    //               Icons.access_time_rounded,
    //             ))),
    //   );
    // }

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "+ Medicine",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              MyInputField(
                title: "Medcine Name",
                hint: "Enter your medcine name",
                controller: _titleController,
              ),
              MyInputField(
                title: "BreakFast",
                hint:_Time1,
                widget: IconButton(
                  onPressed: (){
                    _getTime1FromUser(isTime:true);
                  },
                  icon: Icon(
                    Icons.access_time_rounded,
                  ),
                ),
              ),
              MyInputField(
                title: "Lunch",
                hint:_Time2,
                widget: IconButton(
                  onPressed: (){
                    _getTime2FromUser(isTime:true);
                  },
                  icon: Icon(
                    Icons.access_time_rounded,
                  ),
                ),
              ),
              MyInputField(
                title: "dinner",
                hint:_Time3,
                widget: IconButton(
                  onPressed: (){
                    _getTime3FromUser(isTime:true);
                  },
                  icon: Icon(
                    Icons.access_time_rounded,
                  ),
                ),
              ),


              MyInputField(
                title: "Remind Me",
                hint: "$_selectedRemind minute early",
                widget:DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  underline: Container(height: 0,),
                  onChanged: (String? newValue){
                    setState(() {
                      _selectedRemind=int.parse(newValue!);
                    });
                  },
                  items: remindList.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
              ),
              // CheckboxListTile(
              //   title: Text("Lunch"), //    <-- label
              //   value: isChecked2,
              //   onChanged: (bool? newValue) {
              //     setState(() {
              //       isChecked2 = newValue;
              //     });
              //   },
              // ),
              // CheckboxListTile(
              //   title: Text("dinner"), //    <-- label
              //   value: isChecked3,
              //   onChanged: (bool? newValue) {
              //     setState(() {
              //       isChecked3 = newValue;
              //     });
              //   },
              // ),
              SizedBox(
                height: 30,
              ),
              // Text(
              //   "Custom",
              // ),
              // MyButton(
              //     label: "addmoreTime",
              //     onTap: () => {
              //       setState(() {
              //         count++;
              //         print(count);
              //       }),
              //     }),
              // if (count > 0) {
              //   _addTimeField(), // Remove the curly braces
              // },
              // ...timeList,
              SizedBox(
                height: 20,
              ),

              // Expanded(child: ListView.builder(itemBuilder: (context,index){
              //   return ListTile(
              //     title: Text(_Time1),
              //   );
              // })),
              SizedBox(
                height: 30,
              ),
              MyButton(label: "Create", onTap: () => _validateDate()),
            ],
          ),
        ),
      ),
    );
  }

  _getTime1FromUser({required bool isTime}) async {
    var pickedTime = await _showTime1Picker();
    String _formatedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print("time cancle");
    } else if (isTime) {
      setState(() {
        _Time1 = _formatedTime;
      });
    }
  }

  _showTime1Picker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_Time1.split(":")[0]),
        minute: int.parse(_Time1.split(":")[1].split(" ")[0]),
      ),
    );
  }
  _getTime2FromUser({required bool isTime}) async {
    var pickedTime = await _showTime2Picker();
    String _formatedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print("time cancle");
    } else if (isTime) {
      setState(() {
        _Time2 = _formatedTime;
      });
    }
  }

  _showTime2Picker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_Time2.split(":")[0]),
        minute: int.parse(_Time2.split(":")[1].split(" ")[0]),
      ),
    );
  }
  _getTime3FromUser({required bool isTime}) async {
    var pickedTime = await _showTime3Picker();
    String _formatedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print("time cancle");
    } else if (isTime) {
      setState(() {
        _Time3 = _formatedTime;
      });
    }
  }

  _showTime3Picker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_Time3.split(":")[0]),
        minute: int.parse(_Time3.split(":")[1].split(" ")[0]),
      ),
    );
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty) {
      //add to database
      _addTaskToBd();
      Get.back();
    } else if (_titleController.text.isEmpty) {
      Get.snackbar(
        "Require",
        "all fields are need to ffill",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        icon: Icon(Icons.warning_amber_rounded),
      );
    }
  }

  _addTaskToBd() async {
    int value = await _taskController.addMedicine(
        medicine: Medicine(
          title: _titleController.text,
          time1:  _Time1,
          time2 : _Time2 ,
          time3 : _Time3,
          remind: _selectedRemind,
          isCompleted: 0,
        ));
    print("my id is" + "$value");
  }

  // Widget _addTimeField() {
  //   return (MyInputField(
  //     title: "time",
  //     hint: _Time,
  //     widget: IconButton(
  //       onPressed: () {
  //         _getTimeFromUser(isTime: true);
  //       },
  //       icon: Icon(
  //         Icons.access_time_rounded,
  //       ),
  //     ),
  //   ));
  // }
}
