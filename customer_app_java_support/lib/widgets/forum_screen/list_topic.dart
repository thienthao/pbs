import 'package:customer_app_java_support/models/topic_model.dart';
import 'package:flutter/material.dart';

Widget listTopic(Topic topic) {
  return Card(
    elevation: 0.0,
    child: Padding(
      padding: EdgeInsets.all(25.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[200],
            ),
            height: 50,
            width: 50,
            child: Icon(Icons.category),
          ),
          SizedBox(width: 20.0),
          Text(
            topic.title,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}