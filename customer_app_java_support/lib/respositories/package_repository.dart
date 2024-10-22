import 'dart:convert';
import 'dart:io';
import 'package:customer_app_java_support/globals.dart';
import 'package:customer_app_java_support/models/package_bloc_model.dart';
import 'package:customer_app_java_support/models/service_bloc_model.dart';
import 'package:customer_app_java_support/shared/base_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const baseUrl = 'https://pbs-webapi.herokuapp.com/api/';

class PackageRepository {
  final http.Client httpClient;

  PackageRepository({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<PackageBlocModel>> getPackagesByPhotographerId(int id) async {
    final response = await this.httpClient.get(
        BaseApi.PACKAGE_URL + '/photographer/$id/split',
        headers: {HttpHeaders.authorizationHeader: 'Bearer ' + globalCusToken});

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      final list = data['package'] as List;

      final List<PackageBlocModel> packages = list.map((package) {
        final listServices = package['serviceDtos'] as List;

        final services = listServices.map((service) {
          return ServiceBlocModel(id: service['id'], name: service['name']);
        }).toList();

        return PackageBlocModel(
          id: package['id'],
          name: package['name'].toString(),
          timeAnticipate: package['timeAnticipate'],
          price: package['price'],
          supportMultiDays: package['supportMultiDays'],
          description: package['description'].toString(),
          serviceDtos: services,
        );
      }).toList();

      return packages;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Error getting list of photographers');
    }
  }
}
