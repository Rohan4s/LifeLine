import 'package:flutter/material.dart';
import 'package:lifeline/entities/weightClass.dart';
import 'package:lifeline/helper/databaseHelper.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weight & BMI'),
        // centerTitle: true,
        actions: [
          ElevatedButton.icon(
            onPressed: () async {
              final bool? added = await Navigator.push(context,MaterialPageRoute(builder: (context) => AddWeight()));
              if(added??false)
                getWeights();
              // print('Deleted ${await DatabaseHelper.deleteNote()}');
            },
            icon: const Icon(Icons.add),
            label: const Text('Add'),
          )
        ],
      ),
      body: Container(
        decoration: boxDecoration,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              getCurrentMetrics(width: 250, height: 100),
              getMetricsStats(width: 300, heightGraph: 250),
            ],
          ),
        ),
      ),
    );
  }

  //functions
  Future getWeights() async {
    List<WeightClass>? ListWeights = await DBhelper.getAllWeights();

    setState(() {
      weights = ListWeights!;
    });
  }


  List<WeightClass> getLastTenWeights() {

    int index=weights.length <10? weights.length-1:10-1;

    List<WeightClass> data= [];


    // for (int i=0; i<index; i++) {
    //   data.add(weights[i]);
    //   print('$i -> ${weights[i].weight}');
    // }
    for (index; index>=0; index--) {
      data.add(weights[index]);
      print('$index -> ${weights[index].weight}');
    }

    return data;
  }

  Widget getMetricsStats(
      {required double width, required double? heightGraph}) {

    List<WeightClass> graphWeights;
    graphWeights = getLastTenWeights();

    //getStats
    double max=0, min=100000, avg,sum=0;
    for(int i=0;i<weights.length;i++){
      double wt=weights[i].weight;
      sum+=wt;
      if(wt>max)max=wt;
      if(wt<min)min=wt;
    }
    avg=sum/weights.length;
    max = double.parse(max.toStringAsFixed(2));
    min = double.parse(min.toStringAsFixed(2));
    avg = double.parse(avg.toStringAsFixed(2));


    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: Card(
        color: Theme.of(context).primaryColorLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          width: width,
          color: Theme.of(context).primaryColorLight,
          child: Column(
            children: [
              rowText(
                  text1: 'Max',
                  text2: 'Min',
                  text3: 'avg',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  )),
              rowText(
                  text1: '$max',
                  text2: '$min',
                  text3: '$avg',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              SizedBox(height: heightGraph, child: LineChartWidget(weights: getLastTenWeights(),))
            ],
          ),
        ),
      ),
    );
  }

  Widget rowText(
      {required final TextStyle style,
      required String text1,
      required String text2,
      required String text3}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text1,
            style: style,
          ),
          Text(
            text2,
            style: style,
          ),
          Text(
            text3,
            style: style,
          ),
        ],
      ),
    );
  }

  Widget getCurrentMetrics({required double width, required double height}) {
    TextStyle textStyle = const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
    );
    double weight = double.parse(weights[0].weight.toStringAsFixed(2));
    double bmi = double.parse(weights[0].bmi.toStringAsFixed(2));
    String datetime = weights[0].date +'  '+ weights[0].time;

    return Card(
      color: Theme.of(context).primaryColorLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: width,
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('$weight',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Standard BMI",
                  style: textStyle,
                ),
                Text('Height: ${height}cm', style: textStyle),
                Text('BMI: $bmi', style: textStyle),
                Text(datetime, style: textStyle),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
