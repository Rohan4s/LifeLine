
import 'package:appointment/controllers/med_controller.dart';
import 'package:appointment/models/medicine.dart';
import 'package:appointment/services/notification_services.dart';
import 'package:appointment/ui/widgets/button.dart';
import 'package:appointment/ui/widgets/mad_task_bar.dart';
import 'package:appointment/ui/widgets/mad_task_tile.dart';

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';


class MedHomePage extends StatefulWidget {
  const MedHomePage({Key? key}) : super(key: key);

  @override
  _MedHomePageState createState() => _MedHomePageState();
}

class _MedHomePageState extends State<MedHomePage> {
  DateTime _selectedDate =DateTime.now();
  final _medicineController =Get.put(MedicineController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          _addTaskbar(),
          Container(
            margin: const EdgeInsets.only(top: 20,left: 20),
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
              onDateChange: (date){
                _selectedDate=date;
              },
            ),
          ),
          SizedBox(height: 10,),
          _showTasks()
        ],
      ),
    );
  }
  _showTasks(){
    return Expanded(
      child: Obx((){
        return ListView.builder(
            itemCount: _medicineController.medicineList.length,

            itemBuilder: (_,index){
              print(_medicineController.medicineList.length);
             // NotifyHelper notifyHelper=NotifyHelper();
              //notifyHelper.scheduledNotification(

              // )

              return  AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              _showBottomSheet(context,_medicineController.medicineList[index]);
                            },
                            child: MedicineTile(_medicineController.medicineList[index]),
                          )
                        ],
                      ),
                    ),
                  )
              );

            });
      }),
    );
  }

  _addTaskbar()  {
    return Container(
      margin: const EdgeInsets.only(left: 20,right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat.yMMMMd().format(DateTime.now()),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text("Today",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                )
              ],
            ),
          ),
          MyButton(label: "+ Medicine",onTap: ()async{
            await Get.to(AddMedPage());
            _medicineController.getMedicines();
          }
          )],
      ),
    );
  }
  _showBottomSheet(BuildContext context,Medicine medicine){
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height:medicine.isCompleted==1
            ?MediaQuery.of(context).size.height*.24:
        MediaQuery.of(context).size.height*.35,
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
            Spacer(),
            medicine.isCompleted==1
                ?Container()
                :_bottomSheetButton(
              label:"Completed",
              onTap:(){
                _medicineController.markTaskCompleted(medicine.id!);
                Get.back();
              },
              clr:Colors.deepPurple,
              context:context,
            ),

            _bottomSheetButton(
              label:"Delete",
              onTap:(){
                _medicineController.delete(medicine);
                Get.back();
              },
              clr:Colors.red[900]!,
              context:context,
            ),
            SizedBox(height: 20,),
            SizedBox(height: 20,),
            _bottomSheetButton(
              label:"Close",
              onTap:(){
                Get.back();
              },
              clr:Colors.red[900]!,
              isClose:true,
              context:context,
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
    bool isClose=false,
    required BuildContext  context,

  }){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width*0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose==true?Colors.red:clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose==true?Colors.transparent:clr,

        ),
        child: Center(
          child: Text(
            label,
            style: isClose?TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ):TextStyle(
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





