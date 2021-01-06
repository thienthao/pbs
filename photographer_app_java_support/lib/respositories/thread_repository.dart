import 'package:flutter/cupertino.dart';
import 'package:photographer_app_java_support/models/thread_model.dart';
import 'package:photographer_app_java_support/respositories/thread_api_client.dart';

class ThreadRepository {
  final ThreadApiClient threadApiClient;

  ThreadRepository({@required this.threadApiClient})
      : assert(threadApiClient != null);

  Future<List<Thread>> all() async {
    return await threadApiClient.all();
  }

  Future<List<Thread>> threadsByUser() async {
    return await threadApiClient.threadsByUser();
  }

  Future<bool> postThread(Thread thread) async {
    // return await threadApiClient.postThread(thread);
    return Future.value(await threadApiClient.postThread(thread));
  }

  Future<bool> editThread(Thread thread) async {
    print(thread.title);
    return Future.value(await threadApiClient.editThread(thread));
  }

  Future<bool> deleteThread(int id) async {
    return Future.value(await threadApiClient.deleteThread(id));
  }

  Future<bool> postComment(ThreadComment comment) async {
    return Future.value(await threadApiClient.postComment(comment));
  }
}
