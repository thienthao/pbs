import 'dart:convert';
import 'dart:io';

import 'package:customer_app_java_support/globals.dart';
import 'package:customer_app_java_support/models/thread_model.dart';
import 'package:customer_app_java_support/shared/base_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ThreadApiClient {
  // final _baseUrl = 'https://pbs-webapi.herokuapp.com';
  final http.Client httpClient;

  ThreadApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<Thread>> all() async {
    final url = BaseApi.THREAD_URL;
    final response = await this.httpClient.get(url,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $globalCusToken'});
    try {
      if (response.statusCode == 200) {
        List<Thread> threads = List<Thread>();
        final json = jsonDecode(utf8.decode(response.bodyBytes));
        if (json != null) {
          json.forEach((element) {
            final thread = Thread.fromJson(element);
            threads.add(thread);
          });
        }
        return Future.value(threads);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized');
      } else {
        throw Exception("Error fetching threads");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Thread>> threadsByUser() async {
    final url = BaseApi.THREAD_URL + '/user/$globalCusId';
    final response = await this.httpClient.get(url,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $globalCusToken'});
    try {
      if (response.statusCode == 200) {
        List<Thread> threads = List<Thread>();
        final json = jsonDecode(utf8.decode(response.bodyBytes));
        if (json != null) {
          json.forEach((element) {
            final thread = Thread.fromJson(element);
            threads.add(thread);
          });
        }
        return Future.value(threads);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized');
      } else {
        throw Exception("Error fetching threads");
      }
    } catch (e) {
      throw e;
    }
  }

  Future<List<Topic>> allTopic() async {
    final url = BaseApi.THREAD_TOPIC_URL;
    final response = await this.httpClient.get(url,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $globalCusToken'});

    if (response.statusCode != 200) {
      throw new Exception("Error fetching topics");
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
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
    final url = BaseApi.THREAD_URL;
    thread.createdAt = DateFormat('yyyy-MM-ddTHH:mm:ss')
        .format(DateTime.parse(thread.createdAt));
    final response = await this.httpClient.post(
          url,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            HttpHeaders.authorizationHeader: 'Bearer ' + globalCusToken
          },
          body: jsonEncode(thread.toJson()),
        );
    if (response.statusCode != 200) {
      return Future.value(false);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    }
    return Future.value(true);
  }

  Future<bool> editThread(Thread thread) async {
    final url = BaseApi.THREAD_URL;
    thread.updatedAt = DateFormat('yyyy-MM-ddTHH:mm:ss')
        .format(DateTime.parse(thread.updatedAt));
    final response = await this.httpClient.put(
          url,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            HttpHeaders.authorizationHeader: 'Bearer ' + globalCusToken
          },
          body: jsonEncode(thread.toJson()),
        );
    if (response.statusCode != 200) {
      return Future.value(false);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    }
    return Future.value(true);
  }

  Future<bool> deleteThread(int id) async {
    final url = BaseApi.THREAD_URL + '/$id';

    final response = await this.httpClient.delete(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer ' + globalCusToken
      },
    );
    if (response.statusCode != 200) {
      return Future.value(false);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    }
    return Future.value(true);
  }

  Future<bool> postComment(ThreadComment comment) async {
    final url = BaseApi.THREAD_URL + '/comments';
    print(jsonEncode(comment.toJson()));
    final response = await this.httpClient.post(url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer ' + globalCusToken
        },
        body: jsonEncode(comment.toJson()));
    if (response.statusCode != 200) {
      print(response.body);
      return Future.value(false);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    }
    return Future.value(true);
  }

  // List<Thread> threadsFromJson(String str)
  // => List<Thread>.from(jsonDecode(str)).map((jsonObj) { print(Thread.fromJson(jsonObj));return Thread.fromJson(jsonObj);});
}
