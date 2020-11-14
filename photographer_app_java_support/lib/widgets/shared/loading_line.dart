import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingLine extends StatefulWidget {
  @override
  _LoadingLineState createState() => _LoadingLineState();
}

class _LoadingLineState extends State<LoadingLine> {
  Timer _timer;
  List<double> listInt = [
    350,
    180,
    300,
    420,
    350,
    290,
    150,
    300,
    200,
    340,
    200
  ];
  _changeLines() {
    try {
      _timer = new Timer(const Duration(milliseconds: 1500), () {
        setState(() {
          listInt.shuffle();
          listInt.add(50);
        });
      });
    } catch (e) {}
  }

  _changeLines2() {
    try {
      _timer = new Timer(const Duration(milliseconds: 4000), () {
        setState(() {
          listInt.shuffle();
          listInt.add(50);
        });
      });
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    _changeLines();
    _changeLines2();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
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
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1000),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(child: child, opacity: animation);
      },
      child: Shimmer.fromColors(
        key: ValueKey<int>(listInt.length),
        period: Duration(milliseconds: 2000),
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[500],
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 5, 12, 0),
          child: Wrap(
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
                  width: listInt[3],
                  height: 14,
                  decoration: BoxDecoration(
                      color: listColor[0],
                      borderRadius: BorderRadius.circular(3)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
