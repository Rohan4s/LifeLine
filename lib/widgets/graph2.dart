import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lifeline/entities/pressureClass.dart';
import 'package:lifeline/entities/weightClass.dart';
import 'package:lifeline/pages/pressure.dart';

class LineChartWidget2 extends StatefulWidget {

  final List<PressureClass> pressures;
  const LineChartWidget2({super.key, required this.pressures});

  @override
  State<LineChartWidget2> createState() => _LineChartWidget2State();
}

class _LineChartWidget2State extends State<LineChartWidget2> {

  List<FlSpot> systolicSpots = [];
  List<FlSpot> diastolicSpots =[];
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
    const bgColor = Colors.white;
    const Color curveColor = Colors.grey;
    double maxX = 10, minX = 1, maxY = 0, minY = 100000;

    systolicSpots.clear();
    diastolicSpots.clear();

    for (int i = 0; i < widget.pressures.length; i++) {
      int systolic = widget.pressures[i].systolicPressure;
      int diastolic = widget.pressures[i].diastolicPressure;

      systolicSpots.add(FlSpot((i+1).toDouble(), systolic*1.0));
      diastolicSpots.add(FlSpot((i+1).toDouble(), diastolic*1.0));

      if ( systolic > maxY) maxY = systolic*1.0;
      if ( diastolic > maxY) maxY = diastolic*1.0;

      if(systolic < minY) minY = systolic*1.0;
      if(diastolic < minY) minY = diastolic*1.0;
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


    intervalY = 20;

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
                spots: systolicSpots,

                isCurved: false,
                color: curveColor,
                barWidth: 3,
                belowBarData: BarAreaData(
                  show: false,
                  color: belowCurveColor,
                ),

              ),
              LineChartBarData(
                spots: diastolicSpots,

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
          interval: 10,
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
