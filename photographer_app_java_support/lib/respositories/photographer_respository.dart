import 'dart:convert';
import 'dart:io';

import 'package:photographer_app_java_support/models/location_bloc_model.dart';
import 'package:photographer_app_java_support/models/photographer_bloc_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

const baseUrl = 'https://pbs-webapi.herokuapp.com/api/photographers/';

class PhotographerRepository {
  final http.Client httpClient;

  PhotographerRepository({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<Photographer>> getListPhotographerByRating() async {
    final response =
        await this.httpClient.get(baseUrl + 'byrating?page=1&size=5', headers: {
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
        email: data['email'],
        phone: data['phone'],
        cover: data['cover'],
        // bookedNumber: data['booked'],
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

  Future<bool> updateProfile(
      Photographer photographer, List<LocationBlocModel> locations) async {
    var resBody = {};
    var listLocation = [];
    resBody["id"] = photographer.id;
    resBody["fullname"] = photographer.fullname;
    resBody["description"] = photographer.description;
    resBody["email"] = photographer.email;
    resBody["phone"] = photographer.phone;

    for (var item in locations) {
      var location = {};
      if (item.id != null) {
        location["id"] = item.id;
      }
      location["formattedAddress"] = item.formattedAddress;
      location["latitude"] = item.latitude;
      location["longitude"] = item.longitude;
      listLocation.add(location);
    }
    resBody["locations"] = listLocation;
    String str = json.encode(resBody);

    final response = await httpClient.post(baseUrl,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer ' +
              'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0aG9jaHVwaGluaCIsImlhdCI6MTYwMjMwMzQ5NCwiZXhwIjoxNjE3ODU1NDk0fQ.25Oz4rCRj4pdX6GdpeWdwt1YT7fcY6YTKK8SywVyWheVPGpwB6641yHNz7U2JwlgNUtI3FE89Jf8qwWUXjfxRg'
        },
        body: str);
    print(str);
    bool result = false;
    if (response.statusCode == 200) {
      result = true;
    } else {
      throw Exception('Error at Update Photographer info');
    }

    return result;
  }

  Future<bool> updateAvatar(File avatar) async {
    var request =
        http.MultipartRequest("POST", Uri.parse(baseUrl + '168/upload'));

    request.files.add(http.MultipartFile(
        'file',
        File(avatar.path).readAsBytes().asStream(),
        File(avatar.path).lengthSync(),
        filename: avatar.path.split("/").last,
        contentType: new MediaType('image', 'jpeg')));

    final response = await request.send();

    bool result = false;
    if (response.statusCode == 200) {
      print("Avatar Uploaded!");
      result = true;
    } else {
      throw Exception('Error at update avatar!');
    }
    return result;
  }

  Future<bool> updateCover(File cover) async {
    var request =
        http.MultipartRequest("POST", Uri.parse(baseUrl + '168/cover/upload'));

    request.files.add(http.MultipartFile(
        'file',
        File(cover.path).readAsBytes().asStream(),
        File(cover.path).lengthSync(),
        filename: cover.path.split("/").last,
        contentType: new MediaType('image', 'jpeg')));

    final response = await request.send();

    bool result = false;
    if (response.statusCode == 200) {
      print("Cover Uploaded!");
      result = true;
    } else {
      throw Exception('Error at create album!');
    }
    return result;
  }

  Future<List<LocationBlocModel>> getPhotographerLocations(int ptgId) async {
    final response = await this.httpClient.get(baseUrl + '$ptgId/locations');
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      final locations = data.map((location) {
        return LocationBlocModel(
            id: location['id'],
            formattedAddress: location['formattedAddress'],
            latitude: location['latitude'],
            longitude: location['longitude']);
      }).toList();
      return locations;
    } else {
      throw Exception();
    }
  }
}
