import 'dart:convert';
import 'dart:io';

import 'package:customer_app_java_support/models/album_bloc_model.dart';
import 'package:customer_app_java_support/models/category_bloc_model.dart';
import 'package:customer_app_java_support/models/image_bloc_model.dart';
import 'package:customer_app_java_support/models/photographer_bloc_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const baseUrl = 'https://pbs-webapi.herokuapp.com/api/';

class AlbumRepository {
  final http.Client httpClient;

  AlbumRepository({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<AlbumBlocModel>> getListAlbum(int categoryId) async {
    final response = await this
        .httpClient
        .get(baseUrl + 'albums?categoryId=$categoryId', headers: {
      HttpHeaders.authorizationHeader: 'Bearer ' +
          'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0aG9jaHVwaGluaCIsImlhdCI6MTYwMjMwMzQ5NCwiZXhwIjoxNjE3ODU1NDk0fQ.25Oz4rCRj4pdX6GdpeWdwt1YT7fcY6YTKK8SywVyWheVPGpwB6641yHNz7U2JwlgNUtI3FE89Jf8qwWUXjfxRg'
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      final list = data['albums'] as List;
      final List<AlbumBlocModel> albums = list.map((album) {
        final categoryTemp = album['category'] as Map;
        dynamic category;
        if (categoryTemp != null) {
          category = new CategoryBlocModel(
              id: categoryTemp['id'], category: categoryTemp['category']);
        } else {
          category = new CategoryBlocModel(id: 0, category: 'Khác');
        }
        final photographerTemp = album['photographer'] as Map;
        final photographer = new Photographer(
            id: photographerTemp['id'],
            fullname: photographerTemp['fullname'],
            avatar: photographerTemp['avatar']);

        final imageTemp = album['images'] as List;

        final images = imageTemp.map((image) {
          return ImageBlocModel(
            id: image['id'],
            imageLink: image['imageLink'],
          );
        }).toList();
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
            images: images);
      }).toList();

      return albums;
    } else {
      throw Exception('Error getting list of albums');
    }
  }

  Future<List<AlbumBlocModel>> getInfiniteListAlbum(int page, int size) async {
    final response = await this
        .httpClient
        .get(baseUrl + 'albums/?page=$page&size=$size', headers: {
      HttpHeaders.authorizationHeader: 'Bearer ' +
          'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0aG9jaHVwaGluaCIsImlhdCI6MTYwMjMwMzQ5NCwiZXhwIjoxNjE3ODU1NDk0fQ.25Oz4rCRj4pdX6GdpeWdwt1YT7fcY6YTKK8SywVyWheVPGpwB6641yHNz7U2JwlgNUtI3FE89Jf8qwWUXjfxRg'
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      final list = data['albums'] as List;
      final List<AlbumBlocModel> albums = list.map((album) {
        final categoryTemp = album['category'] as Map;
        dynamic category;
        if (categoryTemp != null) {
          category = new CategoryBlocModel(
              id: categoryTemp['id'], category: categoryTemp['category']);
        } else {
          category = new CategoryBlocModel(id: 0, category: 'Khác');
        }
        final photographerTemp = album['photographer'] as Map;
        final photographer = new Photographer(
            id: photographerTemp['id'],
            fullname: photographerTemp['fullname'],
            avatar: photographerTemp['avatar']);

        final imageTemp = album['images'] as List;

        final images = imageTemp.map((image) {
          return ImageBlocModel(
            id: image['id'],
            imageLink: image['imageLink'],
          );
        }).toList();
        return AlbumBlocModel(
            id: album['id'],
            name: album['name'].toString(),
            thumbnail: album['thumbnail'].toString(),
            description: album['description'].toString(),
            location: album['location'].toString(),
            likes: album['likes'] ?? 0,
            photographer: photographer,
            category: category,
            isActive: album['isActive'],
            images: images);
      }).toList();

      return albums;
    } else {
      throw Exception('Error getting list of albums');
    }
  }

  Future<List<AlbumBlocModel>> getAlbumOfPhotographer(int id) async {
    print('photograper os album');
    final response = await this.httpClient.get(
          baseUrl + 'albums/photographer/' + id.toString(),
        );
    final temp = baseUrl + 'albums/photographer/' + id.toString();
    print('url $temp');
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      final list = data['albums'] as List;
      final List<AlbumBlocModel> albums = list.map((album) {
        final categoryTemp = album['category'] as Map;
        dynamic category;
        if (categoryTemp != null) {
          category = new CategoryBlocModel(
              id: categoryTemp['id'], category: categoryTemp['category']);
        } else {
          category = new CategoryBlocModel(id: 0, category: 'Khác');
        }
        final photographerTemp = album['photographer'] as Map;
        final photographer = new Photographer(
            id: photographerTemp['id'],
            fullname: photographerTemp['fullname'],
            avatar: photographerTemp['avatar']);
        final imageTemp = album['images'] as List;

        final images = imageTemp.map((image) {
          return ImageBlocModel(
            id: image['id'],
            imageLink: image['imageLink'],
          );
        }).toList();
        return AlbumBlocModel(
          id: album['id'],
          name: album['name'].toString(),
          thumbnail: album['thumbnail'].toString(),
          description: album['description'].toString(),
          location: album['location'].toString().length == 0
              ? 'Sapa'
              : album['location'].toString(),
          likes: album['likes'] == null ? 223 : album['likes'],
          createAt: album['createAt'],
          category: category,
          images: images,
          photographer: photographer,
          isActive: album['isActive'],
        );
      }).toList();
      return albums;
    } else {
      throw Exception('Error getting list of photographers');
    }
  }
}
