// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
//
//
//
// class SaveImage extends StatefulWidget {
//   const SaveImage({Key? key}) : super(key: key);
//
//   @override
//   State<SaveImage> createState() => _SaveImageState();
// }
//
// class _SaveImageState extends State<SaveImage> {
//
//   File? imageFile;
//
//   PickImageFromGallery(ImageSource src) async {
//     final image = await ImagePicker().pickImage(source: src);
//     if(image == null)return;
//     final tempImage = File(image.path);
//
//     setState(() {
//       imageFile = tempImage;
//     });
//     var x = (ImagePicker().pickImage(source: src) ).path;
//
//   }
//
//   Widget imageFromGallery(){
//     return FutureBuilder<File>(future: imageFile, builder: builder)
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
