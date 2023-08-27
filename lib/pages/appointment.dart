
import 'dart:async';
import 'package:lifeline/controllers/task_controller.dart';
import 'package:lifeline/entities/task.dart';
import 'package:lifeline/pages/addAppointment.dart';
import 'package:lifeline/widgets/button.dart';
import 'package:lifeline/widgets/task_tile.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lifeline/services/notifications.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class AppHomePage extends StatefulWidget {
  const AppHomePage({Key? key}) : super(key: key);

  @override
  _AppHomePageState createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage> {
  bool minutePassed = false;
  late List<Task?> taskList = [Task(time: '129')];
  late final _taskController;

  void initState() {
    super.initState();
    Noti.initialize(flutterLocalNotificationsPlugin);
    _taskController = Get.put(TaskController());
    getTasks();
  }

  Future getTasks() async {
    List<Task?> lists = await _taskController.getTasksList();
    setState(() {
      taskList = lists;
    });
  }

  DateTime _selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    // print(taskList[0]!.time);
    //
    // Timer.periodic(Duration(seconds: 5), (timer) {
    //   String now = DateFormat('hh:mm a').format(DateTime.now());
    //   print(now);
    //   for (int i = 0; i < taskList.length; i++) {
    //     print(taskList[i]!.time);
    //     // print(now);
    //     print(taskList[i]!.time==now);
    //     if (now == taskList[i]!.time) {
    //       setState(() {
    //         minutePassed = true;
    //       });
    //       break;
    //     }
    //   }
    // });
    // if (minutePassed) {
    //   Noti.showBigTextNotification(
    //       title: 'asd', body: 'asd', fln: flutterLocalNotificationsPlugin);
    //
    //   setState(() {
    //     minutePassed = false;
    //   });
    // }
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          _addTaskbar(),
          Container(
            margin: const EdgeInsets.only(top: 20, left: 20),
            child: DatePicker(
              DateTime.now(),
              height: 100,
              width: 80,
              initialSelectedDate: DateTime.now(),
              selectionColor: Colors.blueAccent,
              selectedTextColor: Colors.white,
              dateTextStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
              dayTextStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
              monthTextStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
              onDateChange: (date) {
                _selectedDate = date;
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          _showTasks()
        ],
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index) {
              print(_taskController.taskList.length);
              //make here a schuldue notification
              Task task = Task();
              print(task.time);
              //final task =_taskController.taskList[index];

              return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(
                                  context, _taskController.taskList[index]);
                            },
                            child: TaskTile(_taskController.taskList[index]),
                          )
                        ],
                      ),
                    ),
                  ));
            });
      }),
    );
  }

  _addTaskbar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Today",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                )
              ],
            ),
          ),
          MyButton(
              label: "+ Appointment",
              onTap: () async {
                await Get.to(AddTaskPage());
                getTasks();

                _taskController.getTasks();
              })
        ],
      ),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        // height: task.isCompleted == 1
        //     ? MediaQuery.of(context).size.height * .24
        //     : MediaQuery.of(context).size.height * .35,
        height: MediaQuery.of(context).size.height*.24,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[300],
              ),
            ),
            // Spacer(),
            // task.isCompleted == 1
            //     ? Container()
            //     : _bottomSheetButton(
            //   label: "Completed",
            //   onTap: () {
            //     _taskController.markTaskCompleted(task.id!);
            //     Get.back();
            //   },
            //   clr: Colors.blue,
            //   context: context,
            // )
            // ,
            _bottomSheetButton(
              label: "Delete",
              onTap: () {
                _taskController.delete(task);
                Get.back();
              },
              clr: Colors.red[900]!,
              context: context,
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 20,
            ),
            _bottomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              clr: Colors.red[900]!,
              isClose: true,
              context: context,
            ),
          ],
        ),
      ),
    );
  }

  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose == true ? Colors.red : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )
                : TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}







