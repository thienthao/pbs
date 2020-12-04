import 'package:photographer_app_java_support/models/thread_model.dart';
import 'package:photographer_app_java_support/respositories/thread_api_client.dart';
import 'package:flutter/cupertino.dart';

class ThreadRepository {
  final ThreadApiClient threadApiClient;

  ThreadRepository({@required this.threadApiClient})
      : assert(threadApiClient != null);

  Future<List<Thread>> all() async {
    return await threadApiClient.all();
  }

  Future<bool> postThread(Thread thread) async {
    // return await threadApiClient.postThread(thread);
    return Future.value(await threadApiClient.postThread(thread));
  }

  Future<bool> postComment(ThreadComment comment) async {
    return Future.value(await threadApiClient.postComment(comment));
  }
}
