import 'package:intl/intl.dart';


class Document{

  final String title;
  late String? date,time,image;

  Document({required this.title,required this.image}){
    time = DateFormat("hh:mm a").format(DateTime.now()).toString();
    date = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
  }

  Document.named({required this.title,required this.image, required this.time,required this.date});

  factory Document.fromJson(Map<String,dynamic> json)=>Document.named(title: json['title'],image:json['image'],date: json['date'],time:json['time']);


  Map<String,dynamic> toJson()=>{
    'title':title,
    'date':date,
    'time':time,
    'image':image
  };

}