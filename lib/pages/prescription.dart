import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lifeline/helper/reportHelper.dart';
import 'package:lifeline/pages/addPrescription.dart';
import 'package:lifeline/pages/addReport.dart';
import 'package:lifeline/entities/Documents.dart';
import 'package:lifeline/pages/showImage.dart';

import '../helper/prescriptionHelper.dart';

class Prescription extends StatefulWidget {
  const Prescription({Key? key}) : super(key: key);

  @override
  State<Prescription> createState() => _PrescriptionState();
}

class _PrescriptionState extends State<Prescription> {
  final updatedSnackbar = const SnackBar(content: Text('Updated Prescription Title'));
  late TextEditingController titleController;
  bool _empty = false;
  List<Document> prescriptions = [Document(title: '', image: null)];

  @override
  void initState() {
    // TODO: implement initState
    titleController = TextEditingController();
    getPrescriptions();
    super.initState();
  }

  Future getPrescriptions() async {

    List<Document>? listPrescriptions = await PrescriptionHelper.getAllPrescriptions(); ///todo

    for (int i = 0; i < listPrescriptions!.length; i++) {
      print(
          '$i -> ${listPrescriptions[i].title} -> ${listPrescriptions[i].date} -> ${listPrescriptions[i].time}');
      print(listPrescriptions[i].image);
    }
    setState(() {
      prescriptions = listPrescriptions!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Prescriptions',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.indigo,
        elevation: 252,
      ),
      body: Container(
        padding: const EdgeInsets.only(bottom: 60),
        child: ListTileTheme(
          contentPadding: const EdgeInsets.all(15),
          iconColor: Colors.blueGrey[900],
          textColor: Colors.blueGrey[900],
          tileColor: Colors.blue[50],
          style: ListTileStyle.list,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Color(0xFF80DEEA), width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          dense: true,
          child: ListView.builder(
            itemCount: prescriptions.length,
            itemBuilder: (_, index) => Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowImage(
                          prescriptions[index].image.toString(),
                          prescriptions[index].title),
                    ),
                  );
                },
                leading: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 54,
                    maxWidth: 35,
                    maxHeight: 55,
                  ),
                  child: Icon(
                    Icons.picture_as_pdf_rounded,
                    color: Colors.blueGrey[900],
                    size: 36,
                  ),
                ),
                title: Text(
                  prescriptions[index].title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  '${prescriptions[index].time.toString()}  ${prescriptions[index].date.toString()}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          _showUpdateModal(
                              context, index, getPrescriptions, titleController);
                        },
                        icon: const Icon(Icons.edit)),
                    IconButton(
                        onPressed: () {
                          _showDeleteConfirmation(context, index, getPrescriptions);
                        },
                        icon: const Icon(Icons.delete)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final bool? added = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddPrescription()));
          if (added ?? false) {
            getPrescriptions();
          }
        },
        backgroundColor: Colors.tealAccent[400], //todo
        child: const Icon(
          Icons.add_rounded,
          color: Colors.black,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showUpdateModal(BuildContext context, int index,
      Future Function() getPrescriptions, TextEditingController titleController) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 25,
              right: 25,
              top: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  maxLength: 30,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: const OutlineInputBorder(),
                    labelStyle: const TextStyle(color: Color(0xFF6200EE)),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF6200EE)),
                    ),
                    errorText: _empty ? 'Title can\'t be empty' : null,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: () async {
                    setState(() {
                      _empty = titleController.text.isEmpty ? true : false;
                    });

                    if (_empty) {
                      // Show a snackbar or some feedback to the user
                      return;
                    }

                    await PrescriptionHelper.updatePrescriptions(
                        prescriptions[index], titleController.text);
                    setState(() {
                      getPrescriptions();
                    });

                    if (!context.mounted) return;
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(updatedSnackbar);
                    titleController.clear();

                  },
                  icon: const Icon(Icons.send),
                  label: const Text('Update report'),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, int index, Future Function() getPrescriptions) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.only(top: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: const TextSpan(
                  text: 'Do you really want to ',
                  style: TextStyle(color: Colors.black, fontSize: 17),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Delete',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                        text: ' this prescription?',
                        style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final file = File(prescriptions[index].image.toString());
                        if (await file.exists()) {
                          await file.delete();
                          print('Image deleted successfully');
                        } else {
                          print('Image does not exist at the specified path');
                        }
                      } catch (e) {
                        print('Error while deleting image: $e');
                      }

                      await PrescriptionHelper.deletePrescription(prescriptions[index]);
                      if (!context.mounted)return;

                      Navigator.of(context).pop(true);

                      getPrescriptions(); // Call the callback to trigger refresh
                    },
                    child: const Text(
                      'Yes',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 30),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('No'),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}