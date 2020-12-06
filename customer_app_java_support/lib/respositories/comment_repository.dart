import 'dart:convert';

import 'package:customer_app_java_support/models/comment_bloc_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const baseUrl = 'https://pbs-webapi.herokuapp.com/api/';

class CommentRepository {
  final http.Client httpClient;

  CommentRepository({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<CommentBlocModel>> getCommentByPhotographerId(int id) async {
    final response = await this.httpClient.get(
          baseUrl +
              'bookings/photographer/' +
              id.toString() +
              '/comments?size=3',
        );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as List;

      final List<CommentBlocModel> comments = data.map((comment) {
        return CommentBlocModel(
          comment: comment['comment'],
          rating: comment['rating'],
          username: comment['username'],
          fullname: comment['fullname'],
          createdAt: comment['createdAt'],
          location: comment['location'],
          avatar: comment['avatar'],
        );
      }).toList();

      return comments;
    } else {
      throw Exception('Error getting list of comments');
    }
  }

  Future<bool> postComment(CommentBlocModel comment) async {
    var resBody = {};
    var bookingResBody = {};
    var userResBody = {};

    resBody["comment"] = comment.comment;

    resBody["rating"] = comment.rating;

    userResBody["id"] = comment.cusId;
    resBody["user"] = userResBody;

    bookingResBody["id"] = comment.bookingId;
    resBody["booking"] = bookingResBody;

    resBody["commentedAt"] = comment.createdAt;

    String str = json.encode(resBody);
    print(str);
    final response = await httpClient.post(
        baseUrl + 'bookings/${comment.bookingId}/comments/',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: str);

    bool result = false;
    if (response.statusCode == 200) {
      result = true;
    } else {
      throw Exception('Error at cancel a booking');
    }
    return result;
  }

  Future<List<CommentBlocModel>> getCommentByBookingId(int id) async {
    final response = await this.httpClient.get(
      baseUrl +
          'bookings/${id.toString()}/comments',
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      final List<CommentBlocModel> comments = data.map((comment) {
        return CommentBlocModel(
          comment: comment['comment'],
          rating: comment['rating'],
          username: comment['username'],
          fullname: comment['fullname'],
          createdAt: comment['createdAt'],
          location: comment['location'],
          avatar: comment['avatar'],
        );
      }).toList();

      return comments;
    } else {
      throw Exception('Error getting list of comments');
    }
  }
}
