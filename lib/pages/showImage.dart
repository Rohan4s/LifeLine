import 'dart:io';

import 'package:flutter/material.dart';


class ShowImage extends StatefulWidget {

  late String img,title;
  ShowImage(this.img,this.title);

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.img);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,style: const TextStyle(color: Colors.black),),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Image.file(File(widget.img))
      ),
    );
  }
}
