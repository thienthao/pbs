import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreenCategoryLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: Duration(milliseconds: 800),
      baseColor: Colors.grey[200],
      highlightColor: Colors.grey[100],
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 220,
                  height: 15,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.grey[400],
                        Colors.grey[300],
                      ], // whitish to gray
                    ),
                    borderRadius: BorderRadius.circular(1.0),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.0),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(30.0),
            ),
            margin: const EdgeInsets.only(left: 21.0, right: 300.0),
            height: 3.0,
          ),
          SizedBox(height: 20.0),
          Padding(
            padding: EdgeInsets.only(left: 7.0),
            child: Container(
              height: 100.0,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20.0, right: 2.0),
                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.grey[500],
                              Colors.grey[300],
                            ], // whitish to gray
                          ),
                          // color: selected == index
                          //     ? Theme.of(context).accentColor
                          //     : Colors.grey[200],
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      SizedBox(height: 2.0),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 20.0,
                          top: 5,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.grey[400],
                                Colors.grey[300],
                              ], // whitish to gray
                            ),
                            borderRadius: BorderRadius.circular(1.0),
                          ),
                          width: 50,
                          height: 13,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
