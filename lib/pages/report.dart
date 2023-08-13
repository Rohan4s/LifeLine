import 'package:flutter/material.dart';

class Report extends StatefulWidget {
  const Report({Key? key}) : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  int count = 15;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: ListView.builder(
          itemCount: count,
          itemBuilder: (BuildContext context, index) => Container(
            margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: ListTile(
              onTap: null, // todo
              title: Text('Title'),
              subtitle: Text('subtitle'),
              trailing: ElevatedButton.icon(
                  onPressed: null,
                  icon: Icon(Icons.more_vert),
                  label: Text('')),
              leading: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 24,
                  minHeight: 24,
                  maxWidth: 35,
                  maxHeight: 35,
                ),
                child: Image.asset('Assets/pdf-icon-48.png', fit: BoxFit.cover),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(22.0))),
              tileColor: Colors.grey,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null, //todo
        child: Icon(Icons.add),
      ),
    );
  }
}
