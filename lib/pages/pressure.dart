import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lifeline/entities/pressureClass.dart';
import 'package:lifeline/pages/addPressure.dart';
import 'package:lifeline/widgets/graph.dart';
import 'package:lifeline/widgets/graph2.dart';
import '../helper/pressureHelper.dart';

class Pressure extends StatefulWidget {
  const Pressure({Key? key}) : super(key: key);
  @override
  State<Pressure> createState() => _PressureState();
}

class _PressureState extends State<Pressure> {
  //styles

  //variables
  List<PressureClass> pressures = [];

  @override
  void initState() {
    getPressures();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        shadowColor: Colors.indigo,
        title: const Text(
          'Pressure & Pulse',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        // centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              final bool? added = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddPressure()));
              if (added ?? false) {
                getPressures();
              }
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 30),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              getCurrentData(height: 100),
              // getMetricsStats(
              //     width: MediaQuery.of(context).size.width - 50,
              //     heightGraph: 400),
              // SizedBox(
              //   height: 30,
              // ),
              SizedBox(height: 15,),
              getPressureGraph(
                  width: MediaQuery.of(context).size.width-30, height: 250),
              SizedBox(height: 15,),
              getPressureList(),
              SizedBox(height: 60,),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final bool? added = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddPressure()));
          if (added ?? false) {
            getPressures();
          }
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  //functions
  Future getPressures() async {
    List<PressureClass>? ListWeights = await PressureHelper.getAllPressures();

    setState(() {
      if (ListWeights == null) {
        pressures.clear();
        pressures.add(
            PressureClass(systolicPressure: 0, diastolicPressure: 0, pulse: 0));
      } else {
        pressures = ListWeights;
      }
    });
  }

  List<PressureClass> getLastPressures(int count) {
    int index = pressures.length < count ? pressures.length - 1 : count - 1;

    List<PressureClass> data = [];

    for (index; index >= 0; index--) {
      data.add(pressures[index]);
      print('$index -> ${pressures[index].systolicPressure}');
    }

    return data;
  }

  Widget getPressureList() {
    return ListTileTheme(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: pressures.length + 1,
          itemBuilder: (_, index) {
            if (index == 0) {
              return const Text(
                'All Your Pressures',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              );
            } else {
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  onTap: () {},
                  title: Text(
                    'Systolic: ${pressures[index - 1].systolicPressure} mmhg',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    'Diastolic :${pressures[index - 1].diastolicPressure}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  trailing: Text(
                    '${pressures[index - 1].time.toString()}  ${pressures[index - 1].date.toString()}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }


  Widget getCurrentData({width, height}) {
    //get stats
    int maxSystolic = 0, minSystolic = 100000, sumSystolic = 0;
    int maxDiastolic = 0, minDiastolic = 100000, sumDiastolic = 0;
    int maxPulse = 0, minPulse = 100000, sumPulse = 0;
    double avgSystolic, avgDiastolic, avgPulse;
    for (int i = 0; i < pressures.length; i++) {
      int pulse = pressures[i].pulse;
      int systolic = pressures[i].systolicPressure;
      int diastolic = pressures[i].diastolicPressure;

      sumDiastolic += diastolic;
      sumPulse += pulse;
      sumSystolic += systolic;

      if (systolic > maxSystolic) maxSystolic = systolic;
      if (systolic < minSystolic) minSystolic = systolic;

      if (diastolic > maxDiastolic) maxDiastolic = diastolic;
      if (diastolic < minDiastolic) minDiastolic = diastolic;

      if (pulse > maxPulse) maxPulse = pulse;
      if (pulse < minPulse) minPulse = pulse;
    }
    avgSystolic = sumSystolic / pressures.length;
    avgSystolic = double.parse(avgSystolic.toStringAsFixed(2));

    avgDiastolic = sumDiastolic / pressures.length;
    avgDiastolic = double.parse(avgSystolic.toStringAsFixed(2));

    avgPulse = sumPulse / pressures.length;
    avgPulse = double.parse(avgSystolic.toStringAsFixed(2));



    TextStyle headers = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    width = (width == null) ? MediaQuery.of(context).size.width - 30 : width;
    height =
        (height == null) ? MediaQuery.of(context).size.height - 30 : height;

    return Container(
      width: width*1.0,
      height: height*1.0,
      // margin: EdgeInsets.only(left: 20,right: 20,top: 30),

      child: Card(
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.only(left: 15,right: 5,top:10),
          child: Table(
            children: [
              TableRow(
                children: [
                  TableCell(child: Text('Category',style: headers,)),
                  TableCell(child: Text('Max',style: headers)),
                  TableCell(child: Text('Min',style: headers)),
                  TableCell(child: Text('Average',style: headers)),
                  // TableCell(child: Text('Current',style: headers)),
                ],
              ),
              TableRow(
                children: [
                  TableCell(child: Text('Systolic')),
                  TableCell(child: Text('$maxSystolic')),
                  TableCell(child: Text('$minSystolic')),
                  TableCell(child: Text('$avgSystolic')),
                  // TableCell(child: Text('${pressures[0].systolicPressure}')),
                ]
              ),
              TableRow(
                children: [
                  TableCell(child: Text('Diastolic')),
                  TableCell(child: Text('$maxDiastolic')),
                  TableCell(child: Text('$minDiastolic')),
                  TableCell(child: Text('$avgDiastolic')),
                  // TableCell(child: Text('${pressures[0].diastolicPressure}')),
                ]
              ),
            ],
          ),
        ),
      ),
    );

  }

  //getCurrentData prev version
  // Widget getMetricsStats(
  //     {required double width, required double? heightGraph}) {
  //   List<PressureClass> graphPressures;
  //   graphPressures = getLastPressures(30);
  //
  //   //getStats
  //   int maxSystolic = 0, minSystolic = 100000, sumSystolic = 0;
  //   int maxDiastolic = 0, minDiastolic = 100000, sumDiastolic = 0;
  //   int maxPulse = 0, minPulse = 100000, sumPulse = 0;
  //   double avgSystolic, avgDiastolic, avgPulse;
  //   for (int i = 0; i < pressures.length; i++) {
  //     int pulse = pressures[i].pulse;
  //     int systolic = pressures[i].systolicPressure;
  //     int diastolic = pressures[i].diastolicPressure;
  //
  //     sumDiastolic += diastolic;
  //     sumPulse += pulse;
  //     sumSystolic += systolic;
  //
  //     if (systolic > maxSystolic) maxSystolic = systolic;
  //     if (systolic < minSystolic) minSystolic = systolic;
  //
  //     if (diastolic > maxDiastolic) maxDiastolic = diastolic;
  //     if (diastolic < minDiastolic) minDiastolic = diastolic;
  //
  //     if (pulse > maxPulse) maxPulse = pulse;
  //     if (pulse < minPulse) minPulse = pulse;
  //   }
  //   avgSystolic = sumSystolic / pressures.length;
  //   avgSystolic = double.parse(avgSystolic.toStringAsFixed(2));
  //
  //   avgDiastolic = sumDiastolic / pressures.length;
  //   avgDiastolic = double.parse(avgSystolic.toStringAsFixed(2));
  //
  //   avgPulse = sumPulse / pressures.length;
  //   avgPulse = double.parse(avgSystolic.toStringAsFixed(2));
  //
  //   return Container(
  //     padding: const EdgeInsets.only(bottom: 20),
  //     child: Card(
  //       color: Colors.white,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //       child: Container(
  //         width: MediaQuery.of(context).size.width,
  //         height: 200,
  //         color: Colors.white,
  //         child: Column(
  //           children: [
  //             SizedBox(
  //               height: 30,
  //             ),
  //             rowText(
  //                 category: 'Category',
  //                 text1: 'Max',
  //                 text2: 'Min',
  //                 text3: 'avg',
  //                 unit: '',
  //                 style: TextStyle(
  //                   fontSize: 12,
  //                   color: Colors.grey[600],
  //                 )),
  //             rowText(
  //                 category: 'Systolic',
  //                 text1: '$maxSystolic',
  //                 text2: '$minSystolic',
  //                 text3: '$avgSystolic',
  //                 unit: 'mmhg',
  //                 style: const TextStyle(
  //                     fontSize: 12,
  //                     fontWeight: FontWeight.w500,
  //                     color: Colors.black)),
  //             rowText(
  //                 category: 'Diastolic',
  //                 text1: '$maxDiastolic',
  //                 text2: '$minDiastolic',
  //                 text3: '$avgDiastolic',
  //                 unit: 'mmhg',
  //                 style: const TextStyle(
  //                     fontSize: 12,
  //                     fontWeight: FontWeight.w500,
  //                     color: Colors.black)),
  //             rowText(
  //                 category: 'Pulse',
  //                 text1: '$maxPulse',
  //                 text2: '$minPulse',
  //                 text3: '$avgPulse',
  //                 unit: 'bpm',
  //                 style: const TextStyle(
  //                     fontSize: 12,
  //                     fontWeight: FontWeight.w500,
  //                     color: Colors.black)),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }  // g

  Widget rowText(
      {required final TextStyle style,
      required String category,
      required String text1,
      required String text2,
      required String text3,
      required String unit}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Text(category),
          RichText(
            text: TextSpan(
              text: category,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: unit,
                  style: const TextStyle(
                      fontSize: 12,
                      fontFeatures: [FontFeature.subscripts()],
                      fontWeight: FontWeight.w400,
                      color: Colors.grey),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: text1,
              style: style,
              children: <TextSpan>[],
            ),
          ),
          RichText(
            text: TextSpan(
              text: text2,
              style: style,
              children: <TextSpan>[],
            ),
          ),
          RichText(
            text: TextSpan(
              text: text3,
              style: style,
              children: <TextSpan>[],
            ),
          ),
        ],
      ),
    );
  }

  Widget getPressureGraph({required double width, required double height}) {
    return Container(
        padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: SizedBox(
            height: 400,
            child: LineChartWidget2(
              pressures: getLastPressures(30),
            )));
  }
}
