import 'dart:convert';
import 'dart:io';

import 'package:cus_2_11_app/models/photographer_bloc_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const baseUrl = 'https://pbs-webapi.herokuapp.com/api/photographers/';

class PhotographerRepository {
  final http.Client httpClient;

  PhotographerRepository({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<Photographer>> getListPhotographerByRating(int categoryId) async {
    final response = await this.httpClient.get(
        baseUrl + 'byrating?page=0&size=5&categoryId=$categoryId',
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ' +
              'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0aG9jaHVwaGluaCIsImlhdCI6MTYwMjMwMzQ5NCwiZXhwIjoxNjE3ODU1NDk0fQ.25Oz4rCRj4pdX6GdpeWdwt1YT7fcY6YTKK8SywVyWheVPGpwB6641yHNz7U2JwlgNUtI3FE89Jf8qwWUXjfxRg'
        });
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      final list = data['users'] as List;

      final List<Photographer> photographers = list.map((photographer) {
        return Photographer(
          id: photographer['id'],
          fullname: photographer['fullname'].toString(),
          avatar: photographer['avatar'].toString(),
          ratingCount: photographer['ratingCount'] == 0.0
              ? 4.7
              : photographer['ratingCount'],
        );
      }).toList();
      return photographers;
    } else {
      throw Exception('Error getting list of photographers');
    }
  }

  Future<List<Photographer>> getListPhotographerByFactorAlg() async {
    final response = await this.httpClient.get(baseUrl + 'byfactors', headers: {
      HttpHeaders.authorizationHeader: 'Bearer ' +
          'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0aG9jaHVwaGluaCIsImlhdCI6MTYwMjMwMzQ5NCwiZXhwIjoxNjE3ODU1NDk0fQ.25Oz4rCRj4pdX6GdpeWdwt1YT7fcY6YTKK8SywVyWheVPGpwB6641yHNz7U2JwlgNUtI3FE89Jf8qwWUXjfxRg'
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      final list = data['users'] as List;

      final List<Photographer> photographers = list.map((photographer) {
        return Photographer(
          id: photographer['id'],
          fullname: photographer['fullname'].toString(),
          avatar: photographer['avatar'].toString(),
          ratingCount: photographer['ratingCount'] == 0.0
              ? 4.7
              : photographer['ratingCount'],
        );
      }).toList();
      return photographers;
    } else {
      throw Exception('Error getting list of photographers');
    }
  }

  Future<List<Photographer>> getListPhotographerByRatingFilterdByCategoryId(
      int categoryId) async {
    final response = await this.httpClient.get(
        baseUrl + 'byrating?page=2&size=5&categoryId=$categoryId',
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ' +
              'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0aG9jaHVwaGluaCIsImlhdCI6MTYwMjMwMzQ5NCwiZXhwIjoxNjE3ODU1NDk0fQ.25Oz4rCRj4pdX6GdpeWdwt1YT7fcY6YTKK8SywVyWheVPGpwB6641yHNz7U2JwlgNUtI3FE89Jf8qwWUXjfxRg'
        });
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      final list = data['users'] as List;

      final List<Photographer> photographers = list.map((photographer) {
        return Photographer(
          id: photographer['id'],
          fullname: photographer['fullname'].toString(),
          avatar: photographer['avatar'].toString(),
          ratingCount: photographer['ratingCount'] == 0.0
              ? 4.7
              : photographer['ratingCount'],
        );
      }).toList();
      return photographers;
    } else {
      throw Exception('Error getting list of photographers');
    }
  }

  Future<List<Photographer>> getInfiniteListPhotographer(
      int page, int size) async {
    final response = await this
        .httpClient
        .get(baseUrl + 'byrating?page=$page&size=$size', headers: {
      HttpHeaders.authorizationHeader: 'Bearer ' +
          'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0aG9jaHVwaGluaCIsImlhdCI6MTYwMjMwMzQ5NCwiZXhwIjoxNjE3ODU1NDk0fQ.25Oz4rCRj4pdX6GdpeWdwt1YT7fcY6YTKK8SywVyWheVPGpwB6641yHNz7U2JwlgNUtI3FE89Jf8qwWUXjfxRg'
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      final list = data['users'] as List;

      final List<Photographer> photographers = list.map((photographer) {
        return Photographer(
          id: photographer['id'],
          fullname: photographer['fullname'].toString(),
          avatar: photographer['avatar'].toString(),
          ratingCount: photographer['ratingCount'] == 0.0
              ? 4.7
              : photographer['ratingCount'],
        );
      }).toList();
      return photographers;
    } else {
      throw Exception('Error getting list of photographers');
    }
  }

  Future<Photographer> getPhotographerbyId(int id) async {
    // final albumsTemp = getAlbumOfPhotographer(id) as List;
    final response = await this.httpClient.get(baseUrl + id.toString());
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));

      final photographer = Photographer(
        id: data['id'],
        avatar: data['avatar'],
        cover: data['cover'],
        description: data['description'],
        fullname: data['fullname'],
        ratingCount: data['ratingCount'],
        albums: [],
      );
      return photographer;
    } else {
      throw Exception('Error getting photographer');
    }
  }
}
