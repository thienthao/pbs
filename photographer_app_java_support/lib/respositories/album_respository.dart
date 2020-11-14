import 'dart:convert';
import 'dart:io';

import 'package:photographer_app_java_support/models/album_bloc_model.dart';
import 'package:photographer_app_java_support/models/category_bloc_model.dart';
import 'package:photographer_app_java_support/models/image_bloc_model.dart';
import 'package:photographer_app_java_support/models/photographer_bloc_model.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

const baseUrl = 'https://pbs-webapi.herokuapp.com/api/albums/';

class AlbumRepository {
  final http.Client httpClient;

  AlbumRepository({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<AlbumBlocModel>> getListAlbum() async {
    final response = await this.httpClient.get(baseUrl + '?size=20', headers: {
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

  Future<List<AlbumBlocModel>> getAlbumOfPhotographer(int id) async {
    final response = await this.httpClient.get(
          baseUrl + 'photographer/' + id.toString() + '?page=0&size=15',
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

  Future<bool> createAlbum(
      AlbumBlocModel album, File thumbnail, List<File> images) async {
    var request = http.MultipartRequest("POST", Uri.parse(baseUrl));

    if (thumbnail == null) {
      request.files.add(http.MultipartFile(
          'file',
          File(images[0].path).readAsBytes().asStream(),
          File(images[0].path).lengthSync(),
          filename: images[0].path.split("/").last,
          contentType: new MediaType('image', 'jpeg')));
    } else {
      request.files.add(http.MultipartFile(
          'file',
          File(thumbnail.path).readAsBytes().asStream(),
          File(thumbnail.path).lengthSync(),
          filename: thumbnail.path.split("/").last,
          contentType: new MediaType('image', 'jpeg')));
    }

    for (var image in images) {
      // String imagePath = image.path.split('/').last;
      request.files.add(http.MultipartFile(
          'files',
          File(image.path).readAsBytes().asStream(),
          File(image.path).lengthSync(),
          filename: image.path.split("/").last,
          contentType: new MediaType('image', 'jpeg')));
    }

    String albumDto =
        '{"name":"${album.name}","description":"${album.description}","ptgId":${album.photographer.id}}';
    request.fields['stringAlbumDto'] = albumDto;

    final response = await request.send();

    bool result = false;
    if (response.statusCode == 201) {
      print("Uploaded!");
      result = true;
    } else {
      throw Exception('Error at create album!');
    }
    return result;
  }
}
