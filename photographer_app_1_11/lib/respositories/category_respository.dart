import 'dart:convert';
import 'dart:io';

import 'package:photographer_app_1_11/models/category_bloc_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const baseUrl = 'https://pbs-webapi.herokuapp.com/api/';

class CategoryRepository {
  final http.Client httpClient;

  CategoryRepository({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<CategoryBlocModel>> getListCategory() async {
    final response =
        await this.httpClient.get(baseUrl + 'categories/', headers: {
      HttpHeaders.authorizationHeader: 'Bearer ' +
          'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0aG9jaHVwaGluaCIsImlhdCI6MTYwMjMwMzQ5NCwiZXhwIjoxNjE3ODU1NDk0fQ.25Oz4rCRj4pdX6GdpeWdwt1YT7fcY6YTKK8SywVyWheVPGpwB6641yHNz7U2JwlgNUtI3FE89Jf8qwWUXjfxRg'
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as List;

      final List<CategoryBlocModel> categories = data.map((category) {
        return CategoryBlocModel(
          id: category['id'],
          category: category['category'].toString(),
          iconLink: category['iconLink'].toString(),
        );
      }).toList();
      return categories;
    } else {
      throw Exception('Error getting list of categories');
    }
  }
}
