import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lifeline/helper/prescriptionHelper.dart';
import 'package:lifeline/helper/reportHelper.dart';
import 'package:lifeline/pages/addDocument.dart';
import 'package:lifeline/entities/Documents.dart';
import 'package:lifeline/pages/fab.dart';
import 'package:lifeline/pages/showImage.dart';
import 'package:fan_floating_menu/fan_floating_menu.dart';

class Documents extends StatefulWidget {
  bool isReport;
  Documents({super.key, required this.isReport});

  @override
  State<Documents> createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {
  late TextEditingController titleController;
  bool _empty = false;
  late bool isReport; // false -> prescription page
  List<Document> documents = [
    Document(title: 'No Documents Found', image: null)
  ];

  @override
  void initState() {
    // TODO: implement initState
    titleController = TextEditingController();
    setState(() {
      isReport = widget.isReport;
    });
    getDocuments();
    super.initState();
  }

  Future getDocuments() async {
    List<Document>? listDocuments = [];
    listDocuments = isReport
        ? await ReportHelper.getAllReports()
        : await PrescriptionHelper.getAllPrescriptions();

    // for (int i = 0; i < listDocuments!.length ; i++) {
    //   print(
    //       '$i -> ${listDocuments[i].title} -> ${listDocuments[i].date} -> ${listDocuments[i].time}');
    //   print(listDocuments[i].image);
    // }
    setState(() {
      if (listDocuments == null) {
        documents.clear();
        documents.add(Document(title: 'No Document Found', image: ''));
      } else {
        documents = listDocuments;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  isReport = true;
                });
                getDocuments();
              },
              style: const ButtonStyle(),
              child: Text(
                'Reports',
                style: isReport
                    ? const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)
                    : const TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isReport = false;
                  print(isReport);
                });
                getDocuments();
              },
              child: Text(
                'Prescriptions',
                style: isReport
                    ? const TextStyle(color: Colors.black)
                    : const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
              ),
            ),
          ],
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
            itemCount: documents.length,
            itemBuilder: (_, index) => Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowImage(
                          documents[index].image.toString(),
                          documents[index].title),
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
                  documents[index].title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  '${documents[index].time.toString()}  ${documents[index].date.toString()}',
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
                              context, index, getDocuments, titleController);
                        },
                        icon: const Icon(Icons.edit)),
                    IconButton(
                        onPressed: () {
                          _showDeleteConfirmation(context, index, getDocuments);
                        },
                        icon: const Icon(Icons.delete)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Fab(
          colors: [Colors.teal[800], Colors.cyan[800]],
          labels: ['Report', 'Prescription'],
          count: 2,
          icons: [
            Icons.add,
            Icons.add,
          ],
          functions: [
            () {
              addDocument(true);
            },
            () {
              addDocument(false);
            }
          ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void addDocument(bool addReport) async {
    final bool? added = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddDocument(isReport: addReport)));
    if (added ?? false) {
      getDocuments();
    }
  }

  void _showUpdateModal(BuildContext context, int index,
      Future Function() getDocuments, TextEditingController titleController) {
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
                    isReport
                        ? await ReportHelper.updateReport(
                            documents[index], titleController.text)
                        : await PrescriptionHelper.updatePrescriptions(
                            documents[index], titleController.text);

                    setState(() {
                      getDocuments();
                    });

                    if (!context.mounted) return;
                    Navigator.pop(context);
                    showUpdatedSnackbar(
                        context,
                        isReport
                            ? 'Updated Report successfully'
                            : 'Updated Prescription successfully');
                    titleController.clear();
                  },
                  icon: const Icon(Icons.send),
                  label:
                      Text(isReport ? 'Update report' : 'Update Prescription'),
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
      BuildContext context, int index, Future Function() getDocuments) {
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
                        text: ' this report?',
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
                        final file = File(documents[index].image.toString());
                        if (await file.exists()) {
                          await file.delete();
                          print('Image deleted successfully');
                        } else {
                          print('Image does not exist at the specified path');
                        }
                      } catch (e) {
                        print('Error while deleting image: $e');
                      }

                      await ReportHelper.deleteReport(documents[index]);
                      if (context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                      getDocuments(); // Call the callback to trigger refresh
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

  void showUpdatedSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
  }
}
