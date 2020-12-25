
import 'package:customer_app_java_support/blocs/thread_bloc/thread_bloc.dart';
import 'package:customer_app_java_support/models/thread_model.dart';
import 'package:customer_app_java_support/respositories/thread_repository.dart';
import 'package:customer_app_java_support/widgets/forum_screen/list_topic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'new_thread.dart';

class TopicAdd extends StatefulWidget {
  final List<Topic> topics;
  final ThreadRepository repository;
  final Function(bool) isCreated;

  TopicAdd({@required this.topics, @required this.repository, this.isCreated});

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
          itemCount: widget.topics.length,
          itemBuilder: (context, index) {
            Topic topic = widget.topics[index];
            return InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => BlocProvider(
                          create: (context) =>
                              ThreadBloc(repository: widget.repository),
                          child: NewThread(
                            isCreate: (bool _isCreated) {
                              if (_isCreated) {
                                widget.isCreated(true);
                              }
                            },
                            topic: topic,
                          ),
                        )),
              ),
              child: listTopic(topic),
            );
          },
        ),
      ),
    );
  }
}
