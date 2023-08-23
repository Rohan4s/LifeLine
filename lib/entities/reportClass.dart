import 'package:intl/intl.dart';


class ReportClass{

  final String title;
  late String? date,time,image;

  ReportClass({required this.title,required this.image}){
    time = DateFormat("hh:mm a").format(DateTime.now()).toString();
    date = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
  }

  ReportClass.named({required this.title,required this.image, required this.time,required this.date});

  factory ReportClass.fromJson(Map<String,dynamic> json)=>ReportClass.named(title: json['title'],image:json['image'],date: json['date'],time:json['time']);


  Map<String,dynamic> toJson()=>{
    'title':title,
    'date':date,
    'time':time,
    'image':image
  };

}