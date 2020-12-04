import 'package:photographer_app_java_support/blocs/thread_bloc/thread_bloc.dart';
import 'package:photographer_app_java_support/models/thread_model.dart';
import 'package:photographer_app_java_support/respositories/thread_repository.dart';
import 'package:photographer_app_java_support/screens/forum_screen/new_thread.dart';
import 'package:photographer_app_java_support/widgets/forum_screen/list_topic.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopicAdd extends StatelessWidget {
  final List<Topic> topics;
  final ThreadRepository repository;

  TopicAdd({@required this.topics, @required this.repository});

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
                    builder: (_) => BlocProvider(
                          create: (context) =>
                              ThreadBloc(repository: repository),
                          child: NewThread(
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
