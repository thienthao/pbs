import 'package:customer_app_java_support/models/item_model.dart';
import 'package:flutter/material.dart';

Widget listThread(Item item) {
  return Card(
    elevation: 0.0,
    child: Padding(
      padding: EdgeInsets.all(25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            children: [
              Text(
                item.date,
                style: TextStyle(fontSize: 11.0, color: Colors.grey),
              ),
              SizedBox(width: 5.0),
              Text(
                '·',
                style: TextStyle(fontSize: 11.0, color: Colors.grey),
              ),
              SizedBox(width: 5.0),
              Text(
                item.author,
                style: TextStyle(fontSize: 11.0, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
