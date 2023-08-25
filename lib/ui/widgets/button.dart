import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function()? onTap;

  const MyButton({Key? key, required this.label, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Assign onTap function directly without calling it
      child: Container(
        width: 120,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.deepPurpleAccent,
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
