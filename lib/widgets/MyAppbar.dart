import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  String title;
  bool centerTitle=false;
  MyAppBar({required this.title,required this.centerTitle});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: centerTitle,
      

    );
  }
}
