import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lifeline/entities/weightClass.dart';
import 'package:lifeline/helper/weightHelper.dart';
import 'package:lifeline/pages/addWeight.dart';
import 'package:lifeline/widgets/graph.dart';

class Weight extends StatefulWidget {
  const Weight({Key? key}) : super(key: key);
  @override
  State<Weight> createState() => _WeightState();
}

class _WeightState extends State<Weight> {
  //styles
  final BoxDecoration boxDecoration = const BoxDecoration(
      image: DecorationImage(
    image: AssetImage('Assets/weightbg.png'),
  ));

  //variables
  List<WeightClass> weights = [WeightClass(weight: 0, bmi: 0)];

  @override
  void initState() {
    getWeights();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 50;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weight & BMI',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        // centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () async {
                final bool? added = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddWeight()));
                if (added ?? false) {
                  getWeights();
                }
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getCurrentData(width: width, height: 100),
              SizedBox(height: 20,),
              getWeightGraphs(width: width, heightGraph: 300),
              SizedBox(height: 20,),
              getWeightList(),
            ],
          ),
        ),
      ),
    );
  }

  //functions
  Future getWeights() async {
    List<WeightClass>? ListWeights = await WeightHelper.getAllWeights();

    setState(() {
      if (ListWeights == null) {
        weights.clear();
        weights.add(WeightClass(weight: 0, bmi: 0));
      } else {
        weights = ListWeights;
      }
    });
  }

  List<WeightClass> getLastWeights(int count) {
    int index = weights.length < count ? weights.length - 1 : count - 1;

    List<WeightClass> data = [];

    for (index; index >= 0; index--) {
      data.add(weights[index]);
      print('$index -> ${weights[index].weight}');
    }

    return data;
  }

  Widget getWeightGraphs(
      {required double width, required double? heightGraph}) {
    List<WeightClass> graphWeights;
    graphWeights = getLastWeights(10);

    //getStats
    double max = 0, min = 100000, avg, sum = 0;
    for (int i = 0; i < weights.length; i++) {
      double wt = weights[i].weight;
      sum += wt;
      if (wt > max) max = wt;
      if (wt < min) min = wt;
    }
    avg = sum / weights.length;
    max = double.parse(max.toStringAsFixed(2));
    min = double.parse(min.toStringAsFixed(2));
    avg = double.parse(avg.toStringAsFixed(2));

    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          width: width,
          color: Colors.white,
          child: Column(
            children: [
              rowText(
                  text1: 'Max',
                  text2: 'Min',
                  text3: 'avg',
                  unit: false,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  )),
              rowText(
                  text1: '$max',
                  text2: '$min',
                  text3: '$avg',
                  unit: true,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
              SizedBox(
                  height: heightGraph,
                  child: LineChartWidget(
                    weights: getLastWeights(10),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget getWeightList() {
    return ListTileTheme(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: weights.length + 1,
          itemBuilder: (_, index) {
            if (index == 0) {
              return const Text(
                'All Your Weights',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              );
            } else {
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  onTap: () {},
                  title: Text(
                    '${weights[index - 1].weight} kg',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    'BMI :${weights[index - 1].bmi}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  trailing: Text(
                    '${weights[index - 1].time.toString()}  ${weights[index - 1].date.toString()}',
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

  Widget rowText(
      {required final TextStyle style,
      required String text1,
      required String text2,
      required String text3,
      required bool unit}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              text: text1,
              style: style,
              children: <TextSpan>[
                TextSpan(
                  text: unit ? ' kg' : '',
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
              text: text2,
              style: style,
              children: <TextSpan>[
                TextSpan(
                  text: unit ? ' kg' : '',
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
              text: text3,
              style: style,
              children: <TextSpan>[
                TextSpan(
                  text: unit ? ' kg' : '',
                  style: const TextStyle(
                      fontSize: 12,
                      fontFeatures: [FontFeature.subscripts()],
                      fontWeight: FontWeight.w400,
                      color: Colors.grey),
                ),
              ],
            ),
          ),
          // Text(
          //   text2,
          //   style: style,
          // ),
          // Text(
          //   text3,
          //   style: style,
          // ),
        ],
      ),
    );
  }

  Widget getCurrentData({required double width, required double height}) {
    TextStyle textStyle = const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
    );
    double weight = double.parse(weights[0].weight.toStringAsFixed(2));
    double bmi = double.parse(weights[0].bmi.toStringAsFixed(2));
    String datetime = '${weights[0].date}  ${weights[0].time}';

    return Card(
      color: Colors.red,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        color: Colors.white,
          padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'BMI',
                    style: TextStyle(
                      color: Colors.green,
                    ),
                  ),
                  Text('${weights[0].date}')
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              RichText(
                text: TextSpan(
                  text: '$bmi',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.black),
                  children: const <TextSpan>[
                    TextSpan(
                      text: 'kg/m',
                      style: TextStyle(
                          fontSize: 12,
                          fontFeatures: [FontFeature.subscripts()],
                          fontWeight: FontWeight.w400,
                          color: Colors.grey),
                    ),
                    TextSpan(
                        text: '2',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey)),
                  ],
                ),
              )
            ],
          )),
    );
    // return Card(
    //   color: Colors.cyan[50],
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    //   child: SizedBox(
    //     width: width,
    //     height: height,
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       children: [
    //         Text('$weight',
    //             style: TextStyle(
    //               fontSize: 22,
    //               fontWeight: FontWeight.w700,
    //               color: Colors.blueGrey[900]
    //             )),
    //         Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Text(
    //               "Standard BMI",
    //               style: textStyle,
    //             ),
    //             Text('Height: ${height}cm', style: textStyle),
    //             Text('BMI: $bmi', style: textStyle),
    //             Text(datetime, style: textStyle),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
