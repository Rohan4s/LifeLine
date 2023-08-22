import 'package:intl/intl.dart';


class WeightClass{

  final double weight;
  final double bmi;
  late String date,time;

  WeightClass({required this.weight,required this.bmi}){

    time = DateFormat("hh:mm a").format(DateTime.now()).toString();
    date = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
  }
  WeightClass.named({required this.weight,required this.bmi,required this.time,required this.date});

  factory WeightClass.fromJson(Map<String,dynamic> json)=>WeightClass.named(weight: json['weight'], bmi: json['bmi'],date: json['date'],time:json['time']);


  Map<String,dynamic> toJson()=>{
    'weight':weight,
    'bmi':bmi,
    'date':date,
    'time':time
  };

}