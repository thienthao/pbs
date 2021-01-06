import 'dart:convert';
import 'dart:io';

import 'package:customer_app_java_support/globals.dart';
import 'package:customer_app_java_support/models/album_bloc_model.dart';
import 'package:customer_app_java_support/models/category_bloc_model.dart';
import 'package:customer_app_java_support/models/image_bloc_model.dart';
import 'package:customer_app_java_support/models/photographer_bloc_model.dart';
import 'package:customer_app_java_support/shared/base_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const baseUrl = 'https://pbs-webapi.herokuapp.com/api/';

class AlbumRepository {
  final http.Client httpClient;

  AlbumRepository({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<AlbumBlocModel>> getListAlbum(int categoryId) async {
    final response = await this.httpClient.get(
        BaseApi.ALBUM_URL + '?categoryId=$categoryId',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $globalCusToken'});
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
        List<ImageBlocModel> images = List<ImageBlocModel>();
        if (imageTemp != null) {
          images = imageTemp.map((image) {
            return ImageBlocModel(
              id: image['id'],
              imageLink: image['imageLink'],
            );
          }).toList();
        }

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
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Error getting list of albums');
    }
  }

  Future<List<AlbumBlocModel>> getInfiniteListAlbum(int page, int size) async {
    final response = await this.httpClient.get(
        BaseApi.ALBUM_URL + '/?page=$page&size=$size',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $globalCusToken'});
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
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Error getting list of albums');
    }
  }

  Future<List<AlbumBlocModel>> getAlbumOfPhotographer(int id) async {
    final response = await this.httpClient.get(
      BaseApi.ALBUM_URL + '/photographer/$id',
      headers: {HttpHeaders.authorizationHeader: 'Bearer $globalCusToken'},
    );
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
              ? ''
              : album['location'].toString(),
          likes: album['likes'] == null ? 0 : album['likes'],
          createdAt: album['createdAt'],
          category: category,
          images: images,
          photographer: photographer,
          isActive: album['isActive'],
        );
      }).toList();
      return albums;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Error getting list of albums');
    }
  }

  Future<bool> isLikedAlbum(int albumId) async {
    final response = await this.httpClient.get(
      BaseApi.ALBUM_URL + '/like?albumId=$albumId&userId=$globalCusId',
      headers: {HttpHeaders.authorizationHeader: 'Bearer $globalCusToken'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data;
    } else {
      throw Exception('Error getting album like');
    }
  }

  Future<bool> likeAlbum(int albumId) async {
    final response = await this.httpClient.post(
      BaseApi.ALBUM_URL + '/like?albumId=$albumId&userId=$globalCusId',
      headers: {HttpHeaders.authorizationHeader: 'Bearer $globalCusToken'},
    );
    print(albumId);
    bool isLike = false;
    if (response.statusCode == 200) {
      isLike = true;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Error at like album');
    }
    print('isLike: $isLike');
    return isLike;
  }

  Future<bool> unlikeAlbum(int albumId) async {
    final response = await this.httpClient.post(
      BaseApi.ALBUM_URL + '/unlike?albumId=$albumId&userId=$globalCusId',
      headers: {HttpHeaders.authorizationHeader: 'Bearer $globalCusToken'},
    );
    bool isUnlike = false;
    if (response.statusCode == 200) {
      isUnlike = true;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Error at unlike album');
    }
    print('isUnlike: $isUnlike');
    return isUnlike;
  }
}
