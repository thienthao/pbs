import 'package:customer_app_java_support/models/topic_model.dart';
import 'package:customer_app_java_support/screens/forum_screen/new_thread.dart';
import 'package:customer_app_java_support/widgets/forum_screen/list_topic.dart';

import 'package:flutter/material.dart';

class TopicAdd extends StatefulWidget {
  @override
  _TopicAddState createState() => _TopicAddState();
}

class _TopicAddState extends State<TopicAdd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chọn danh mục'),
        centerTitle: true,
        backgroundColor: Color(0xFFFAFAFA),
        elevation: 0.0,
      ),
      body: Container(
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: topics.length,
          itemBuilder: (context, index) {
            Topic topic = topics[index];
            return InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NewThread(
                    topic: topic,
                  ),
                ),
              ),
              child: listTopic(topics[index]),
            );
          },
        ),
      ),
    );
  }
}
