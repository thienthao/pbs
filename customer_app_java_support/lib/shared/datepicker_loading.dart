import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DatePickerLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: Duration(milliseconds: 800),
      baseColor: Colors.grey[200],
      highlightColor: Colors.grey[100],
      child: Column(
        children: [
          SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.only(left:15.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 150,
                height: 35,
                padding: EdgeInsets.only(left: 12, top: 20.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
          SizedBox(height: 3.0),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(30.0),
            ),
            margin: const EdgeInsets.only(left: 15.0, right: 290.0),
            height: 3.0,
          ),
          Container(
            height: 390,
            margin: EdgeInsets.all(15.0),
            padding: EdgeInsets.all(7.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0.0, 2.0),
                      blurRadius: 6.0)
                ]),
          ),
          SizedBox(height: 10.0),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 30,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(3.0),
              ),
            ),
          ),
          SizedBox(height: 30.0),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
          SizedBox(height: 30.0),
        ],
      ),
    );
  }
}
