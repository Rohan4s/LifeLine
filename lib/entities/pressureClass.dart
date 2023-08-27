import 'package:intl/intl.dart';


class PressureClass{

  final int systolicPressure;
  final int diastolicPressure;
  final int pulse;
  late String date,time;

  PressureClass({required this.systolicPressure,required this.diastolicPressure,required this.pulse}){

    time = DateFormat("hh:mm a").format(DateTime.now()).toString();
    date = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
  }
  PressureClass.named({required this.systolicPressure,required this.diastolicPressure,required this.pulse,required this.time,required this.date});

  factory PressureClass.fromJson(Map<String,dynamic> json)=>PressureClass.named(
      systolicPressure: json['systolicPressure'],
      diastolicPressure: json['diastolicPressure'],
      pulse: json['pulse'],
      date: json['date'],
      time:json['time']
  );


  Map<String,dynamic> toJson()=>{
    'systolicPressure':systolicPressure,
    'diastolicPressure':diastolicPressure,
    'pulse':pulse,
    'date':date,
    'time':time
  };

}