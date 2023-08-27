import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lifeline/entities/weightClass.dart';
import 'package:lifeline/helper/weightHelper.dart';
import 'package:lifeline/pages/documents.dart';
import 'package:lifeline/pages/fab.dart';
import 'package:lifeline/pages/pressure.dart';
import 'package:lifeline/pages/report.dart';
import 'package:lifeline/pages/signup.dart';
import 'package:lifeline/pages/weight.dart';
import 'package:lifeline/widgets/home_card.dart';

import '../entities/user.dart';
import '../helper/userHelper.dart';
import 'appointment.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = true;
  List<WeightClass>? weights = [];
  List<User>? users;

  @override
  void initState() {
    userAdded();
    // TODO: implement initState
    super.initState();
  }

  userAdded() async {
    users = await UserHelper.getUser();
    setState(() {
      isLoading = false;
    });
    if (users == null || users!.isEmpty) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Signup()));
    }
    weights = await WeightHelper.getAllWeights();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: SpinKitDoubleBounce(
            color: Colors.blue,
            size: 50.0,
          ),
        ),
      );
    } else {
      return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              'LifeLine',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            // centerTitle: true,
            backgroundColor: Colors.indigo,
            actions: [
              Text(
                'Hello, ${users?[0].name} ',
                style:
                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 20),
              )
            ],
          ),
          body: Container(
            color: Colors.grey[200],
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Documents(isReport: true)));
                        },
                        child: const Mycard(
                          title: 'Documents',
                          icon: Icons.medical_information_outlined,
                          num: '20',
                          size: 50,
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AppHomePage()));
                        },
                        child: const Mycard(
                          title: 'Appointment',
                          icon: Icons.edit_document,
                          num: '20',
                          size: 50,
                        )),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Weight()));
                        },
                        child: const Mycard(
                          title: 'Weight & BMI',
                          icon: Icons.fitness_center,
                          num: '20',
                          size: 50,
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Pressure()));
                        },
                        child: const Mycard(
                          title: 'Pressure',
                          icon: Icons.queue,
                          num: '20',
                          size: 50,
                        )),
                  ],
                ),
              ],
            ),
          ),
          // floatingActionButton:
          // Fab(colors:[Colors.orange,Colors.orange,Colors.orange,Colors.orange,Colors.orange,],
          //     count: 4,
          //     icons: [Icons.medical_information_outlined,Icons.medical_information,Icons.fitness_center,Icons.queue],
          //     functions: [(){print('1');},(){print('2');},(){print('3');},(){print('4');},],
          //     labels: ['Report','Prescription','Weight','Pressure']
          // ),
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        ),
      );
    }
  }
}
