import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:photographer_app_java_support/globals.dart';
import 'package:photographer_app_java_support/models/comment_bloc_model.dart';
import 'package:photographer_app_java_support/widgets/shared/base_api.dart';

const baseUrl = 'https://pbs-webapi.herokuapp.com/api/';

class CommentRepository {
  final http.Client httpClient;

  CommentRepository({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<CommentBlocModel>> getCommentByPhotographerId(int id) async {
    final response = await this.httpClient.get(
          BaseApi.BOOKING_URL + '/photographer/$globalPtgId/comments?size=3',
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

  Future<List<CommentBlocModel>> getCommentByBookingId(int id) async {
    final response = await this.httpClient.get(
        BaseApi.BOOKING_URL + '/$id/comments',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $globalPtgToken'});
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
