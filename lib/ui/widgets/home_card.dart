import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Mycard extends StatelessWidget {
  final String title;
  final Widget? widget;
  final String? num;
  final String? careful;

  const Mycard({Key? key,
    required this.title,
    this.widget,
    this.num,
    this.careful,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      width: 170,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 2),
      ),


      child: ElevatedButton(
        onPressed: ()=>{
          print("onpreess1")
        },
        style: ElevatedButton.styleFrom(
             primary: Colors.transparent,
             //onPrimary: Colors.transparent,
        ),
        child: Container(


          child: Column(

            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
              ),
              widget==null?Container():Container(child: widget),
              SizedBox(height: 120,),
              Text(
                num!,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                careful!,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
