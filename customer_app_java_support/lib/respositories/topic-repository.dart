

import 'package:customer_app_java_support/models/thread_model.dart';
import 'package:customer_app_java_support/respositories/thread_api_client.dart';
import 'package:flutter/cupertino.dart';

class TopicRepository {
  final ThreadApiClient threadApiClient;

  TopicRepository({@required this.threadApiClient})
      : assert(threadApiClient != null);

  Future<List<Topic>> all() async {
    print("topicrepo");
    return await threadApiClient.allTopic();
  }
}