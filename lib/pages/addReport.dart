import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lifeline/entities/Documents.dart';
import 'package:lifeline/helper/databaseHelper.dart';
import 'package:lifeline/helper/reportHelper.dart';
import 'package:path_provider/path_provider.dart';

class AddReport extends StatefulWidget {
  const AddReport({Key? key}) : super(key: key);
  @override
  State<AddReport> createState() => _AddReportState();
}

class _AddReportState extends State<AddReport> {
  File? _image;
  final titleController = TextEditingController();
  bool _empty = false;
  String? img;

  final noImageSnackBar = const SnackBar(
    content: Text('An image of the report must be added'),
  );
  final reportAdded =  SnackBar(
    content: Text(
      'Successfully Added Report',
      style: TextStyle(color: Colors.cyan[50]),
    ),
  );

  Future getImage({required bool camera}) async {
    final image = camera == true
        ? await ImagePicker().pickImage(source: ImageSource.camera)
        : await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;
    final tempImage = File(image.path);

    setState(() {
      _image = tempImage;
    });

    return tempImage;
  }

  Future<String> saveImageLocally(File imageFile) async {
    final appDir = await getApplicationDocumentsDirectory();
    final imageName = DateTime.now().millisecondsSinceEpoch.toString();
    final savedImage = await imageFile.copy('${appDir.path}/$imageName.png');
    print('savedImage = ${savedImage.path}');
    return savedImage.path;
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
        title: const Text('Add Report',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: ListView(
        // padding: EdgeInsets.fromLTRB(100, 50, 100, 50),
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(35, 100, 35, 20),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Enter title',
                border: OutlineInputBorder(),
                errorText: _empty ? 'Title can\'t be empty' : null,
              ),
            ),
          ),
          _image == null
              ? const SizedBox(
                  height: 30,
                )
              : Container(
            padding: const EdgeInsets.fromLTRB(35, 10, 35, 20),
                  child: Image.file(_image!,height: 350,),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              pickImageButton(
                  text: 'From Gallery',
                  icon: Icons.image_outlined,
                  onClick: () => getImage(camera: false)),
              const SizedBox(
                width: 20,
              ),
              pickImageButton(
                  text: 'From Camera',
                  icon: Icons.camera,
                  onClick: () => getImage(camera: true)),
            ],
          ),
          const SizedBox(height: 80,)

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {
            _empty = titleController.text.isEmpty ? true : false;
          });

          if (_empty) {
            // Show a snackbar or some feedback to the user
            return;
          }
          if (_image == null) {
            ScaffoldMessenger.of(context).showSnackBar(noImageSnackBar);
            return;
          }

          String imagePath = await saveImageLocally(_image!);
          Document report = Document(
            title: titleController.text,
            image: imagePath,
          );

          await ReportHelper.addReport(report);

          if (!context.mounted) return;
          Navigator.of(context).pop(true);
          ScaffoldMessenger.of(context).showSnackBar(reportAdded);
          print('added ${report.title}');
        },
        backgroundColor: Colors.cyan[50], //todo
        child: Icon(
          Icons.add_rounded,
          color: Colors.blueGrey[900],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget pickImageButton(
      {required String text,
      required IconData icon,
      required VoidCallback onClick}) {
    return Container(
      decoration: BoxDecoration(),
      child: ElevatedButton.icon(
        onPressed: onClick,
        icon: Icon(
          icon,
          color: Colors.blueGrey[900],
        ),
        label: Text(
          text,
          style: TextStyle(color: Colors.blueGrey[900]),
        ),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.cyan[50])),
      ),
    );
  }
}
