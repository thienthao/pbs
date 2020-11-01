import 'package:customer_app_1_11/shared/loading%20copy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent, //background color of container
      child: Align(
          alignment: Alignment.centerLeft,
          child: SpinKitPulse(
            color: Theme.of(context).primaryColor,
            size: 50.0,
          )),
    );
  }
}
