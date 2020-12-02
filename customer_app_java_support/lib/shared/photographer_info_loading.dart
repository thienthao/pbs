import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PhotographerInfoLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: Duration(milliseconds: 800),
      baseColor: Colors.grey[200],
      highlightColor: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///////////////////////////// Photographer info
          Stack(
            children: <Widget>[
              Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.25,
                transform: Matrix4.translationValues(0.0, -50.0, 0.0),
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    padding: EdgeInsets.only(left: 30.0),
                    onPressed: () => Navigator.pop(context),
                    icon: RotatedBox(
                      quarterTurns: 1,
                      child: Icon(
                        Icons.expand_more,
                        textDirection: TextDirection.ltr,
                      ),
                    ),
                    iconSize: 30.0,
                    color: Colors.white,
                  ),
                ],
              ),
              Positioned.fill(
                left: 30.0,
                right: 30.0,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 60,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 60,
                        child: Container(),
                      )),
                ),
              ),
              Positioned(
                  bottom: 10.0,
                  left: 160.0,
                  child: Container(
                    width: 200,
                    height: 20,
                    color: Colors.white,
                  )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22.0, 5.0, 0.0, 0.0),
            child: Container(
              width: 140,
              height: 25,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
