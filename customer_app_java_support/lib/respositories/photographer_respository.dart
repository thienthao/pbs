import 'dart:convert';
import 'dart:io';

import 'package:customer_app_java_support/models/package_bloc_model.dart';
import 'package:customer_app_java_support/models/photographer_bloc_model.dart';
import 'package:customer_app_java_support/models/search_bloc_model.dart';
import 'package:customer_app_java_support/models/service_bloc_model.dart';
import 'package:customer_app_java_support/shared/base_api.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

const baseUrl = 'https://pbs-webapi.herokuapp.com/api/photographers/';

class PhotographerRepository {
  final http.Client httpClient;

  PhotographerRepository({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<Photographer>> getListPhotographerByRating(
      int categoryId, LatLng latLng, String city) async {
    final response = await this.httpClient.get(
        BaseApi.PHOTOGRAPHER_URL + 'byrating?categoryId=$categoryId&city=$city',
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ' +
              'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0aG9jaHVwaGluaCIsImlhdCI6MTYwMjMwMzQ5NCwiZXhwIjoxNjE3ODU1NDk0fQ.25Oz4rCRj4pdX6GdpeWdwt1YT7fcY6YTKK8SywVyWheVPGpwB6641yHNz7U2JwlgNUtI3FE89Jf8qwWUXjfxRg'
        });

    print(baseUrl + 'byrating?categoryId=$categoryId&city=$city');
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      final list = data['users'] as List;

      final List<Photographer> photographers = list.map((photographer) {
        return Photographer(
          id: photographer['id'],
          fullname: photographer['fullname'].toString(),
          avatar: photographer['avatar'].toString(),
          booked: photographer['booked'],
          description: photographer['description'],
          ratingCount: photographer['ratingCount'] == 0.0
              ? 4.7
              : photographer['ratingCount'],
        );
      }).toList();
      print(photographers);
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
          booked: photographer['booked'],
          description: photographer['description'],
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
          booked: photographer['booked'],
          description: photographer['description'],
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
          booked: photographer['booked'],
          description: photographer['description'],
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

  Future<SearchModel> findPhotographerAndPackages(
      String search, int page, int size) async {
    final response = await this
        .httpClient
        .get(baseUrl + 'search?search=$search&page=$page&size=$size', headers: {
      HttpHeaders.authorizationHeader: 'Bearer ' +
          'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0aG9jaHVwaGluaCIsImlhdCI6MTYwMjMwMzQ5NCwiZXhwIjoxNjE3ODU1NDk0fQ.25Oz4rCRj4pdX6GdpeWdwt1YT7fcY6YTKK8SywVyWheVPGpwB6641yHNz7U2JwlgNUtI3FE89Jf8qwWUXjfxRg'
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      final listPtgs = data['photographers'] as List;
      final listPackages = data['packages'] as List;

      final List<Photographer> photographers = listPtgs.map((photographer) {
        return Photographer(
          id: photographer['id'],
          fullname: photographer['fullname'].toString(),
          avatar: photographer['avatar'].toString(),
          ratingCount: photographer['ratingCount'] == 0.0
              ? 4.7
              : photographer['ratingCount'],
        );
      }).toList();

      final List<PackageBlocModel> packages = listPackages.map((package) {
        final listServices = package['services'] as List;

        final services = listServices.map((service) {
          return ServiceBlocModel(id: service['id'], name: service['name']);
        }).toList();

        final tempPhotographer = package['photographer'] as Map;
        final ptg = Photographer(
            id: tempPhotographer['id'],
            avatar: tempPhotographer['avatar'],
            fullname: tempPhotographer['fullname']);

        return PackageBlocModel(
          id: package['id'],
          name: package['name'].toString(),
          price: package['price'],
          description: package['description'].toString(),
          photographer: ptg,
          serviceDtos: services,
        );
      }).toList();

      final searchModel =
          SearchModel(packages: packages, photographers: photographers);

      return searchModel;
    } else {
      throw Exception('Error getting list of photographers');
    }
  }

  Future<Photographer> getPhotographerbyId(int id) async {
    final response = await this.httpClient.get(baseUrl + id.toString());
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));

      final photographer = Photographer(
        id: data['id'],
        avatar: data['avatar'],
        cover: data['cover'],
        booked: data['booked'],
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
