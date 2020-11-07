import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<double> listInt = [350, 180, 300, 420, 350, 290, 150, 300, 200, 340];
    List<Color> listColor = [
      Colors.redAccent,
      Colors.greenAccent,
      Colors.blueAccent,
      Colors.yellowAccent,
      Colors.cyanAccent,
      Colors.amberAccent,
      Colors.indigoAccent,
      Colors.lightGreenAccent,
      Colors.pinkAccent,
      Colors.purpleAccent
    ];
    listInt.shuffle();
    return Shimmer.fromColors(
      period: Duration(milliseconds: 800),
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[500],
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: new Container(
                width: listInt[0],
                height: 14,
                decoration: BoxDecoration(
                    color: listColor[0],
                    borderRadius: BorderRadius.circular(3)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                width: listInt[1],
                height: 14,
                decoration: BoxDecoration(
                    color: listColor[0],
                    borderRadius: BorderRadius.circular(3)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                width: listInt[2],
                height: 14,
                decoration: BoxDecoration(
                    color: listColor[0],
                    borderRadius: BorderRadius.circular(3)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                width: listInt[3],
                height: 14,
                decoration: BoxDecoration(
                    color: listColor[0],
                    borderRadius: BorderRadius.circular(3)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                width: listInt[4],
                height: 14,
                decoration: BoxDecoration(
                    color: listColor[0],
                    borderRadius: BorderRadius.circular(3)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                width: listInt[5],
                height: 14,
                decoration: BoxDecoration(
                    color: listColor[0],
                    borderRadius: BorderRadius.circular(3)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                width: listInt[6],
                height: 14,
                decoration: BoxDecoration(
                    color: listColor[0],
                    borderRadius: BorderRadius.circular(3)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                width: listInt[9],
                height: 14,
                decoration: BoxDecoration(
                    color: listColor[0],
                    borderRadius: BorderRadius.circular(3)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                width: listInt[7],
                height: 14,
                decoration: BoxDecoration(
                    color: listColor[0],
                    borderRadius: BorderRadius.circular(3)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                width: listInt[0],
                height: 14,
                decoration: BoxDecoration(
                    color: listColor[0],
                    borderRadius: BorderRadius.circular(3)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                width: listInt[2],
                height: 14,
                decoration: BoxDecoration(
                    color: listColor[0],
                    borderRadius: BorderRadius.circular(3)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                width: listInt[9],
                height: 14,
                decoration: BoxDecoration(
                    color: listColor[0],
                    borderRadius: BorderRadius.circular(3)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                width: listInt[6],
                height: 14,
                decoration: BoxDecoration(
                    color: listColor[0],
                    borderRadius: BorderRadius.circular(3)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                width: listInt[8],
                height: 14,
                decoration: BoxDecoration(
                    color: listColor[0],
                    borderRadius: BorderRadius.circular(3)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                width: listInt[5],
                height: 14,
                decoration: BoxDecoration(
                    color: listColor[0],
                    borderRadius: BorderRadius.circular(3)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                width: listInt[2],
                height: 14,
                decoration: BoxDecoration(
                    color: listColor[8],
                    borderRadius: BorderRadius.circular(3)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                width: listInt[3],
                height: 14,
                decoration: BoxDecoration(
                    color: listColor[1],
                    borderRadius: BorderRadius.circular(3)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                width: listInt[4],
                height: 14,
                decoration: BoxDecoration(
                    color: listColor[1],
                    borderRadius: BorderRadius.circular(3)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                width: listInt[7],
                height: 14,
                decoration: BoxDecoration(
                    color: listColor[6],
                    borderRadius: BorderRadius.circular(3)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                width: listInt[8],
                height: 14,
                decoration: BoxDecoration(
                    color: listColor[0],
                    borderRadius: BorderRadius.circular(3)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                width: listInt[2],
                height: 14,
                decoration: BoxDecoration(
                    color: listColor[0],
                    borderRadius: BorderRadius.circular(3)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                width: listInt[7],
                height: 14,
                decoration: BoxDecoration(
                    color: listColor[0],
                    borderRadius: BorderRadius.circular(3)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
