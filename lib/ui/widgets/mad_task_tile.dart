
import 'package:appointment/models/medicine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MedicineTile extends StatelessWidget {
  final Medicine? medicine;
  MedicineTile( this.medicine);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: 12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.indigo,
        ),
        child: Row(
          children: [
            Expanded(
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicine?.title??"",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),
                  SizedBox(height: 12,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey[200],
                        size: 18 ,
                      ),
                      SizedBox(width: 4,),
                      Text(
                        "${medicine!.time1}",
                        style:TextStyle(
                          fontSize: 13,
                          color: Colors.grey[100],
                        ) ,
                      )
                    ],
                  ),
                  SizedBox(width: 4,),
                  Text(
                    "${medicine!.time2}",
                    style:TextStyle(
                      fontSize: 13,
                      color: Colors.grey[100],
                    ) ,
                  ),
                  SizedBox(width: 4,),
                  Text(
                    "${medicine!.time3}",
                    style:TextStyle(
                      fontSize: 13,
                      color: Colors.grey[100],
                    ) ,
                  ),



                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              width: .5  ,
              color: Colors.grey[200]!.withOpacity(.7),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                medicine!.isCompleted==1?"COMPLETED":"REMAIN",
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
