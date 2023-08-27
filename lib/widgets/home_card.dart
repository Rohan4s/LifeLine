import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Mycard extends StatelessWidget {
  final String title;
  // final Widget? widget;
  final IconData icon;
  final String? num;
  // final String? careful;
  final double size;

  const Mycard(
      {Key? key,
      required this.title,
      required this.icon,
      this.num,
      required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width / 2 - 35,
      padding: EdgeInsets.all(5),
      // margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1,
          color: Colors.white
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(
            height: 30,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[800]
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Icon(
            icon,
            size: 55,
            color: Colors.black,
          ),
          SizedBox(
            height: 20,
          ),
          //
          // Text(
          //   num==null?' ':num.toString(),
          //   style: TextStyle(
          //     fontSize: 20,
          //     fontWeight: FontWeight.w300,
          //   ),
          // ),
        ],
      ),
    );
  }
}
