import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lifeline/entities/Documents.dart';
import 'package:lifeline/helper/prescriptionHelper.dart';
import 'package:lifeline/helper/reportHelper.dart';
import 'package:path_provider/path_provider.dart';

class AddDocument extends StatefulWidget {
  late bool isReport;
  AddDocument({super.key, required this.isReport});
  @override
  State<AddDocument> createState() => _AddDocumentState();
}

class _AddDocumentState extends State<AddDocument> {
  File? _image;
  final titleController = TextEditingController();
  String? img;
  late bool isReport;

  @override
  void initState() {
    // TODO: implement initState
    isReport = widget.isReport;
    titleController.addListener(() {
      print(titleController.text);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isReport ? 'Add Report' : 'Add Prescription',
          style: TextStyle(color: Colors.white),
        ),
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
              decoration: const InputDecoration(
                labelText: 'Enter title',
                border: OutlineInputBorder(),
                // errorText: _empty ? 'Title can\'t be empty' : null,
              ),
            ),
          ),
          _image == null
              ? const SizedBox(
                  height: 30,
                )
              : Container(
                  padding: const EdgeInsets.fromLTRB(35, 10, 35, 20),
                  child: Image.file(
                    _image!,
                    height: 350,
                  ),
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
          const SizedBox(
            height: 80,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(

        onPressed: () async {
          String time;
          if (_image == null) {
            showAddImageSnackbar(context);
            return;
          }
          if (titleController.text.isEmpty) {
              showEmptyTitleSnackbar(context);
            return;
            // time = ' ';
            // time = DateFormat('yyyyMMddHHmmss').format(DateTime.now()).toString();
          }
          else {
            time = titleController.text;
          }
          String imagePath = await saveImageLocally(_image!);
          Document document = Document(
            title: titleController.text,
            image: imagePath,
          );

          isReport
              ? await ReportHelper.addReport(document)
              : await PrescriptionHelper.addPrescriptions(document);

          if (!context.mounted) return;
          Navigator.of(context).pop(true);
          showAddedSnackbar(context);
          print('added ${document.title}');

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

  void showAddImageSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please Select An Image'),
        duration: const Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
  }

  void showEmptyTitleSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Please Enter Title',
          style: TextStyle(color: Colors.red),
        ),
        duration: Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
  }

  void showAddedSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Added Document Successfully',
          style: TextStyle(color: Colors.cyan[50]),
        ),
        duration: Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
  }
}
