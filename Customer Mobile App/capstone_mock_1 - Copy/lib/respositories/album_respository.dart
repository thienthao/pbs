import 'dart:convert';
import 'dart:io';

import 'package:capstone_mock_1/models/album_bloc_model.dart';
import 'package:capstone_mock_1/models/category_bloc_model.dart';
import 'package:capstone_mock_1/models/photographer_bloc_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const baseUrl = 'https://pbs-webapi.herokuapp.com/api/';

class AlbumRepository {
  final http.Client httpClient;

  AlbumRepository({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<AlbumBlocModel>> getListAlbum() async {
    final response = await this
        .httpClient
        .get(baseUrl + 'albums/photographer/1?page=2&size=3', headers: {
      HttpHeaders.authorizationHeader: 'Bearer ' +
          'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0aG9jaHVwaGluaCIsImlhdCI6MTYwMjMwMzQ5NCwiZXhwIjoxNjE3ODU1NDk0fQ.25Oz4rCRj4pdX6GdpeWdwt1YT7fcY6YTKK8SywVyWheVPGpwB6641yHNz7U2JwlgNUtI3FE89Jf8qwWUXjfxRg'
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map;
      final list = data['albums'] as List;
      final List<AlbumBlocModel> albums = list.map((album) {
        final photographerTemp = album['photographer'] as Map;
        final categoryTemp = album['category'] as Map;
        final category = new CategoryBlocModel(
            id: categoryTemp['id'], category: categoryTemp['category']);

        final photographer = new Photographer(
            id: photographerTemp['id'],
            fullname: photographerTemp['fullname'],
            avatar: photographerTemp['avatar']);
        return AlbumBlocModel(
          id: album['id'],
          name: album['name'].toString(),
          thumbnail: album['thumbnail'].toString(),
          description: album['description'].toString(),
          location: album['location'].toString(),
          likes: album['likes'],
          photographer: photographer,
          category: category,
          isActive: album['isActive'],
        );
      }).toList();

      return albums;
    } else {
      throw Exception('Error getting list of albums');
    }
  }
}
