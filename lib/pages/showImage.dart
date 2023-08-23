import 'dart:io';

import 'package:flutter/material.dart';


class ShowImage extends StatefulWidget {

  late String img,title;
  ShowImage(this.img,this.title);

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  // LoadImageFromPreferences() {
  //   Utility.getImageFromPreferences().then((img) {
  //     if (img == null) {
  //       return null;
  //     }
  //     return Utility.imageFromBase64String(img);
  //   });
  // }
  @override
  void initState() {
    // TODO: implement initState
    // LoadImageFromPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.img);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Image.file(File(widget.img))
      ),
    );
  }
}
