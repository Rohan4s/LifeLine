import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lifeline/helper/reportHelper.dart';
import 'package:lifeline/pages/addReport.dart';
import 'package:lifeline/entities/Documents.dart';
import 'package:lifeline/pages/showImage.dart';

class Report extends StatefulWidget {
  const Report({Key? key}) : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final updatedSnackbar = const SnackBar(content: Text('Updated Report Title'));
  late TextEditingController titleController;
  bool _empty = false;
  List<Document> reports = [Document(title: '', image: null)];

  @override
  void initState() {
    // TODO: implement initState
    titleController = TextEditingController();
    getReports();
    super.initState();
  }

  Future getReports() async {
    List<Document>? listReports = await ReportHelper.getAllReports();
    for (int i = 0; i < listReports!.length; i++) {
      print(
          '$i -> ${listReports[i].title} -> ${listReports[i].date} -> ${listReports[i].time}');
      print(listReports[i].image);
    }
    setState(() {
      reports = listReports!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Reports',
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
            itemCount: reports.length,
            itemBuilder: (_, index) => Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowImage(
                          reports[index].image.toString(),
                          reports[index].title),
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
                  reports[index].title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  '${reports[index].time.toString()}  ${reports[index].date.toString()}',
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
                              context, index, getReports, titleController);
                        },
                        icon: const Icon(Icons.edit)),
                    IconButton(
                        onPressed: () {
                          _showDeleteConfirmation(context, index, getReports);
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
              context, MaterialPageRoute(builder: (context) => AddReport()));
          if (added ?? false) {
            getReports();
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
      Future Function() getReports, TextEditingController titleController) {
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

                    await ReportHelper.updateReport(
                        reports[index], titleController.text);
                    setState(() {
                      getReports();
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
      BuildContext context, int index, Future Function() getReports) {
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
                        final file = File(reports[index].image.toString());
                        if (await file.exists()) {
                          await file.delete();
                          print('Image deleted successfully');
                        } else {
                          print('Image does not exist at the specified path');
                        }
                      } catch (e) {
                        print('Error while deleting image: $e');
                      }

                      await ReportHelper.deleteReport(reports[index]);
                      if (context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                      getReports(); // Call the callback to trigger refresh
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