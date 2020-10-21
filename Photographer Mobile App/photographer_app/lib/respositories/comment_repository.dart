import 'dart:convert';
import 'package:photographer_app/models/comment_bloc_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
    final temp =
        baseUrl + 'bookings/photographer/' + id.toString() + '/comments';
    print('url $temp');

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
