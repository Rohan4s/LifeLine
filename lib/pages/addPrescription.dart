import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPrescription extends StatefulWidget {
  const AddPrescription({Key? key}) : super(key: key);
  @override
  State<AddPrescription> createState() => _AddPrescriptionState();
}

class _AddPrescriptionState extends State<AddPrescription> {
  File? _image;
  final titleController = TextEditingController();
  Future getImage({required bool camera}) async{
    final image = camera==true? await ImagePicker().pickImage(source: ImageSource.camera):await ImagePicker().pickImage(source: ImageSource.gallery);
    if(image == null)return;
    final tempImage = File(image.path);

    setState(() {
      _image = tempImage;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    titleController.addListener(() {
      print(titleController.text);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Prescription'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.fromLTRB(100, 50, 100, 50),
          children: [
            TextField(
              controller: titleController ,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            _image ==null? Image(image: AssetImage('Assets/weightbg.png')):Image.file(_image!),
            pickImageButton(
                text: 'Select From Gallery',
                icon: Icons.image_outlined,
                onClick: ()=>getImage(camera: false)
            ),
            pickImageButton(
                text: 'Select From Camera',
                icon: Icons.camera,
                onClick: ()=>getImage(camera: true)
            ),

          ],
        ),
      ),
    );
  }
  Widget pickImageButton({required String text,required IconData icon,required VoidCallback onClick}){
    return Container(
      child: ElevatedButton.icon(
          onPressed: onClick,
          icon: Icon(icon),
          label: Text(text)),
    );
  }


}
