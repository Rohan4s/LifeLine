// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:timezone/timezone.dart'as tz;
//
// class NotifyHelper {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   Future<void> initializeNotification() async {
//     final IOSInitializationSettings initializationSettingsIOS =
//     IOSInitializationSettings(
//       requestSoundPermission: false,
//       requestBadgePermission: false,
//       requestAlertPermission: false,
//       onDidReceiveLocalNotification: onDidReceiveLocalNotification,
//     );
//
//     final AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings("appi");
//
//
//     final InitializationSettings initializationSettings = InitializationSettings(
//       iOS: initializationSettingsIOS,
//       android: initializationSettingsAndroid,
//     );
//
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onSelectNotification: selectNotification,
//     );
//    }
//
//
//
//    Future onDidReceiveLocalNotification(
//        int id,String? title,String? body,String? payload) async{
//     // showDialog(
//     //   builder: (BuildContext context)=>CupertinoAlertDialog(
//     //     title: Text(title),
//     //     content: Text(body),
//     //     actions: [
//     //       CupertinoDialogAction(
//     //         isDefaultAction: true,
//     //         child: Text('ok'),
//     //         onPressed: () async{
//     //           Navigator.of(context,rootNavigator: true).pop();
//     //           await Navigator.push(
//     //             context,
//     //             MaterialPageRoute(
//     //                 builder:(context)=>SecondScreen(payload),
//     //             )
//     //           );
//     //         },
//     //       )
//     //     ],
//     //   )
//     // );
//      Get.dialog(Text("welcome "));
//    }
//
//    Future selectNotification(String? payload) async{
//     if(payload != null){
//       print("notification payload :$payload");
//     }else{
//       print("Notification done");
//     }
//     Get.to(()=>Container(color: Colors.white,));
//    }
//
//    void requestISOPermissions(){
//     flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
//         IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
//       alert: true,
//       badge: true,
//       sound: true
//     );
//    }
//    scheduledNotification(index)async{
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//         index,
//         "schedule title",
//         "theme changes",
//         tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
//         const NotificationDetails(
//           android: AndroidNotificationDetails("channelId", "channelName")
//         ),
//         androidAllowWhileIdle:true,
//         uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//     );
//    }
//   }
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class Noti{
  static Future initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin)async{
    var androidInitialize=new AndroidInitializationSettings('appi');
    var iOSInitialize =new IOSInitializationSettings();
    var initializationsSettings=new InitializationSettings(android: androidInitialize,
    iOS: iOSInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationsSettings);
}
static Future showBigTextNotification({var id=0,required String title,required String body,
var payload,required FlutterLocalNotificationsPlugin fln}) async{
    AndroidNotificationDetails androidPlatformChannelSpecifics=
        new AndroidNotificationDetails("channel", "channelName",
        playSound: true,
       // sound: RawResourceAndroidNotificationSound('notification'),
        importance: Importance.max,
        priority: Priority.high,

        );
    var not =NotificationDetails(android: androidPlatformChannelSpecifics,
    iOS: IOSNotificationDetails()
    );
    await fln.show(0,title,body,not);
}
}
