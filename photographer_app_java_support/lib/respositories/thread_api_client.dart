import 'dart:convert';

import 'package:photographer_app_java_support/models/thread_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ThreadApiClient {
  final _baseUrl = 'https://pbs-webapi.herokuapp.com';
  final http.Client httpClient;

  ThreadApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<Thread>> all() async {
    final url = '$_baseUrl/api/threads';
    final response = await this.httpClient.get(url);

    List<Thread> threads = List<Thread>();

    try {
      if (response.statusCode != 200) {
        throw new Exception("Error fetching threads");
      }
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      if (json != null) {
        json.forEach((element) {
          final thread = Thread.fromJson(element);
          threads.add(thread);
        });
      }
    } catch (e) {
      print(e.toString());
    }

    return Future.value(threads);
  }

  Future<List<Topic>> allTopic() async {
    final url = '$_baseUrl/api/thread-topics';
    final response = await this.httpClient.get(url);

    if (response.statusCode != 200) {
      throw new Exception("Error fetching topics");
    }
    final json = jsonDecode(utf8.decode(response.bodyBytes));

    List<Topic> topics = List<Topic>();

    if (json != null) {
      json.forEach((element) {
        final topic = Topic.fromJson(element);
        topics.add(topic);
      });
    }

    return Future.value(topics);
  }

  Future<bool> postThread(Thread thread) async {
    final url = '$_baseUrl/api/threads';
    final response = await this.httpClient.post(
          url,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(thread.toJson()),
        );
    if (response.statusCode != 200) {
      return Future.value(false);
    }
    return Future.value(true);
  }

  Future<bool> postComment(ThreadComment comment) async {
    final url = '$_baseUrl/api/threads/comments';
    print(jsonEncode(comment.toJson()));
    final response = await this.httpClient.post(url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(comment.toJson()));
    if (response.statusCode != 200) {
      print(response.body);
      return Future.value(false);
    }
    return Future.value(true);
  }

  // List<Thread> threadsFromJson(String str)
  // => List<Thread>.from(jsonDecode(str)).map((jsonObj) { print(Thread.fromJson(jsonObj));return Thread.fromJson(jsonObj);});
}
