import 'package:appointment/ui/widgets/home_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Row(
            children: [
              Mycard(title: "REPORT", num: "careful",widget: Icon(Icons.access_time), careful: "tomuch"),
              SizedBox(width: 25,),
              Mycard(title: "PREP",num: "ckhac",widget: Icon(Icons.access_time),careful:"cjhaf" ,)
            ],
          ),
          Row(
            children: [
              Mycard(title: "MEDICINE", num: "careful",widget: Icon(Icons.access_time), careful: "tomuch"),
              SizedBox(width: 25,),
              Mycard(title: "Appointment",num: "ckhac",widget: Icon(Icons.access_time),careful:"cjhaf" ,)
            ],
          )

        ],
      ),
    );
  }
}
