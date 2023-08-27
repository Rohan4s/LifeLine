import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifeline/pages/Home.dart';
import 'package:lifeline/pages/addDocument.dart';
import 'package:lifeline/pages/addPressure.dart';
import 'package:lifeline/pages/appointment.dart';
import 'package:lifeline/pages/documents.dart';
import 'package:lifeline/pages/fab.dart';
import 'package:lifeline/pages/pressure.dart';
import 'package:lifeline/pages/signup.dart';
import 'pages/prescription.dart';
import 'pages/report.dart';
import 'pages/weight.dart';
import 'widgets/graph.dart';
import 'widgets/healthMetrics.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: Home(),

    );
  }
}
