import 'dart:convert';
import 'dart:io';

import 'package:photographer_app_java_support/globals.dart';
import 'package:photographer_app_java_support/models/category_bloc_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:photographer_app_java_support/widgets/shared/base_api.dart';

const baseUrl = 'https://pbs-webapi.herokuapp.com/api/';

class CategoryRepository {
  final http.Client httpClient;

  CategoryRepository({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<CategoryBlocModel>> getListCategory() async {
    final response = await this.httpClient.get(BaseApi.CATEGORY_URL,
        headers: {HttpHeaders.authorizationHeader: 'Bearer ' + globalPtgToken});
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
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Error getting list of categories');
    }
  }
}
