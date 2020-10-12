import 'dart:convert';
import 'dart:io';

import 'package:capstone_mock_1/models/album_bloc_model.dart';
import 'package:capstone_mock_1/models/category_bloc_model.dart';
import 'package:capstone_mock_1/models/photographer_bloc_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const baseUrl = 'https://pbs-webapi.herokuapp.com/api/';

class PhotographerRepository {
  final http.Client httpClient;

  PhotographerRepository({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<Photographer>> getListPhotographerByRating() async {
    final response = await this
        .httpClient
        .get(baseUrl + 'photographers/byrating?page=1&size=5', headers: {
      HttpHeaders.authorizationHeader: 'Bearer ' +
          'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0aG9jaHVwaGluaCIsImlhdCI6MTYwMjMwMzQ5NCwiZXhwIjoxNjE3ODU1NDk0fQ.25Oz4rCRj4pdX6GdpeWdwt1YT7fcY6YTKK8SywVyWheVPGpwB6641yHNz7U2JwlgNUtI3FE89Jf8qwWUXjfxRg'
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map;
      final list = data['users'] as List;

      final List<Photographer> photographers = list.map((photographer) {
        return Photographer(
          id: photographer['id'],
          fullname: photographer['fullname'].toString(),
          avatar: photographer['avatar'].toString(),
          ratingCount: photographer['ratingCount'],
        );
      }).toList();
      return photographers;
    } else {
      throw Exception('Error getting list of photographers');
    }
  }

  Future<Photographer> getPhotographerbyId(int id) async {
    final albumsTemp = getAlbumOfPhotographer(id) as List;
    print('it does go PhotographerbyId');
    final response =
        await this.httpClient.get(baseUrl + 'photographers/' + id.toString());
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      print(albumsTemp);
      final photographer = Photographer(
        id: data['id'],
        avatar: data['avatar'],
        description: data['description'],
        fullname: data['fullname'],
        ratingCount: data['ratingCount'],
        albums: albumsTemp,
      );
      print('day la $photographer ');
      return photographer;
    } else {
      throw Exception('Error getting photographer');
    }
  }

  Future<List<AlbumBlocModel>> getAlbumOfPhotographer(int id) async {
    print('photograper os album');
    final response = await this.httpClient.get(
          baseUrl + 'albums/photographer/1' ,
        );
    final temp = baseUrl + 'albums/photographer/' + id.toString();
    print('url $temp');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map;
      print(data);
      final list = data['albums'] as List;
      final List<AlbumBlocModel> albums = list.map((album) {
        final categoryTemp = album['category'] as Map;
        final category = new CategoryBlocModel(
            id: categoryTemp['id'], category: categoryTemp['category']);
        return AlbumBlocModel(
          id: album['id'],
          name: album['name'].toString(),
          thumbnail: album['thumbnail'].toString(),
          description: album['description'].toString(),
          location: album['location'].toString(),
          likes: album['likes'],
          category: category,
          isActive: album['isActive'],
        );
      }).toList();

      return albums;
    } else {
      throw Exception('Error getting list of photographers');
    }
  }
}
