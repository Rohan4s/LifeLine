import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart'as tz;

class NotifyHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initializeNotification() async {
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings("appi");


    final InitializationSettings initializationSettings = InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: selectNotification,
    );
   }



   Future onDidReceiveLocalNotification(
       int id,String? title,String? body,String? payload) async{
    // showDialog(
    //   builder: (BuildContext context)=>CupertinoAlertDialog(
    //     title: Text(title),
    //     content: Text(body),
    //     actions: [
    //       CupertinoDialogAction(
    //         isDefaultAction: true,
    //         child: Text('ok'),
    //         onPressed: () async{
    //           Navigator.of(context,rootNavigator: true).pop();
    //           await Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //                 builder:(context)=>SecondScreen(payload),
    //             )
    //           );
    //         },
    //       )
    //     ],
    //   )
    // );
     Get.dialog(Text("welcome "));
   }

   Future selectNotification(String? payload) async{
    if(payload != null){
      print("notification payload :$payload");
    }else{
      print("Notification done");
    }
    Get.to(()=>Container(color: Colors.white,));
   }

   void requestISOPermissions(){
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      alert: true,
      badge: true,
      sound: true
    );
   }
   scheduledNotification()async{
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        "schedule title",
        "theme changes",
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
          android: AndroidNotificationDetails("channelId", "channelName")
        ),
        androidAllowWhileIdle:true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
   }
  }