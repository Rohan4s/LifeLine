import 'package:flutter/material.dart';

class Weight extends StatefulWidget {
  const Weight({Key? key}) : super(key: key);
  @override
  State<Weight> createState() => _WeightState();
}

class _WeightState extends State<Weight> {
  int height = 162;
  TextStyle textStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  Widget getCard() {
    return Card(
      color: Theme.of(context).primaryColorLight,
      // color: Colors.grey[300],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: 250,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('60kg',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Standard BMI",style: textStyle,),
                Text('Height: ${height}cm',style: textStyle),
                Text('BMI: 21.7',style: textStyle),
                Text('21-08-23',style: textStyle),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weight & BMI'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('Assets/weightbg.png'),
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                children: [
                  SizedBox(),
                ],
              ),
              flex: 3,
            ),
            Expanded(
              child: getCard(),
              flex: 1,
            ),
            Expanded(
              child: getCard(),
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}