// import 'package:lifeline/controllers/task_controller.dart';
// import 'package:lifeline/entities/task.dart';
// import 'package:lifeline/pages/addAppointment.dart';
// import 'package:lifeline/widgets/button.dart';
// import 'package:lifeline/widgets/task_tile.dart';
// import 'package:date_picker_timeline/date_picker_timeline.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
// import 'package:intl/intl.dart';
// import 'package:get/get.dart';
//
//
// class AppHomePage extends StatefulWidget {
//   const AppHomePage({Key? key}) : super(key: key);
//
//   @override
//   _AppHomePageState createState() => _AppHomePageState();
// }
//
// class _AppHomePageState extends State<AppHomePage> {
//   DateTime _selectedDate =DateTime.now();
//   final _taskController =Get.put(TaskController());
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(
//         children: [
//           _addTaskbar(),
//           Container(
//             margin: const EdgeInsets.only(top: 20,left: 20),
//             child: DatePicker(
//               DateTime.now(),
//               height: 100,
//               width: 80,
//               initialSelectedDate: DateTime.now(),
//               selectionColor: Colors.blueAccent,
//               selectedTextColor: Colors.white,
//               dateTextStyle: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey,
//               ),
//               dayTextStyle: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey,
//               ),
//               monthTextStyle: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey,
//               ),
//               onDateChange: (date){
//                 _selectedDate=date;
//               },
//             ),
//           ),
//           SizedBox(height: 10,),
//           _showTasks()
//         ],
//       ),
//     );
//   }
//   _showTasks(){
//     return Expanded(
//       child: Obx((){
//         return ListView.builder(
//             itemCount: _taskController.taskList.length,
//             itemBuilder: (_,index){
//               print(_taskController.taskList.length);
//               //make here a schuldue notification
//               // NotifyHelper notifyHelper=NotifyHelper();
//               // notifyHelper.scheduledNotification(
//
//               // );
//
//
//               return  AnimationConfiguration.staggeredList(
//                   position: index,
//                   child: SlideAnimation(
//                     child: FadeInAnimation(
//                       child: Row(
//                         children: [
//                           GestureDetector(
//                             onTap: (){
//                               _showBottomSheet(context,_taskController.taskList[index]);
//                             },
//                             child: TaskTile(_taskController.taskList[index]),
//                           )
//                         ],
//                       ),
//                     ),
//                   )
//               );
//
//             });
//       }),
//     );
//   }
//
//   _addTaskbar()  {
//     return Container(
//       margin: const EdgeInsets.only(left: 20,right: 20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(DateFormat.yMMMMd().format(DateTime.now()),
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 Text("Today",
//                   style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.w900,
//                   ),
//                 )
//               ],
//             ),
//           ),
//           MyButton(label: "+ Appointment",onTap: ()async{
//             await Get.to(AddTaskPage());
//             _taskController.getTasks();
//           }
//           )],
//       ),
//     );
//   }
//   _showBottomSheet(BuildContext context,Task task){
//     Get.bottomSheet(
//       Container(
//         padding: const EdgeInsets.only(top: 4),
//         height:task.isCompleted==1
//             ?MediaQuery.of(context).size.height*.24:
//         MediaQuery.of(context).size.height*.35,
//         color: Colors.white,
//         child: Column(
//           children: [
//             Container(
//               height: 6,
//               width: 120,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.grey[300],
//               ),
//             ),
//             Spacer(),
//             task.isCompleted==1
//                 ?Container()
//                 :_bottomSheetButton(
//               label:"Completed",
//               onTap:(){
//                 _taskController.markTaskCompleted(task.id!);
//                 Get.back();
//               },
//               clr:Colors.deepPurple,
//               context:context,
//             ),
//
//             _bottomSheetButton(
//               label:"Delete",
//               onTap:(){
//                 _taskController.delete(task);
//                 Get.back();
//               },
//               clr:Colors.red[900]!,
//               context:context,
//             ),
//             SizedBox(height: 20,),
//             SizedBox(height: 20,),
//             _bottomSheetButton(
//               label:"Close",
//               onTap:(){
//                 Get.back();
//               },
//               clr:Colors.red[900]!,
//               isClose:true,
//               context:context,
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
//   _bottomSheetButton({
//     required String label,
//     required Function()? onTap,
//     required Color clr,
//     bool isClose=false,
//     required BuildContext  context,
//
//   }){
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 4),
//         height: 55,
//         width: MediaQuery.of(context).size.width,
//         decoration: BoxDecoration(
//           border: Border.all(
//             width: 2,
//             color: isClose==true?Colors.red:clr,
//           ),
//           borderRadius: BorderRadius.circular(20),
//           color: isClose==true?Colors.transparent:clr,
//
//         ),
//         child: Center(
//           child: Text(
//             label,
//             style: isClose?TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ):TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//
//     );
//   }
//
// }
//
//
//
