import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class InfoLoading extends StatelessWidget {
  Widget _body(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: <Widget>[
            Shimmer.fromColors(
              period: Duration(milliseconds: 1100),
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[500],
              child: ClipPath(
                clipper: CustomShape(),
                child: Container(
                  color: Colors.red,
                  height: 290.0,
                  width: double.infinity,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Stack(
                    children: [
                      Shimmer.fromColors(
                        period: Duration(milliseconds: 1100),
                        baseColor: Colors.grey[350],
                        highlightColor: Colors.grey[500],
                        child: Container(
                          margin: EdgeInsets.only(top: 150.0), //10
                          height: 140.0, //140
                          width: 140.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.green,
                              width: 8.0, //8
                            ),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/avatars/man.jpg'),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 100.0, top: 250.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.black54,
                          child: IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0), //5
                  Shimmer.fromColors(
                    period: Duration(milliseconds: 1100),
                    baseColor: Colors.grey[350],
                    highlightColor: Colors.grey[500],
                    child: Container(
                      width: 100,
                      height: 25,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(height: 15.0), //5
                  Shimmer.fromColors(
                    period: Duration(milliseconds: 1100),
                    baseColor: Colors.grey[350],
                    highlightColor: Colors.grey[500],
                    child: Wrap(
                      children: [
                        SizedBox(height: 20.0), //5
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 45,
                                  height: 18,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(3)),
                                ),
                                SizedBox(height: 5.0),
                                Container(
                                  width: 30,
                                  height: 16,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(3)),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  width: 45,
                                  height: 18,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(3)),
                                ),
                                SizedBox(height: 5.0),
                                Container(
                                  width: 30,
                                  height: 16,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(3)),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  width: 45,
                                  height: 18,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(3)),
                                ),
                                SizedBox(height: 5.0),
                                Container(
                                  width: 30,
                                  height: 16,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(3)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        SizedBox(
          height: 30,
        ),
        Shimmer.fromColors(
          period: Duration(milliseconds: 1100),
          baseColor: Colors.grey[350],
          highlightColor: Colors.grey[500],
          child: Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        color: Colors.redAccent,
                        height: 25,
                        width: 25,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                          color: Colors.redAccent,
                          height: 25,
                          width: MediaQuery.of(context).size.width * 0.8),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        color: Colors.redAccent,
                        height: 25,
                        width: 25,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                          color: Colors.redAccent,
                          height: 25,
                          width: MediaQuery.of(context).size.width * 0.8),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        color: Colors.redAccent,
                        height: 25,
                        width: 25,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                          color: Colors.redAccent,
                          height: 25,
                          width: MediaQuery.of(context).size.width * 0.8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _body(context),
    );
  }
}

class CustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double height = size.height;
    double width = size.width;
    path.lineTo(0, height - 100);
    path.quadraticBezierTo(width / 2, height, width, height - 100);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
