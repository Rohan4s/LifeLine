import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lifeline/entities/weightClass.dart';

class LineChartWidget extends StatefulWidget {

  final List<WeightClass> weights;
  const LineChartWidget({super.key, required this.weights});

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {

  List<FlSpot> graphSpots = [];
  final List<Color> gradientColors =[
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  get intervalY => null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    final borderColor = Colors.black;
    final belowCurveColor = Colors.cyan;
    const bgColor = Colors.white54;
    const Color curveColor = Colors.grey;
    double maxX = 10, minX = 1, maxY = 0, minY = 100000;

    graphSpots.clear();
    for (int i = 0; i < widget.weights.length; i++) {
      double weight = widget.weights[i].weight;

      graphSpots.add(FlSpot((i+1).toDouble(), weight));

      if (weight > maxY) maxY = weight;
      if(weight < minY) minY = weight;
    }
    int y = minY.floor();
    y = y%2==0?y-4:y-3;
    minY = y*1.0;
    if(minY<0)minY=0;
    y = maxY.ceil();
    y = y%2==0?y+4:y+3;
    maxY=y*1.0;


    double intervalY = (maxY - minY) / 6;
    if (intervalY == 0) intervalY = 5;

    return Container(
        color: bgColor,
        padding: const EdgeInsets.only(right: 30, top: 20),
        child: LineChart(
      LineChartData(
        minY: minY,
        minX: minX,
        maxX: maxX,
        maxY: maxY,

        titlesData: getTitleData(),

        gridData: getGridData(),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color:Colors.black, width: 1),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: graphSpots,

            isCurved: false,
            color: curveColor,
            barWidth: 3,
            belowBarData: BarAreaData(
              show: false,
              color: belowCurveColor,
            ),

          ),
        ],
      ),
    ));
  }
  FlGridData getGridData(){
    return FlGridData(
        show: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey,
            strokeWidth: 0.7,
          );
        },
        drawVerticalLine: false,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        });
  }

  FlTitlesData getTitleData(){
    return const FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 50,
          interval: 1,

        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 50,
          interval: 2,
        ),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
        ),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
        ),
      ),

    );
  }

}
